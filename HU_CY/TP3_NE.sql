-- création de la table pour les clients de l'europe du nord
CREATE TABLE clientsEN AS
  SELECT *
  FROM ryori.clients
  WHERE
    pays IN ('Suede', 'Norvege', 'Danemark', 'Finlande', 'Belgique', 'Irlande', 'Pologne', 'Royaume-Uni', 'Allemagne');

-- création de la table pour les clients d'un nouveau site
CREATE TABLE clientsOI AS
  SELECT *
  FROM ryori.clients
  WHERE pays = 'babla';

-- création table des commandes pour les clients de l'europe du nord
CREATE TABLE commandesEN AS
  SELECT r.*
  FROM clientsEN c, ryori.commandes r
  WHERE c.code_client = r.code_client;

-- création table des commandes pour les clients d'un nouveau site
CREATE TABLE commandesOI AS
  SELECT r.*
  FROM clientsOI c, ryori.commandes r
  WHERE c.code_client = r.code_client;

-- création table de détails des commande pour les clients de l'europe du nord
CREATE TABLE details_commandesEN AS
  SELECT r.*
  FROM commandesEN c, ryori.details_commandes r
  WHERE c.no_commande = r.no_commande;

-- création table de détails des commande pour les clients d'un nouveau site
CREATE TABLE details_commandesOI AS
  SELECT r.*
  FROM commandesOI c, ryori.details_commandes r
  WHERE c.no_commande = r.no_commande;

--création table de stock des sites de l'europe du nord
CREATE TABLE stockEN AS
  SELECT DISTINCT r.*
  FROM clientsEN c, ryori.stock r
  WHERE c.pays = r.pays;

--création table de stock des nouveaux sites
CREATE TABLE stockOI AS
  SELECT DISTINCT r.*
  FROM clientsOI c, ryori.stock r
  WHERE c.pays = r.pays;

-- table fournisseurs
CREATE TABLE fournisseurs AS
  SELECT *
  FROM ryori.fournisseurs;

-- donne les droits de lecture aux autres membres du groupe
GRANT SELECT ON stockEN TO lpoisse;
GRANT SELECT ON stockEN TO zvergne;
GRANT SELECT ON stockEN TO hcburca;
GRANT SELECT ON stockEN TO jcharlesni;
GRANT SELECT ON stockEN TO hhamelin;

GRANT SELECT ON stockOI TO lpoisse;
GRANT SELECT ON stockOI TO zvergne;
GRANT SELECT ON stockOI TO hcburca;
GRANT SELECT ON stockOI TO jcharlesni;
GRANT SELECT ON stockOI TO hhamelin;

GRANT SELECT ON fournisseurs TO lpoisse;
GRANT SELECT ON fournisseurs TO zvergne;
GRANT SELECT ON fournisseurs TO hcburca;
GRANT SELECT ON fournisseurs TO jcharlesni;
GRANT SELECT ON fournisseurs TO hhamelin;

GRANT SELECT ON COMMANDESEN TO lpoisse;
GRANT SELECT ON COMMANDESEN TO zvergne;
GRANT SELECT ON COMMANDESEN TO hcburca;
GRANT SELECT ON COMMANDESEN TO jcharlesni;
GRANT SELECT ON COMMANDESEN TO hhamelin;

GRANT SELECT ON commandesoi TO lpoisse;
GRANT SELECT ON commandesoi TO zvergne;
GRANT SELECT ON commandesoi TO hcburca;
GRANT SELECT ON commandesoi TO jcharlesni;
GRANT SELECT ON commandesoi TO hhamelin;

GRANT SELECT ON details_commandesoi TO lpoisse;
GRANT SELECT ON details_commandesoi TO zvergne;
GRANT SELECT ON details_commandesoi TO hcburca;
GRANT SELECT ON details_commandesoi TO jcharlesni;
GRANT SELECT ON details_commandesoi TO hhamelin;

GRANT SELECT ON details_commandesEn TO lpoisse;
GRANT SELECT ON details_commandesEn TO zvergne;
GRANT SELECT ON details_commandesEn TO hcburca;
GRANT SELECT ON details_commandesEn TO jcharlesni;
GRANT SELECT ON details_commandesEn TO hhamelin;

GRANT SELECT ON clientsen TO lpoisse;
GRANT SELECT ON clientsen TO zvergne;
GRANT SELECT ON clientsen TO hcburca;
GRANT SELECT ON clientsen TO jcharlesni;
GRANT SELECT ON clientsen TO hhamelin;

GRANT SELECT ON clientsoi TO lpoisse;
GRANT SELECT ON clientsoi TO zvergne;
GRANT SELECT ON clientsoi TO hcburca;
GRANT SELECT ON clientsoi TO jcharlesni;
GRANT SELECT ON clientsoi TO hhamelin;

