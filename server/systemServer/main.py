import os
import psycopg2
from dotenv import load_dotenv
from flask import Flask, request
import numpy as np
import pickle

load_dotenv()

app = Flask(__name__)

url = os.getenv("DATABASE_URL")
connection = psycopg2.connect(url)

CREATE_ADMIN = (
    "CREATE TABLE IF NOT EXISTS users ( id SERIAL PRIMARY KEY, username VARCHAR(255) NOT NULL, password VARCHAR(255) NOT NULL);"
)

INSERT_ADMIN = ("INSERT INTO users (username, password) VALUES ('admin', 'admin123');")

SELECT_USER = ("SELECT id, username FROM users WHERE username = %s AND password = %s;")

INSERT_CASE = ("INSERT INTO cases (status,fraudaccount_id,fraudtransaction_id) VALUES ('open', %s, %s);")

CLOSE_CASE = ("UPDATE cases SET status = 'close' WHERE open_case_id = %s;")

SELECT_FRAUD_ACC = ("SELECT * FROM fraudaccounts WHERE customer_id = %s;")

INSERT_FRAUD_ACC = ("INSERT INTO fraudaccounts (customer_id,first_name,last_name,account_balance,age,address,mobileno,addharno,lastlogin,branchid,account_type,emailid,upi_id,account_number,pancard_number,city) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s);")

@app.route('/')
def hello_world():
    return 'Hello, World!'

# Admin Apis

@app.post('/api/admin/createAdmin')
def createAdmin():
    with connection:
        with connection.cursor() as cursor:
            cursor.execute(CREATE_ADMIN)
            cursor.execute(INSERT_ADMIN)
    return("Admin created"), 201

@app.post('/api/admin/login')
def adminLogin():
    data = request.get_json()
    username = data['username']
    password = data['password']

    try:
        with connection:
            with connection.cursor() as cursor:
                cursor.execute(SELECT_USER, (username, password))
                user_data = cursor.fetchone()

        if user_data:
            user_id, user_username = user_data
            return {"id": user_id, "username": user_username, "message": "Login successful."}, 200
        else:
            return {"error": "Invalid username or password."}, 401

    except Exception as e:
        return {"error": str(e)}, 500

#calculating diff function
def balance_diff(data):
    #Sender's balance
    orig_change=data['newbalanceOrig']-data['oldbalanceOrg']
    orig_change=orig_change.astype(int)
    data['orig_txn_diff']=round(data['amount']+orig_change,2)
    data['orig_txn_diff']=round(data['amount']-orig_change,2)
    data['orig_txn_diff']=data['orig_txn_diff'].astype(int)
    data['orig_diff'] = [1 if n !=0 else 0 for n in data['orig_txn_diff']] 
    
    #Receiver's balance
    dest_change=data['newbalanceDest']-data['oldbalanceDest']
    dest_change=dest_change.astype(int)
    data['dest_txn_diff']=round(data['amount']+dest_change,2)
    data['dest_txn_diff']=round(data['amount']-dest_change,2)
    data['dest_txn_diff']=data['dest_txn_diff'].astype(int)
    data['dest_diff'] = [1 if n !=0 else 0 for n in data['dest_txn_diff']] 

    data = data.pop("orig_txn_diff")
    data = data.pop("orig_txn_diff")
    
    return(data)

#Surge indicator
def surge_indicator(data):
    data['surge']=[1 if n>450000 else 0 for n in data['amount']]
    return(data)

#Save transaction to system database
@app.route('/api/insertSystemTransactions', methods=['POST'])
def saveTransaction():
    data = request.get_json()
    transaction_fraud_detection = pickle.load(open('transaction_fraud_detection.pkl','rb'))
    # [step, amount,	oldbalanceOrg,	newbalanceOrig,	oldbalanceDest,	newbalanceDest,	orig_diff,	dest_diff,	surge,	freq_dest,	type__CASH_IN,	type__CASH_OUT,	type__DEBIT,	type__PAYMENT,	type__TRANSFER,	customers_org,	customers_des]
    model_data = [1]
    model_data.append(data['sender_account'])
    model_data.append(data['oldbalanceorg'])
    model_data.append(data['newbalanceorig'])
    model_data.append(data['oldbalancedest'])
    model_data.append(data['newbalancedest'])
    M_data = balance_diff(data)
    model_data.append(M_data['orig_diff'])
    model_data.append(M_data['dest_diff'])
    M_data = surge_indicator(M_data)
    model_data.append(M_data['surge'])
    frequency_indicator_query = """SELECT COUNT(*) AS row_count FROM system_transaction WHERE receiver_account = %s;"""
    query = """
        INSERT INTO system_transaction (
            transactionid, tansactiontype, oldbalanceorg,
            newbalanceorig, oldbalancedest, newbalancedest, transaction_date,sender_account,receiver_account,ip_address_sender,fraud_transaction
        ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        RETURNING FraudTransaction_id;
    """
    try:
        with connection:
            with connection.cursor() as cursor:
                cursor.execute(frequency_indicator_query,data['receiver_account'])
                f_count = cursor.fetchone()[0]
                model_data.append(f_count)
                array_data_2d = np.array(model_data).reshape(1, -1)
                prediction = transaction_fraud_detection.predict_proba(array_data_2d)
                output = '{0:.{1}f}'.format(prediction[0][1],2)
                if output == 0:
                    data['fraud_transaction'] = True
                else:
                    data['fraud_transaction'] = False
                values = (data['transactionid'], data['tansactiontype'],data['oldbalanceorg'], data['newbalanceorig'],data['oldbalancedest'],data['newbalancedest'], data['transaction_date'], data['sender_account'], data['receiver_account'], data['ip_address_sender'],data['fraud_transaction'])
                cursor.execute(query,values)
                trans_id = cursor.fetchone()['fraudtransaction_id']
                #Database notification
                #User sms notification
        if trans_id :
            #check if the transaction is fraud
            return jsonify({'fraud_transaction_id': fraud_transaction_id}), 201
        else :
            return ("Error")
    except Exception as e:
        return {"error": str(e)}, 500

