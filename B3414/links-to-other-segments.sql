CREATE DATABASE LINK tplink CONNECT TO hcburca IDENTIFIED BY mdporacle USING 'DB1';
CREATE DATABASE LINK linkES CONNECT TO hcburca IDENTIFIED BY mdporacle USING 'DB3';

-- tester links
Select * from cpottiez.ClientsEN@tplink;
Select * from lpoisse.Produits@linkES;