-- contraintes de clé primaire
ALTER TABLE ClientsEN
  ADD CONSTRAINT ClientsENPk PRIMARY KEY (code_client);

ALTER TABLE ClientsOI
  ADD CONSTRAINT ClientsOIPk PRIMARY KEY (code_client);

ALTER TABLE commandesEN
  ADD CONSTRAINT CommandesENPk PRIMARY KEY (no_commande);

ALTER TABLE commandesOI
  ADD CONSTRAINT CommandesOIPk PRIMARY KEY (no_commande);

ALTER TABLE details_commandesEN
  ADD CONSTRAINT Details_commandesENPk PRIMARY KEY (no_commande, ref_produit);

ALTER TABLE details_commandesOI
  ADD CONSTRAINT Details_commandesOIPk PRIMARY KEY (no_commande, ref_produit);

ALTER TABLE fournisseurs
  ADD CONSTRAINT FournisseursPk PRIMARY KEY (no_fournisseur);

ALTER TABLE stockEN
  ADD CONSTRAINT StockENPk PRIMARY KEY (ref_produit, pays);

ALTER TABLE stockOI
  ADD CONSTRAINT StockOIPk PRIMARY KEY (ref_produit, pays);

--contraintes de clé étrangère

ALTER TABLE commandesEN
  ADD CONSTRAINT Fk_ClientsEN FOREIGN KEY (code_client) REFERENCES clientsEN (code_client);

ALTER TABLE commandesOI
  ADD CONSTRAINT Fk_ClientsOI FOREIGN KEY (CODE_CLIENT) REFERENCES CLIENTSOI (CODE_CLIENT);


ALTER TABLE DETAILS_COMMANDESEN
  ADD CONSTRAINT Fk_CommandesEN FOREIGN KEY (NO_COMMANDE) REFERENCES COMMANDESEN (NO_COMMANDE);

ALTER TABLE DETAILS_COMMANDESOI
  ADD CONSTRAINT Fk_CommandesOI FOREIGN KEY (NO_COMMANDE) REFERENCES COMMANDESOI (NO_COMMANDE);

--création de lien vers les autres bds
CREATE DATABASE LINK LinkToDBES
CONNECT TO hhamelin
IDENTIFIED BY mdporacle
USING 'DB3';

CREATE DATABASE LINK LinkToDBUS
CONNECT TO hhamelin
IDENTIFIED BY mdporacle
USING 'DB4';

-----------------------------------
-- trigger pour vérifier la présence de l'employé à l'insertion ou maj dans CommandesEN
CREATE OR REPLACE TRIGGER trg_check_employesEN
BEFORE INSERT OR UPDATE ON COMMANDESEN
FOR EACH ROW
  DECLARE
    Employee NUMBER(6);
  BEGIN
    SELECT e.no_employe
    INTO employee
    FROM hcburca.Employes@LinkToDBUS e
    WHERE e.no_employe = :new.no_employe;

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20001,
                            'Invalid no_employe : There is no Employe with this no_employe in the company !');

  END;

-- trigger pour vérifier la présence de l'employé à l'insertion ou maj dans CommandesOI
CREATE OR REPLACE TRIGGER trg_check_employesOI
BEFORE INSERT OR UPDATE ON COMMANDESOI
FOR EACH ROW
  DECLARE
    Employee NUMBER(6);
  BEGIN
    SELECT e.no_employe
    INTO employee
    FROM hcburca.Employes@LinkToDBUS e
    WHERE e.no_employe = :new.no_employe;

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20001,
                            'Invalid no_employe : There is no Employe with this no_employe in the company !');

  END;

--  trigger pour vérifier la présence du produit à insérer dans DETAILS_COMMANDESEN
CREATE OR REPLACE TRIGGER trg_check_CEN_produits
BEFORE INSERT OR UPDATE ON DETAILS_COMMANDESEN
FOR EACH ROW
  DECLARE
    produit NUMBER(6);
  BEGIN
    SELECT p.ref_produit
    INTO produit
    FROM lpoisse.produits@LinkToDBES p
    WHERE p.ref_produit = :new.REF_PRODUIT;

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20001,
                            'Invalid ref_produit : There is no product with this ref_produit in the company !');
  END;

--  trigger pour vérifier la présence du produit à insérer dans DETAILS_COMMANDESOI
CREATE OR REPLACE TRIGGER trg_check_COI_produits
BEFORE INSERT OR UPDATE ON DETAILS_COMMANDESOI
FOR EACH ROW
  DECLARE
    produit NUMBER(6);
  BEGIN
    SELECT p.ref_produit
    INTO produit
    FROM lpoisse.produits@LinkToDBES p
    WHERE p.ref_produit = :new.REF_PRODUIT;

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20001,
                            'Invalid ref_produit : There is no ref_produit with this ref_produit in the company !');
  END;