# #Fraud transaction detection api
# transaction_fraud_detection = pickle.load(open('transaction_fraud_detection.pkl','rb'))
# @app.route('/api/model/fraudTransactionPrediction',methods=['POST','GET'])
# def transactionPrediction():
#     data = request.get_json()
#     array_data = data.get('array_data', [])
#     array_data_2d = np.array(array_data).reshape(1, -1)
#     # [step	amount,	oldbalanceOrg,	newbalanceOrig,	oldbalanceDest,	newbalanceDest,	orig_diff,	dest_diff,	surge,	freq_dest,	type__CASH_IN,	type__CASH_OUT,	type__DEBIT,	type__PAYMENT,	type__TRANSFER,	customers_org,	customers_des]
#     prediction = transaction_fraud_detection.predict_proba(array_data_2d)
#     output = '{0:.{1}f}'.format(prediction[0][1],2)
#     if output == 0:
        
#         return("Not Fraud")
#     else:
#         return("Fraud")

#Case CRUD

@app.route("/api/case/openCase", methods=["POST"])
def openCase():
    data = request.get_json()
    fraudaccount_id = data['fraudaccount_id']
    fraudtransaction_id = data['fraudtransaction_id']
    try:
        with connection:
            with connection.cursor() as cursor:
                cursor.execute(INSERT_CASE,(fraudaccount_id,fraudtransaction_id))
        return("Case opened"), 200
    except Exception as e:
        return {"error": str(e)},500

@app.route("/api/case/closeCase", methods=["POST"])
def closeCase():
    data = request.get_json()
    open_case_id = data['open_case_id']
    try:
        with connection:
            with connection.cursor() as cursor:
                cursor.execute(CLOSE_CASE,(open_case_id))
        return("Case closed"), 200
    except Exception as e:
        return {"error": str(e)},500

#Add confirmed fraud account 
@app.route("/api/addFraudAccount", methods=["POST"])
def addFraudAccount():
    data = request.get_json()
    customer_id = data['customer_id']
    first_name = data['first_name']
    last_name = data['last_name']
    account_balance = data['account_balance']
    age = data['age']
    address = data['address']
    mobileno = data['mobileno']
    addharno = data['lastlogin']
    lastlogin = data['lastlogin']
    branchid = data['branchid']
    account_type = data['account_type']
    emailid = data['emailid']
    upi_id = data['upi_id']
    account_number = data['account_number']
    pancard_number = data['pancard_number']
    city = data['city']
    try:
        with connection:
            with connection.cursor() as cursor:
                cursor.execute(SELECT_FRAUD_ACC,(customer_id))
                result = cursor.fetchone()
                if result:
                    return ("Account already in the list"), 200
                else:
                    cursor.execute(INSERT_FRAUD_ACC, (customer_id,first_name,last_name,account_balance,age,address,mobileno,addharno,lastlogin,branchid,account_type,emailid,upi_id,account_number,pancard_number,city))
                    return("Account added"), 200

    except Exception as e:
        return {"error": str(e)},500

# Model apis 


Fraud_account_detection = pickle.load(open('Fraud_account_detection.pkl','rb'))
@app.route('/api/model/fraudAccountPrediction',methods=['POST','GET'])
def accountPrediction():
    data = request.get_json()
    array_data = data.get('array_data', [])
    array_data_2d = np.array(array_data).reshape(1, -1)
    # ['current_address_months_count', 'customer_age', 'days_since_request',
    #    'intended_balcon_amount', 'zip_count_4w', 'velocity_6h', 'velocity_24h',
    #    'velocity_4w', 'bank_branch_count_8w',
    #    'date_of_birth_distinct_emails_4w', 'credit_risk_score',
    #    'email_is_free', 'phone_home_valid', 'has_other_cards',
    #    'proposed_credit_limit', 'month', 'payment_type_encoded',
    #    'employment_status_encoded', 'housing_status_encoded',
    #    'application_velocity']
    prediction = Fraud_account_detection.predict_proba(array_data_2d)
    output = '{0:.{1}f}'.format(prediction[0][1],2)
    if output == 0:
        return("Not Fraud")
    else:
        return("Fraud")


if __name__ == "__main__":

    app.run(debug=True, port=8000)