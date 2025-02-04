PGDMP  6                     |            postgres    16.1    16.1 ,               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    5    postgres    DATABASE     �   CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';
    DROP DATABASE postgres;
                postgres    false                       0    0    DATABASE postgres    COMMENT     N   COMMENT ON DATABASE postgres IS 'default administrative connection database';
                   postgres    false    4884                        3079    16384 	   adminpack 	   EXTENSION     A   CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;
    DROP EXTENSION adminpack;
                   false                       0    0    EXTENSION adminpack    COMMENT     M   COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';
                        false    2            �            1259    16422    branch    TABLE     �   CREATE TABLE public.branch (
    branch_id integer NOT NULL,
    branchname character varying(50),
    branch_code character varying(10),
    bankaddress text,
    phone character varying(15)
);
    DROP TABLE public.branch;
       public         heap    postgres    false            �            1259    16421    branch_branch_id_seq    SEQUENCE     �   CREATE SEQUENCE public.branch_branch_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.branch_branch_id_seq;
       public          postgres    false    217                       0    0    branch_branch_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.branch_branch_id_seq OWNED BY public.branch.branch_id;
          public          postgres    false    216            �            1259    16464    customer_profile    TABLE     /  CREATE TABLE public.customer_profile (
    customer_id integer NOT NULL,
    first_name character varying(50),
    last_name character varying(50),
    account_balance numeric(15,2),
    age integer,
    address text,
    mobileno character varying(15),
    addharno character varying(12),
    lastlogin date,
    branchid integer,
    account_type character varying(20),
    emailid character varying(50),
    upi_id character varying(50),
    account_number character varying(20),
    pancard_number character varying(15),
    city character varying(50)
);
 $   DROP TABLE public.customer_profile;
       public         heap    postgres    false            �            1259    16463     customer_profile_customer_id_seq    SEQUENCE     �   CREATE SEQUENCE public.customer_profile_customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 7   DROP SEQUENCE public.customer_profile_customer_id_seq;
       public          postgres    false    225                       0    0     customer_profile_customer_id_seq    SEQUENCE OWNED BY     e   ALTER SEQUENCE public.customer_profile_customer_id_seq OWNED BY public.customer_profile.customer_id;
          public          postgres    false    224            �            1259    16431    customerprofile    TABLE     .  CREATE TABLE public.customerprofile (
    customer_id integer NOT NULL,
    first_name character varying(50),
    last_name character varying(50),
    account_balance numeric(15,2),
    age integer,
    address text,
    mobileno character varying(15),
    addharno character varying(12),
    lastlogin date,
    branchid integer,
    account_type character varying(20),
    emailid character varying(50),
    upi_id character varying(50),
    account_number character varying(20),
    pancard_number character varying(15),
    city character varying(50)
);
 #   DROP TABLE public.customerprofile;
       public         heap    postgres    false            �            1259    16430    customerprofile_customer_id_seq    SEQUENCE     �   CREATE SEQUENCE public.customerprofile_customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.customerprofile_customer_id_seq;
       public          postgres    false    219                       0    0    customerprofile_customer_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.customerprofile_customer_id_seq OWNED BY public.customerprofile.customer_id;
          public          postgres    false    218            �            1259    16445    fraudaccounts    TABLE     w   CREATE TABLE public.fraudaccounts (
    fraudaccount_id integer NOT NULL,
    customer_id integer,
    flag boolean
);
 !   DROP TABLE public.fraudaccounts;
       public         heap    postgres    false            �            1259    16444 !   fraudaccounts_fraudaccount_id_seq    SEQUENCE     �   CREATE SEQUENCE public.fraudaccounts_fraudaccount_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 8   DROP SEQUENCE public.fraudaccounts_fraudaccount_id_seq;
       public          postgres    false    221                       0    0 !   fraudaccounts_fraudaccount_id_seq    SEQUENCE OWNED BY     g   ALTER SEQUENCE public.fraudaccounts_fraudaccount_id_seq OWNED BY public.fraudaccounts.fraudaccount_id;
          public          postgres    false    220            �            1259    16457    transactiontable    TABLE     $  CREATE TABLE public.transactiontable (
    transactionid integer NOT NULL,
    transactiontype character varying(20),
    amount_before_transaction numeric(15,2),
    amount_after_transaction numeric(15,2),
    transaction_date date,
    from_account_id integer,
    to_account_id integer
);
 $   DROP TABLE public.transactiontable;
       public         heap    postgres    false            �            1259    16456 "   transactiontable_transactionid_seq    SEQUENCE     �   CREATE SEQUENCE public.transactiontable_transactionid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 9   DROP SEQUENCE public.transactiontable_transactionid_seq;
       public          postgres    false    223                       0    0 "   transactiontable_transactionid_seq    SEQUENCE OWNED BY     i   ALTER SEQUENCE public.transactiontable_transactionid_seq OWNED BY public.transactiontable.transactionid;
          public          postgres    false    222            e           2604    16425    branch branch_id    DEFAULT     t   ALTER TABLE ONLY public.branch ALTER COLUMN branch_id SET DEFAULT nextval('public.branch_branch_id_seq'::regclass);
 ?   ALTER TABLE public.branch ALTER COLUMN branch_id DROP DEFAULT;
       public          postgres    false    216    217    217            i           2604    16467    customer_profile customer_id    DEFAULT     �   ALTER TABLE ONLY public.customer_profile ALTER COLUMN customer_id SET DEFAULT nextval('public.customer_profile_customer_id_seq'::regclass);
 K   ALTER TABLE public.customer_profile ALTER COLUMN customer_id DROP DEFAULT;
       public          postgres    false    225    224    225            f           2604    16434    customerprofile customer_id    DEFAULT     �   ALTER TABLE ONLY public.customerprofile ALTER COLUMN customer_id SET DEFAULT nextval('public.customerprofile_customer_id_seq'::regclass);
 J   ALTER TABLE public.customerprofile ALTER COLUMN customer_id DROP DEFAULT;
       public          postgres    false    219    218    219            g           2604    16448    fraudaccounts fraudaccount_id    DEFAULT     �   ALTER TABLE ONLY public.fraudaccounts ALTER COLUMN fraudaccount_id SET DEFAULT nextval('public.fraudaccounts_fraudaccount_id_seq'::regclass);
 L   ALTER TABLE public.fraudaccounts ALTER COLUMN fraudaccount_id DROP DEFAULT;
       public          postgres    false    220    221    221            h           2604    16460    transactiontable transactionid    DEFAULT     �   ALTER TABLE ONLY public.transactiontable ALTER COLUMN transactionid SET DEFAULT nextval('public.transactiontable_transactionid_seq'::regclass);
 M   ALTER TABLE public.transactiontable ALTER COLUMN transactionid DROP DEFAULT;
       public          postgres    false    222    223    223                      0    16422    branch 
   TABLE DATA           X   COPY public.branch (branch_id, branchname, branch_code, bankaddress, phone) FROM stdin;
    public          postgres    false    217   @8                 0    16464    customer_profile 
   TABLE DATA           �   COPY public.customer_profile (customer_id, first_name, last_name, account_balance, age, address, mobileno, addharno, lastlogin, branchid, account_type, emailid, upi_id, account_number, pancard_number, city) FROM stdin;
    public          postgres    false    225   9                 0    16431    customerprofile 
   TABLE DATA           �   COPY public.customerprofile (customer_id, first_name, last_name, account_balance, age, address, mobileno, addharno, lastlogin, branchid, account_type, emailid, upi_id, account_number, pancard_number, city) FROM stdin;
    public          postgres    false    219   #9       
          0    16445    fraudaccounts 
   TABLE DATA           K   COPY public.fraudaccounts (fraudaccount_id, customer_id, flag) FROM stdin;
    public          postgres    false    221   �:                 0    16457    transactiontable 
   TABLE DATA           �   COPY public.transactiontable (transactionid, transactiontype, amount_before_transaction, amount_after_transaction, transaction_date, from_account_id, to_account_id) FROM stdin;
    public          postgres    false    223   �:                  0    0    branch_branch_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.branch_branch_id_seq', 5, true);
          public          postgres    false    216                       0    0     customer_profile_customer_id_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public.customer_profile_customer_id_seq', 1, false);
          public          postgres    false    224                       0    0    customerprofile_customer_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.customerprofile_customer_id_seq', 4, true);
          public          postgres    false    218                       0    0 !   fraudaccounts_fraudaccount_id_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public.fraudaccounts_fraudaccount_id_seq', 1, true);
          public          postgres    false    220                        0    0 "   transactiontable_transactionid_seq    SEQUENCE SET     P   SELECT pg_catalog.setval('public.transactiontable_transactionid_seq', 1, true);
          public          postgres    false    222            k           2606    16429    branch branch_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_pkey PRIMARY KEY (branch_id);
 <   ALTER TABLE ONLY public.branch DROP CONSTRAINT branch_pkey;
       public            postgres    false    217            s           2606    16471 &   customer_profile customer_profile_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public.customer_profile
    ADD CONSTRAINT customer_profile_pkey PRIMARY KEY (customer_id);
 P   ALTER TABLE ONLY public.customer_profile DROP CONSTRAINT customer_profile_pkey;
       public            postgres    false    225            m           2606    16438 $   customerprofile customerprofile_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY public.customerprofile
    ADD CONSTRAINT customerprofile_pkey PRIMARY KEY (customer_id);
 N   ALTER TABLE ONLY public.customerprofile DROP CONSTRAINT customerprofile_pkey;
       public            postgres    false    219            o           2606    16450     fraudaccounts fraudaccounts_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY public.fraudaccounts
    ADD CONSTRAINT fraudaccounts_pkey PRIMARY KEY (fraudaccount_id);
 J   ALTER TABLE ONLY public.fraudaccounts DROP CONSTRAINT fraudaccounts_pkey;
       public            postgres    false    221            q           2606    16462 &   transactiontable transactiontable_pkey 
   CONSTRAINT     o   ALTER TABLE ONLY public.transactiontable
    ADD CONSTRAINT transactiontable_pkey PRIMARY KEY (transactionid);
 P   ALTER TABLE ONLY public.transactiontable DROP CONSTRAINT transactiontable_pkey;
       public            postgres    false    223            t           2606    16439 -   customerprofile customerprofile_branchid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.customerprofile
    ADD CONSTRAINT customerprofile_branchid_fkey FOREIGN KEY (branchid) REFERENCES public.branch(branch_id);
 W   ALTER TABLE ONLY public.customerprofile DROP CONSTRAINT customerprofile_branchid_fkey;
       public          postgres    false    219    217    4715            u           2606    16451 ,   fraudaccounts fraudaccounts_customer_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.fraudaccounts
    ADD CONSTRAINT fraudaccounts_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customerprofile(customer_id);
 V   ALTER TABLE ONLY public.fraudaccounts DROP CONSTRAINT fraudaccounts_customer_id_fkey;
       public          postgres    false    221    4717    219               �   x�U��
�@����S�����s�(歋��Rm!+�۷���a.?�A(^�мo���1���U�<�ÆZ�;@D&�`2F4�5kF&@�����rPJ1�5KbDB�kV�L�I3zp�[�cKӔe1���C�Y��H��sAL���0.��|��YZ���ߝ%L��/�������JT            x������ � �         i  x�M��N�@E�7_�Pr�o��h5��D�/�vR�������	3@&Y{e���G�����vtH�(&���rU�O[��ѽ�
�CFd�Ԋ4R"��F�ZH����PX�O_n*[p�r�ƛ���x��g�&&#�4.���4O3s�.1��	E�����N-�߯���b�k��;�(��&�i���j�­v,�-C�upcw���U��4�J
������9��?/R��������k��Jp�ם�,T��r����ry/� O�m�Ww`�Z��4�?<�{����m{U(�$���xz�'�_�MhXB�3�S��i��k��֣+�*_c��#{P�N���=��������-���6Y�P      
      x�3�4�,����� 
��         1   x�3�)J�+NK-�4500�30�41��FF&�@d�i�i����� �	S     