--  trigger pour vérifier si le produit inséré est bien référencé dans stockEN
CREATE OR REPLACE TRIGGER trg_check_stockEN_produits
BEFORE INSERT OR UPDATE ON STOCKEN
FOR EACH ROW
  DECLARE
    produit NUMBER(6);
  BEGIN
    SELECT p.ref_produit
    INTO produit
    FROM lpoisse.produits@LinkToDBES p
    WHERE p.ref_produit = :new.REF_PRODUIT;

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20001,
                            'Invalid ref_produit : There is no ref_produit with this ref_produit in the company !');
  END;

--  trigger pour vérifier si le produit inséré est bien référencé dans STOCKOI
CREATE OR REPLACE TRIGGER trg_check_stockoi_produits
BEFORE INSERT OR UPDATE ON STOCKOI
FOR EACH ROW
  DECLARE
    produit NUMBER(6);
  BEGIN
    SELECT p.ref_produit
    INTO produit
    FROM lpoisse.produits@LinkToDBES p
    WHERE p.ref_produit = :new.REF_PRODUIT;

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20001,
                            'Invalid ref_produit : There is no ref_produit with this ref_produit in the company !');
  END;

-- vérifier si le fournisseurs à supprimer/mettre à jour n'est déjà référencé dans la table produits
CREATE OR REPLACE TRIGGER chk_Fournisseurs
BEFORE DELETE OR UPDATE ON FOURNISSEURS
FOR EACH ROW
  DECLARE
    number_of_rows NUMBER; -- nombre de tuples trouvés dans table produit pour le fournisseurs qui doit être supprimé

  BEGIN

    SELECT count(*)
    INTO number_of_rows
    FROM lpoisse.produits@LinkToDBES
    WHERE NO_FOURNISSEUR = :old.NO_FOURNISSEUR;

    IF (DELETING)
    THEN
      IF number_of_rows <> 0
      THEN
        raise_application_error(-20002,
                                'Erreur : le fournisseur à supprimer est déjà référencé dans la table produits en europe du sud');
      END IF;
    END IF;

    IF (UPDATING)
    THEN
      IF number_of_rows <> 0
      THEN
        raise_application_error(-20002,
                                'Erreur : le fournisseur à mettre à jour est déjà référencé dans la table produits en europe du sud');
      END IF;
    END IF;

  END;



/*
  Création des vues
*/
-- Vue "Stock", création avec WHERE pour optimiser le plan d'exécution
CREATE OR REPLACE VIEW Stock
AS
  (SELECT *
   FROM lpoisse.stockes@LinkToDBES
   WHERE StockES.PAYS IN
         ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican',
                     'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie',
          'Autriche', 'Suisse')
   UNION ALL
   SELECT *
   FROM stockEN
   WHERE pays IN
         ('Suede', 'Norvege', 'Danemark', 'Finlande', 'Belgique', 'Irlande', 'Pologne', 'Royaume-Uni', 'Allemagne', 'Islande', 'Luxembourg', 'Pays-Bas')
   UNION ALL
   SELECT *
   FROM stockOI
   WHERE pays NOT IN ('Antigua-et-Barbuda', 'Argentine', 'Bahamas', 'Barbade', 'Belize', 'Bolivie', 'Bresil',
                                            'Canada', 'Chili', 'Colombie', 'Costa Rica', 'Cuba', 'Republique dominicaine', 'Dominique',
                                                                                         'Equateur', 'Etats-Unis', 'Grenade', 'Guatemala', 'Guyana', 'Haiti', 'Honduras', 'Jamaique',
                                                                                                                                                                          'Mexique', 'Nicaragua', 'Panama', 'Paraguay', 'Perou', 'Saint-Christophe-et-Nieves', 'Sainte-Lucie',
                                                                                                                                                                          'Saint-Vincent-et-les Grenadines', 'Salvador', 'Suriname', 'Trinite-et-Tobago', 'Uruguay',
                      'Venezuela') AND pays NOT IN
                                       ('Suede', 'Norvege', 'Danemark', 'Finlande', 'Belgique', 'Irlande', 'Pologne', 'Royaume-Uni', 'Allemagne', 'Islande', 'Luxembourg', 'Pays-Bas')
         AND pays NOT IN ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican',
                                     'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie',
                          'Autriche', 'Suisse')
   UNION ALL
   SELECT *
   FROM hcburca.stock_am@LinkToDBUS
   WHERE pays IN ('Antigua-et-Barbuda', 'Argentine', 'Bahamas', 'Barbade', 'Belize', 'Bolivie', 'Bresil',
                                        'Canada', 'Chili', 'Colombie', 'Costa Rica', 'Cuba', 'Republique dominicaine', 'Dominique',
                                                                                     'Equateur', 'Etats-Unis', 'Grenade', 'Guatemala', 'Guyana', 'Haiti', 'Honduras', 'Jamaique',
                                                                                                                                                                      'Mexique', 'Nicaragua', 'Panama', 'Paraguay', 'Perou', 'Saint-Christophe-et-Nieves', 'Sainte-Lucie',
                                                                                                                                                                      'Saint-Vincent-et-les Grenadines', 'Salvador', 'Suriname', 'Trinite-et-Tobago', 'Uruguay',
                  'Venezuela')
  );

