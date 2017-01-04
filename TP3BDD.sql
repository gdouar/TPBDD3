drop database link dblinkMain;
/*
  Liens de BDD
*/
create database link dblinkMain CONNECT TO lpoisse IDENTIFIED BY mdporacle USING 'DB1';
CREATE DATABASE LINK dbLinkUS CONNECT TO lpoisse IDENTIFIED BY mdporacle USING 'DB4';


/*
  Création de la table clients de l'europe du Sud AVEC Autriche/Suisse
*/
CREATE TABLE clientsES as 
(SELECT * FROM ryori.clients@dblinkMain 
WHERE pays IN ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 'Autriche', 'Suisse'));

select * from cpottiez.fournisseurs@dblinkMain;
/*
  Création de la table commandes de l'europe du Sud
*/
CREATE TABLE commandesES as 
(
SELECT * from ryori.commandes@dblinkMain WHERE NO_COMMANDE IN (
SELECT NO_COMMANDE FROM (
SELECT * FROM ryori.commandes@dblinkMain com NATURAL JOIN ryori.clients@dblinkMain cli
WHERE cli.pays IN ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 'Autriche', 'Suisse'))
));

/*
  Création de la table détails des commandes de l'europe du Sud
*/
CREATE TABLE details_commandesES as 
(
SELECT * from ryori.details_commandes@dblinkMain WHERE NO_COMMANDE IN (
SELECT NO_COMMANDE FROM (
SELECT * FROM ryori.commandes@dblinkMain com NATURAL JOIN ryori.clients@dblinkMain cli
WHERE cli.pays IN ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 'Autriche', 'Suisse'))
));


/*
  Création de la table détails des commandes de l'europe du Sud
*/
CREATE TABLE stockES as 
(
SELECT * from ryori.stock@dblinkMain  
WHERE pays IN ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 'Autriche', 'Suisse'));

/*
  Création de la table Produits à partir de l'originale 
*/
CREATE TABLE produits as 
(
SELECT * from ryori.produits@dblinkMain);

/*
  Création de la table Catégories à partir de l'originale 
*/
CREATE TABLE CATEGORIES as 
(
SELECT * from ryori.CATEGORIES@dblinkMain);

/*
  Permissions accordées : STOCK (lecture seule depuis les applications externes)
*/
GRANT select ON stockES to cpottiez;
GRANT select ON stockES to hhamelin;
GRANT select ON stockES to zvergne;
GRANT select ON stockES to jcharlesni;
GRANT select ON stockES to hcburca;

/*
  Permissions accordées : PRODUITS (lecture seule depuis les applications externes)
*/
GRANT select ON produits to cpottiez;
GRANT select ON produits to hhamelin;
GRANT select ON produits to zvergne;
GRANT select ON produits to jcharlesni;
GRANT select ON produits to hcburca;

/*
  Permissions accordées : CATEGORIES (lecture seule depuis les applications externes)
*/
GRANT select ON categories to cpottiez;
GRANT select ON categories to hhamelin;
GRANT select ON categories to zvergne;
GRANT select ON categories to jcharlesni;
GRANT select ON categories to hcburca;

/*
  Contraintes : clés primaires
*/
desc clientsES;
ALTER TABLE clientsES ADD CONSTRAINT pk_clientsES PRIMARY KEY (CODE_CLIENT);
ALTER TABLE commandesES ADD CONSTRAINT pk_commandesES PRIMARY KEY (NO_COMMANDE);
ALTER TABLE details_commandesES ADD CONSTRAINT pk_detailsCommandesES PRIMARY KEY (NO_COMMANDE, REF_PRODUIT);
ALTER TABLE stockES ADD CONSTRAINT pk_StockES PRIMARY KEY (REF_PRODUIT, PAYS);
ALTER TABLE produits add constraint pk_produits PRIMARY KEY (REF_PRODUIT);
ALTER TABLE categories ADD CONSTRAINT pk_Categories PRIMARY KEY (CODE_CATEGORIE);


