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
  Permissions accordées : STOCKES (lecture seule depuis les applications externes)
*/
GRANT SELECT, update, insert, delete ON stockES to cpottiez;
GRANT SELECT, update, insert, delete ON stockES to hhamelin;
GRANT SELECT, update, insert, delete ON stockES to zvergne;
GRANT SELECT, update, insert, delete ON stockES to jcharlesni;
GRANT SELECT, update, insert, delete ON stockES to hcburca;

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
  Permissions accordées : DETAILS_COMMANDESES (lecture seule depuis les applications externes)
*/
GRANT SELECT, update, insert, delete ON details_commandeses to cpottiez;
GRANT SELECT, update, insert, delete ON details_commandeses to hhamelin;
GRANT SELECT, update, insert, delete ON details_commandeses to zvergne;
GRANT SELECT, update, insert, delete ON details_commandeses to jcharlesni;
GRANT SELECT, update, insert, delete ON details_commandeses to hcburca;

/*
  Permissions accordées : COMMANDESES (lecture seule depuis les applications externes)
*/
GRANT SELECT, update, insert, delete on commandeses TO cpottiez;
GRANT SELECT, update, insert, delete on commandeses TO hhamelin;
GRANT SELECT, update, insert, delete on commandeses TO zvergne;
GRANT SELECT, update, insert, delete on commandeses TO jcharlesni;
GRANT SELECT, update, insert, delete on commandeses TO hcburca;

/*
  Permissions accordées : CLIENTSES (lecture seule depuis les applications externes)
*/
GRANT SELECT, update, insert, delete on clientses TO cpottiez;
GRANT SELECT, update, insert, delete on clientses TO hhamelin;
GRANT SELECT, update, insert, delete on clientses TO zvergne;
GRANT SELECT, update, insert, delete on clientses TO jcharlesni;
GRANT SELECT, update, insert, delete on clientses TO hcburca;

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


alter table stockES add constraint fk_stockESproduits foreign key (REF_PRODUIT) REFERENCES Produits;


/*
  Création des vues
*/
-- Vue "Stock"
CREATE OR REPLACE VIEW Stock
AS
(SELECT * FROM StockES 
UNION
SELECT * FROM cpottiez.stockEN@dblinkMain
UNION 
SELECT * FROM cpottiez.stockOI@dblinkMain
UNION 
SELECT * FROM hcburca.stock_am@dbLinkUS
);

SELECT * FROM Stock;

--Vue 'Clients'
CREATE OR REPLACE VIEW Clients
AS
(SELECT * FROM ClientsES 
UNION
SELECT * FROM cpottiez.clientsEN@dblinkMain
UNION 
SELECT * FROM cpottiez.clientsOI@dblinkMain
UNION 
SELECT * FROM hcburca.Clients_AM@dbLinkUS
);

--Vue 'Commandes'
CREATE OR REPLACE VIEW Commandes
AS
(SELECT * FROM Commandeses 
UNION
SELECT * FROM cpottiez.commandesEN@dblinkMain
UNION 
SELECT * FROM cpottiez.commandesOI@dblinkMain
UNION 
SELECT * FROM hcburca.Commandes_AM@dbLinkUS
);


-- Vue 'Details_Commande'
CREATE OR REPLACE VIEW details_commandes
AS
(SELECT * FROM details_commandeses 
UNION
SELECT * FROM cpottiez.details_commandesEN@dblinkMain
UNION 
SELECT * FROM cpottiez.details_commandesOI@dblinkMain
UNION 
SELECT * FROM hcburca.Details_Commandes_AM@dbLinkUS
);

--Vue fournisseurs
CREATE OR REPLACE VIEW Fournisseurs
AS
(SELECT * FROM cpottiez.fournisseurs@dblinkmain);



select * from clients;
select * from stock;
select * from produits;
select * from details_commandes;
select * from commandes;
select * from fournisseurs;
select * from categories;

--  <!>  A COMPILER QUAND PERMISSIONS ACCORDEES <!>
desc produits;