-- Vue 'Produits'
CREATE OR REPLACE VIEW PRODUITS
AS
  (SELECT *
   FROM lpoisse.produits@LinkToDBES
  );

-- Vue 'Categories'
CREATE OR REPLACE VIEW CATEGORIES
AS
  (SELECT *
   FROM lpoisse.categories@LinkToDBES
  );

-- Vue 'Employes'
CREATE OR REPLACE VIEW EMPLOYES
AS
  (SELECT *
   FROM hcburca.employes@LinkToDBUS
  );


SELECT *
FROM Stock;

--Vue 'Clients', création avec WHERE pour optimiser le plan d'exécution
CREATE OR REPLACE VIEW Clients
AS
  (SELECT *
   FROM lpoisse.ClientsES@LinkToDBES
   WHERE PAYS IN
         ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican',
                     'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie',
          'Autriche', 'Suisse')
   UNION ALL
   SELECT *
   FROM clientsEN
   WHERE pays IN
         ('Suede', 'Norvege', 'Danemark', 'Finlande', 'Belgique', 'Irlande', 'Pologne', 'Royaume-Uni', 'Allemagne', 'Islande', 'Luxembourg', 'Pays-Bas')
   UNION ALL
   SELECT *
   FROM clientsOI
   WHERE pays NOT IN ('Antigua-et-Barbuda', 'Argentine', 'Bahamas', 'Barbade', 'Belize', 'Bolivie', 'Bresil',
                                            'Canada', 'Chili', 'Colombie', 'Costa Rica', 'Cuba', 'Republique dominicaine', 'Dominique',
                                                                                         'Equateur', 'Etats-Unis', 'Grenade', 'Guatemala', 'Guyana', 'Haiti', 'Honduras', 'Jamaique',
                                                                                                                                                                          'Mexique', 'Nicaragua', 'Panama', 'Paraguay', 'Perou', 'Saint-Christophe-et-Nieves', 'Sainte-Lucie',
                                                                                                                                                                          'Saint-Vincent-et-les Grenadines', 'Salvador', 'Suriname', 'Trinite-et-Tobago', 'Uruguay',
                      'Venezuela') AND pays NOT IN
                                       ('Suede', 'Norvege', 'Danemark', 'Finlande', 'Belgique', 'Irlande', 'Pologne', 'Royaume-Uni', 'Allemagne', 'Islande', 'Luxembourg', 'Pays-Bas')
         AND pays NOT IN ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican',
                                     'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie',
                          'Autriche', 'Suisse')
   UNION ALL
   SELECT *
   FROM hcburca.clients_am@LinkToDBUS
   WHERE pays IN ('Antigua-et-Barbuda', 'Argentine', 'Bahamas', 'Barbade', 'Belize', 'Bolivie', 'Bresil',
                                        'Canada', 'Chili', 'Colombie', 'Costa Rica', 'Cuba', 'Republique dominicaine', 'Dominique',
                                                                                     'Equateur', 'Etats-Unis', 'Grenade', 'Guatemala', 'Guyana', 'Haiti', 'Honduras', 'Jamaique',
                                                                                                                                                                      'Mexique', 'Nicaragua', 'Panama', 'Paraguay', 'Perou', 'Saint-Christophe-et-Nieves', 'Sainte-Lucie',
                                                                                                                                                                      'Saint-Vincent-et-les Grenadines', 'Salvador', 'Suriname', 'Trinite-et-Tobago', 'Uruguay',
                  'Venezuela')
  );

--Vue 'Commandes'
CREATE OR REPLACE VIEW Commandes
AS
  (SELECT *
   FROM COMMANDESOI
   UNION ALL
   SELECT *
   FROM COMMANDESEN
   UNION ALL
   SELECT *
   FROM lpoisse.Commandeses@LinkToDBES
   UNION ALL
   SELECT *
   FROM hcburca.Commandes_AM@LinkToDBUS
  );

-- Vue 'Details_Commande'
CREATE OR REPLACE VIEW details_commandes
AS
  (SELECT *
   FROM DETAILS_COMMANDESOI
   UNION ALL
   SELECT *
   FROM DETAILS_COMMANDESEN
   UNION ALL
   SELECT *
   FROM lpoisse.details_commandeses@LinkToDBES
   UNION ALL
   SELECT *
   FROM hcburca.Details_Commandes_AM@LinkToDBUS
  );