/*
  Contraintes NOT NULL
*/
ALTER TABLE CommandesES ADD CONSTRAINT chk_ccnotnull CHECK (CODE_CLIENT IS NOT NULL);
ALTER TABLE CommandesES ADD CONSTRAINT chk_noempnotnull CHECK (NO_EMPLOYE IS NOT NULL);
ALTER TABLE CommandesES ADD CONSTRAINT chk_datecnotnull CHECK (DATE_COMMANDE IS NOT NULL);

ALTER TABLE CLIENTSES ADD CONSTRAINT chk_socnotnull CHECK (societe IS NOT NULL);
ALTER TABLE CLIENTSES ADD CONSTRAINT chk_adrnull CHECK (adresse IS NOT NULL);
ALTER TABLE CLIENTSES ADD CONSTRAINT chk_villenotnull CHECK (ville IS NOT NULL);
ALTER TABLE CLIENTSES ADD CONSTRAINT chk_cpnotnull CHECK (code_postal IS NOT NULL);
ALTER TABLE CLIENTSES ADD CONSTRAINT chk_paysClientnotnull CHECK (pays IS NOT NULL);
ALTER TABLE CLIENTSES ADD CONSTRAINT chk_telnotnull CHECK (telephone IS NOT NULL);

ALTER TABLE DETAILS_Commandeses ADD CONSTRAINT chk_nocom CHECK (no_commande IS NOT NULL);
ALTER TABLE DETAILS_Commandeses ADD CONSTRAINT chk_refpdtnotnull CHECK (REF_PRODUIT IS NOT NULL);
ALTER TABLE DETAILS_Commandeses ADD CONSTRAINT chk_unprixnotnull CHECK (PRIX_UNITAIRE IS NOT NULL);
ALTER TABLE DETAILS_Commandeses ADD CONSTRAINT chk_quantnotnull CHECK (quantite IS NOT NULL);
ALTER TABLE DETAILS_Commandeses ADD CONSTRAINT chk_remisenotnull CHECK (remise IS NOT NULL);

ALTER TABLE stockes ADD CONSTRAINT chk_stockrefpdtnotnull CHECK (ref_produit IS NOT NULL);
ALTER TABLE stockes ADD CONSTRAINT chk_stockespays CHECK (pays IS NOT NULL);

/

/*
  Trigger : "clés étrangères"/prédicats de vérification à l'insertion
*/
CREATE OR REPLACE TRIGGER chkInsert_Commandes BEFORE INSERT OR UPDATE ON CommandesES
FOR EACH ROW
DECLARE 
idEmp number;

BEGIN
  SELECT No_employe INTO idEmp
  from hcburca.Employes@dbLinkUS rel
  where rel.no_employe = :NEW.no_employe;
  
EXCEPTION
  WHEN NO_DATA_FOUND THEN 
    RAISE_APPLICATION_ERROR(-20001, 'Erreur : tout employé référencé doit exister dans la table des employés');
END;
/
desc details_commandeses;
/*
  FK possibles pour assurer les clés étrangères locales
*/

alter table details_commandeses add constraint fk_detailscmdesproduits foreign key (REF_PRODUIT) REFERENCES Produits;


--     <!> A INSERER DANS LA BASE <!>

alter table stockES add constraint fk_stockESproduits foreign key (REF_PRODUIT) REFERENCES Produits;

/*
  Trigger : vérifie si le fournisseur inséré dans la table Produits est bien référencé
  TODO : ajouter la gestion des suppressions de produits (sur TOUTES les tables Stock/Détail commande)
*/
CREATE OR REPLACE TRIGGER chk_Produits BEFORE INSERT OR UPDATE OR DELETE ON Produits
FOR EACH ROW
DECLARE 
idFourn number;

BEGIN
	IF INSERTING THEN 
	  SELECT NO_FOURNISSEUR INTO idFourn
	  from cpottiez.Fournisseurs@dblinkMain rel
	  where rel.NO_FOURNISSEUR = :NEW.NO_FOURNISSEUR;
	END IF;
  
EXCEPTION
  WHEN NO_DATA_FOUND THEN 
    RAISE_APPLICATION_ERROR(-20002, 'Erreur : tout fournisseur référencé doit exister dans la table des fournisseurs');
END;



desc commandeses;
select * from hcburca.Employes@dbLinkUS;