/*
  Trigger : vérifie si le fournisseur inséré dans la table Produits est bien référencé
  Vérifie au cours de la suppression d'un produit que celui-ci n'est pas déjà présent dans une des tables DétailsCommande ou stocks
*/
CREATE OR REPLACE TRIGGER chk_Produits BEFORE INSERT OR UPDATE OR DELETE ON Produits
FOR EACH ROW
DECLARE 
idFourn number; --Id du fournisseur renseigné à vérifier
any_rows_found NUMBER;  --variable indiquant si un produit à supprimer existe dans une table secondaire

BEGIN
	IF INSERTING OR UPDATING THEN 
	  SELECT NO_FOURNISSEUR INTO idFourn
	  from cpottiez.Fournisseurs@dblinkMain rel
	  where rel.NO_FOURNISSEUR = :NEW.NO_FOURNISSEUR;
	END IF;
  
  IF DELETING THEN
    
    SELECT count(*) into any_rows_found
    from cpottiez.details_commandesEN@dblinkMain
    where ref_produit = :NEW.REF_PRODUIT;
    
    IF any_rows_found <> 0 THEN
      raise_application_error(-20002, 'Erreur : le produit à supprimer est déjà référencé dans la table DétailsCommandes en Europe du Nord');
    end if;
    
    SELECT count(*) INTO any_rows_found
    FROM cpottiez.details_commandesOI@dblinkMain
    WHERE ref_produit = :NEW.REF_PRODUIT;
    
    IF any_rows_found <> 0 THEN
      raise_application_error(-20003, 'Erreur : le produit à supprimer est déjà référencé dans la table DétailsCommandes pour un pays inconnu');
    end if;
    
    SELECT count(*) INTO any_rows_found
    FROM hcburca.Details_Commandes_AM@dbLinkUS
    WHERE ref_produit = :NEW.REF_PRODUIT;
    
    IF any_rows_found <> 0 THEN
      raise_application_error(-20004, 'Erreur : le produit à supprimer est déjà référencé dans la table DétailsCommandes en Amérique');
    end if;
    
    SELECT count(*) INTO any_rows_found
    FROM cpottiez.stockEN@dblinkMain
    WHERE ref_produit = :NEW.REF_PRODUIT;
    
    IF any_rows_found <> 0 THEN
      raise_application_error(-20005, 'Erreur : le produit à supprimer est déjà référencé dans la table Stocks en Europe du Nord');
    end if;
    
    SELECT count(*) INTO any_rows_found
    FROM cpottiez.stockOI@dblinkMain
    WHERE ref_produit = :NEW.REF_PRODUIT;
    
    IF any_rows_found <> 0 THEN
      raise_application_error(-20006, 'Erreur : le produit à supprimer est déjà référencé dans la table Stocks pour un pays inconnu');
    end if;
    
    
    SELECT count(*) INTO any_rows_found
    FROM hcburca.Stock_AM@dbLinkUS
    WHERE ref_produit = :NEW.REF_PRODUIT;
    
    IF any_rows_found <> 0 THEN
      raise_application_error(-20007, 'Erreur : le produit à supprimer est déjà référencé dans la table Stocks en Amérique');
    end if;
  END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN 
    RAISE_APPLICATION_ERROR(-20002, 'Erreur : tout fournisseur référencé doit exister dans la table des fournisseurs');
END;
/

/*
  Tests : contrainte d'intégrité de produits
*/
insert into produits values(89, 'starwax', 12, 1,12,45);    --Fonctionne : le fournisseur 12 existe
delete from produits where ref_produit=89;      --Fonctionne : le produit existe bien
insert into produits values(89, 'starwax', 118, 1,12,45);    --Ne fonctionne pas : le fournisseur 118 n'existe pas...
-- A tester : insertion du produit dans stock et/ou details_commande et supprimer le produit ainsi inséré pour vérifier la contrainte d'intégrité


/*
  Tests : insertion dans la vue stock
*/
select * from stock;
desc stock;
insert into stock values (2, 'Portugal', 4, 6 ,0);       --Fonctionne : le pays est en adéquation avec la relation fragmentée (stocks d'Europe du Sud)
delete from stock where ref_produit=2 and pays='Portugal';    -- Fonctionne : le pays a été inséré

insert into stock values (2, 'Allemagne', 4, 6 ,0);   --Ne fonctionne pas : le pays n'appartient pas à l'Europe du Sud
delete from stock where ref_produit = 1 and pays = 'Allemagne';  --Ne fonctionne pas : le pays n'appartient pas à l'Europe du Sud



