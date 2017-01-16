/*
Trigger appelé lors d'une action LMD sur la vue 'Stock'
*/
CREATE OR REPLACE TRIGGER modify_Stocks
INSTEAD OF
UPDATE OR
INSERT OR
DELETE ON Stock
FOR EACH ROW
  BEGIN IF INSERTING
  THEN --Insertion à contrôler
    IF (:NEW.pays IN
        ('Suede', 'Norvege', 'Danemark', 'Finlande', 'Belgique', 'Irlande', 'Pologne', 'Royaume-Uni', 'Allemagne', 'Islande', 'Luxembourg', 'Pays-Bas'))
    THEN
      INSERT
      INTO STOCKEN VALUES
        (
          :new.ref_produit,
          :new.pays,
          :new.unites_stock,
          :new.unites_commandees,
          :new.indisponible
        );
    ELSIF (:NEW.pays IN
           ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 'Autriche', 'Suisse'))
      THEN
        INSERT
        INTO lpoisse.stockes@LinkToDBES VALUES
          (
            :new.ref_produit,
            :new.pays,
            :new.unites_stock,
            :new.unites_commandees,
            :new.indisponible
          );
    ELSIF (:NEW.pays IN
           ('Antigua-et-Barbuda', 'Argentine', 'Bahamas', 'Barbade', 'Belize', 'Bolivie', 'Bresil', 'Canada', 'Chili', 'Colombie', 'Costa Rica', 'Cuba', 'Republique dominicaine', 'Dominique', 'Equateur', 'Etats-Unis', 'Grenade', 'Guatemala', 'Guyana', 'Haiti', 'Honduras', 'Jamaique', 'Mexique', 'Nicaragua', 'Panama', 'Paraguay', 'Perou', 'Saint-Christophe-et-Nieves', 'Sainte-Lucie', 'Saint-Vincent-et-les Grenadines', 'Salvador', 'Suriname', 'Trinite-et-Tobago', 'Uruguay', 'Venezuela'))
      THEN
        INSERT
        INTO hcburca.stock_am@LinkToDBUS VALUES
          (
            :new.ref_produit,
            :new.pays,
            :new.unites_stock,
            :new.unites_commandees,
            :new.indisponible
          );
    ELSE
      INSERT
      INTO STOCKOI VALUES
        (
          :new.ref_produit,
          :new.pays,
          :new.unites_stock,
          :new.unites_commandees,
          :new.indisponible
        );
    END IF;
  END IF;
    IF UPDATING
    THEN
      IF (:New.pays <> :OLD.pays)
      THEN
        RAISE_APPLICATION_ERROR(-20010, 'Attention, vous n''êtes pas autorisé à changer le pays du stock');
      ELSIF (:NEW.pays IN
             ('Suede', 'Norvege', 'Danemark', 'Finlande', 'Belgique', 'Irlande', 'Pologne', 'Royaume-Uni', 'Allemagne', 'Islande', 'Luxembourg', 'Pays-Bas'))
        THEN
          UPDATE STOCKEN
          SET ref_produit     = :new.ref_produit,
            PAYS              = :NEW.PAYS,
            UNITES_STOCK      = :new.UNITES_STOCK,
            UNITES_COMMANDEES = :new.UNITES_COMMANDEES,
            INDISPONIBLE      = :new.INDISPONIBLE
          WHERE ref_produit = :old.ref_produit
                AND pays = :old.PAYS;
      ELSIF (:NEW.pays IN
             ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 'Autriche', 'Suisse'))
        THEN
          UPDATE lpoisse.stockes@LinkToDBES
          SET ref_produit     = :new.ref_produit,
            PAYS              = :NEW.PAYS,
            UNITES_STOCK      = :new.UNITES_STOCK,
            UNITES_COMMANDEES = :new.UNITES_COMMANDEES,
            INDISPONIBLE      = :new.INDISPONIBLE
          WHERE ref_produit = :old.ref_produit
                AND pays = :old.PAYS;
      ELSIF (:NEW.pays IN
             ('Antigua-et-Barbuda', 'Argentine', 'Bahamas', 'Barbade', 'Belize', 'Bolivie', 'Bresil', 'Canada', 'Chili', 'Colombie', 'Costa Rica', 'Cuba', 'Republique dominicaine', 'Dominique', 'Equateur', 'Etats-Unis', 'Grenade', 'Guatemala', 'Guyana', 'Haiti', 'Honduras', 'Jamaique', 'Mexique', 'Nicaragua', 'Panama', 'Paraguay', 'Perou', 'Saint-Christophe-et-Nieves', 'Sainte-Lucie', 'Saint-Vincent-et-les Grenadines', 'Salvador', 'Suriname', 'Trinite-et-Tobago', 'Uruguay', 'Venezuela'))
        THEN
          UPDATE hcburca.stock_am@LinkToDBUS
          SET ref_produit     = :new.ref_produit,
            PAYS              = :NEW.PAYS,
            UNITES_STOCK      = :new.UNITES_STOCK,
            UNITES_COMMANDEES = :new.UNITES_COMMANDEES,
            INDISPONIBLE      = :new.INDISPONIBLE
          WHERE ref_produit = :old.ref_produit
                AND pays = :old.PAYS;
      ELSE
        UPDATE STOCKOI
        SET ref_produit     = :new.ref_produit,
          PAYS              = :NEW.PAYS,
          UNITES_STOCK      = :new.UNITES_STOCK,
          UNITES_COMMANDEES = :new.UNITES_COMMANDEES,
          INDISPONIBLE      = :new.INDISPONIBLE
        WHERE ref_produit = :old.ref_produit
              AND pays = :old.PAYS;
      END IF;
    END IF;
    IF DELETING
    THEN --Suppression à vérifier ; on ne peut pas supprimer un stock ne faisant pas partie de la région du site (gestion du stock LOCAL seulement)
      IF (:old.pays IN
          ('Suede', 'Norvege', 'Danemark', 'Finlande', 'Belgique', 'Irlande', 'Pologne', 'Royaume-Uni', 'Allemagne', 'Islande', 'Luxembourg', 'Pays-Bas'))
      THEN
        DELETE FROM STOCKEN
        WHERE ref_produit = :old.ref_produit AND pays = :old.pays;
      ELSIF (:old.pays IN
             ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 'Autriche', 'Suisse'))
        THEN
          DELETE
          FROM lpoisse.stockes@LinkToDBES
          WHERE ref_produit = :old.ref_produit
                AND pays = :old.pays;
      ELSIF (:old.pays IN
             ('Antigua-et-Barbuda', 'Argentine', 'Bahamas', 'Barbade', 'Belize', 'Bolivie', 'Bresil', 'Canada', 'Chili', 'Colombie', 'Costa Rica', 'Cuba', 'Republique dominicaine', 'Dominique', 'Equateur', 'Etats-Unis', 'Grenade', 'Guatemala', 'Guyana', 'Haiti', 'Honduras', 'Jamaique', 'Mexique', 'Nicaragua', 'Panama', 'Paraguay', 'Perou', 'Saint-Christophe-et-Nieves', 'Sainte-Lucie', 'Saint-Vincent-et-les Grenadines', 'Salvador', 'Suriname', 'Trinite-et-Tobago', 'Uruguay', 'Venezuela'))
        THEN
          DELETE
          FROM hcburca.stock_am@LinkToDBUS
          WHERE ref_produit = :old.ref_produit
                AND pays = :old.pays;
      ELSE
        DELETE FROM STOCKOI
        WHERE ref_produit = :old.ref_produit AND pays = :old.pays;
      END IF;
    END IF;
  END;



/*
  Trigger de modification d'un client
*/

CREATE OR REPLACE TRIGGER modify_Clients
INSTEAD OF UPDATE OR INSERT OR DELETE ON Clients
FOR EACH ROW
  BEGIN
    IF INSERTING
    THEN

      IF (:NEW.pays IN ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican',
                                   'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie',
                        'Autriche', 'Suisse'))
      THEN

        INSERT INTO lpoisse.ClientsES@LinkToDBES
        VALUES (:new.code_client, :new.societe, :new.adresse, :new.ville, :new.code_postal, :new.pays, :new.telephone,
                :new.fax);

      ELSIF (:new.pays IN ('Antigua-et-Barbuda', 'Argentine', 'Bahamas', 'Barbade', 'Belize', 'Bolivie', 'Bresil',
                                                 'Canada', 'Chili', 'Colombie', 'Costa Rica', 'Cuba', 'Republique dominicaine', 'Dominique',
                                                                                              'Equateur', 'Etats-Unis', 'Grenade', 'Guatemala', 'Guyana', 'Haiti', 'Honduras', 'Jamaique',
                                                                                                                                                                               'Mexique', 'Nicaragua', 'Panama', 'Paraguay', 'Perou', 'Saint-Christophe-et-Nieves', 'Sainte-Lucie',
                                                                                                                                                                               'Saint-Vincent-et-les Grenadines', 'Salvador', 'Suriname', 'Trinite-et-Tobago', 'Uruguay',
                           'Venezuela'))
        THEN
          INSERT INTO hcburca.clients_am@LinkToDBUS
          VALUES (:new.code_client, :new.societe, :new.adresse, :new.ville, :new.code_postal, :new.pays, :new.telephone,
                  :new.fax);

      ELSIF (:new.pays IN
             ('Suede', 'Norvege', 'Danemark', 'Finlande', 'Belgique', 'Irlande', 'Pologne', 'Royaume-Uni', 'Allemagne', 'Islande', 'Luxembourg', 'Pays-Bas'))
        THEN
          INSERT INTO CLIENTSEN
          VALUES (:new.code_client, :new.societe, :new.adresse, :new.ville, :new.code_postal, :new.pays, :new.telephone,
                  :new.fax);

      ELSE
        INSERT INTO CLIENTSOI
        VALUES (:new.code_client, :new.societe, :new.adresse, :new.ville, :new.code_postal, :new.pays, :new.telephone,
                :new.fax);
      END IF;
    END IF;

    IF UPDATING
    THEN

      IF (:New.pays <> :OLD.pays)
      THEN
        RAISE_APPLICATION_ERROR(-20010, 'Attention, vous n''êtes pas autorisé à changer le pays du client');
      ELSIF (:NEW.pays IN ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican',
                                      'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie',
                           'Autriche', 'Suisse'))
        THEN
          UPDATE lpoisse.ClientsES@LinkToDBES
          SET
            code_client = :new.code_client,
            societe     = :NEW.societe,
            adresse     = :new.adresse,
            ville       = :new.ville,
            code_postal = :new.code_postal,
            pays        = :new.pays,
            telephone   = :new.telephone,
            fax         = :new.fax
          WHERE code_client = :old.code_client;
      ELSIF (:new.pays IN ('Antigua-et-Barbuda', 'Argentine', 'Bahamas', 'Barbade', 'Belize', 'Bolivie', 'Bresil',
                                                 'Canada', 'Chili', 'Colombie', 'Costa Rica', 'Cuba', 'Republique dominicaine', 'Dominique',
                                                                                              'Equateur', 'Etats-Unis', 'Grenade', 'Guatemala', 'Guyana', 'Haiti', 'Honduras', 'Jamaique',
                                                                                                                                                                               'Mexique', 'Nicaragua', 'Panama', 'Paraguay', 'Perou', 'Saint-Christophe-et-Nieves', 'Sainte-Lucie',
                                                                                                                                                                               'Saint-Vincent-et-les Grenadines', 'Salvador', 'Suriname', 'Trinite-et-Tobago', 'Uruguay',
                           'Venezuela'))
        THEN
          UPDATE hcburca.clients_am@LinkToDBUS
          SET
            code_client = :new.code_client,
            societe     = :NEW.societe,
            adresse     = :new.adresse,
            ville       = :new.ville,
            code_postal = :new.code_postal,
            pays        = :new.pays,
            telephone   = :new.telephone,
            fax         = :new.fax
          WHERE code_client = :old.code_client;
      ELSIF (:new.pays IN ('Suede', 'Norvege', 'Danemark', 'Finlande', 'Belgique', 'Irlande',
                                    'Pologne', 'Royaume-Uni', 'Allemagne', 'Islande', 'Luxembourg', 'Pays-Bas'))
        THEN
          UPDATE CLIENTSEN
          SET
            code_client = :new.code_client,
            societe     = :NEW.societe,
            adresse     = :new.adresse,
            ville       = :new.ville,
            code_postal = :new.code_postal,
            pays        = :new.pays,
            telephone   = :new.telephone,
            fax         = :new.fax
          WHERE code_client = :old.code_client;
      ELSE
        UPDATE CLIENTSOI
        SET
          code_client = :new.code_client,
          societe     = :NEW.societe,
          adresse     = :new.adresse,
          ville       = :new.ville,
          code_postal = :new.code_postal,
          pays        = :new.pays,
          telephone   = :new.telephone,
          fax         = :new.fax
        WHERE code_client = :old.code_client;
      END IF;
    END IF;

    IF DELETING
    THEN

      IF (:old.pays IN ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican',
                                   'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie',
                        'Autriche', 'Suisse'))
      THEN
        DELETE FROM lpoisse.ClientsES@LinkToDBES
        WHERE code_client = :old.code_client;

      ELSIF (:old.pays IN ('Antigua-et-Barbuda', 'Argentine', 'Bahamas', 'Barbade', 'Belize', 'Bolivie', 'Bresil',
                                                 'Canada', 'Chili', 'Colombie', 'Costa Rica', 'Cuba', 'Republique dominicaine', 'Dominique',
                                                                                              'Equateur', 'Etats-Unis', 'Grenade', 'Guatemala', 'Guyana', 'Haiti', 'Honduras', 'Jamaique',
                                                                                                                                                                               'Mexique', 'Nicaragua', 'Panama', 'Paraguay', 'Perou', 'Saint-Christophe-et-Nieves', 'Sainte-Lucie',
                                                                                                                                                                               'Saint-Vincent-et-les Grenadines', 'Salvador', 'Suriname', 'Trinite-et-Tobago', 'Uruguay',
                           'Venezuela'))
        THEN
          DELETE FROM hcburca.clients_am@LinkToDBUS
          WHERE code_client = :old.code_client;
      ELSIF (:old.pays IN ('Suede', 'Norvege', 'Danemark', 'Finlande', 'Belgique',
                                    'Irlande', 'Pologne', 'Royaume-Uni', 'Allemagne', 'Islande', 'Luxembourg', 'Pays-Bas'))
        THEN
          DELETE FROM CLIENTSEN
          WHERE code_client = :old.code_client;
      ELSE
        DELETE FROM CLIENTSOI
        WHERE code_client = :old.code_client;
      END IF;
    END IF;
  END;

/*
	Trigger pour insert, update, delete on Commandes
*/
CREATE OR REPLACE TRIGGER MODIFY_COMMANDES
INSTEAD OF DELETE OR INSERT OR UPDATE ON COMMANDES
FOR EACH ROW
  DECLARE
    paysclient$ VARCHAR2(15);
  BEGIN
    IF (INSERTING OR UPDATING)
    THEN
      SELECT DISTINCT Pays
      INTO paysclient$
      FROM CLIENTS
      WHERE code_client = :new.code_client;
    ELSIF (DELETING)
      THEN
        SELECT DISTINCT Pays
        INTO paysclient$
        FROM CLIENTS
        WHERE code_client = :old.code_client;
    END IF;

    IF (INSERTING)
    THEN
      IF (paysclient$ IN ('Antigua-et-Barbuda', 'Argentine', 'Bahamas', 'Barbade', 'Belize', 'Bolivie', 'Bresil',
                                                'Canada', 'Chili', 'Colombie', 'Costa Rica', 'Cuba', 'Republique dominicaine', 'Dominique',
                                                                                             'Equateur', 'Etats-Unis', 'Grenade', 'Guatemala', 'Guyana', 'Haiti', 'Honduras', 'Jamaique',
                                                                                                                                                                              'Mexique', 'Nicaragua', 'Panama', 'Paraguay', 'Perou', 'Saint-Christophe-et-Nieves', 'Sainte-Lucie',
                                                                                                                                                                              'Saint-Vincent-et-les Grenadines', 'Salvador', 'Suriname', 'Trinite-et-Tobago', 'Uruguay',
                          'Venezuela'))
      THEN
        INSERT INTO hcburca.Commandes_AM@LinkToDBUS
        VALUES (:new.no_commande, :new.code_client, :new.no_employe, :new.date_commande, :new.date_envoi, :new.port);
      ELSIF (paysclient$ IN
             ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican',
                         'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie',
              'Autriche', 'Suisse'))
        THEN
          INSERT INTO lpoisse.Commandeses@LinkToDBES
          VALUES (:new.no_commande, :new.code_client, :new.no_employe, :new.date_commande, :new.date_envoi, :new.port);
      ELSIF (paysclient$ IN
             ('Suede', 'Norvege', 'Danemark', 'Finlande', 'Belgique', 'Irlande', 'Pologne', 'Royaume-Uni', 'Allemagne', 'Islande',
                       'Luxembourg', 'Pays-Bas'))
        THEN
          INSERT INTO COMMANDESEN
          VALUES (:new.no_commande, :new.code_client, :new.no_employe, :new.date_commande, :new.date_envoi, :new.port);
      ELSE
        INSERT INTO COMMANDESOI
        VALUES (:new.no_commande, :new.code_client, :new.no_employe, :new.date_commande, :new.date_envoi, :new.port);
      END IF;
    ELSIF (UPDATING)
      THEN
        IF (:new.code_client <> :old.code_client)
        THEN
          RAISE_APPLICATION_ERROR(-20010, 'Attention, vous n''êtes pas autorisé à changer le client de cet commande');
        ELSE
          IF (paysclient$ IN ('Antigua-et-Barbuda', 'Argentine', 'Bahamas', 'Barbade', 'Belize', 'Bolivie', 'Bresil',
                                                    'Canada', 'Chili', 'Colombie', 'Costa Rica', 'Cuba', 'Republique dominicaine', 'Dominique',
                                                                                                 'Equateur', 'Etats-Unis', 'Grenade', 'Guatemala', 'Guyana', 'Haiti', 'Honduras', 'Jamaique',
                                                                                                                                                                                  'Mexique', 'Nicaragua', 'Panama', 'Paraguay', 'Perou', 'Saint-Christophe-et-Nieves', 'Sainte-Lucie',
                                                                                                                                                                                  'Saint-Vincent-et-les Grenadines', 'Salvador', 'Suriname', 'Trinite-et-Tobago', 'Uruguay',
                              'Venezuela'))
          THEN
            UPDATE hcburca.Commandes_AM@LinkToDBUS
            SET no_commande = :new.no_commande, code_client = :new.code_client, no_employe = :new.no_employe,
              date_commande = :new.date_commande, date_envoi = :new.date_envoi, port = :new.port
            WHERE no_commande = :old.no_commande;
          ELSIF (paysclient$ IN
                 ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican',
                             'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie',
                  'Autriche', 'Suisse'))
            THEN
              UPDATE lpoisse.Commandeses@LinkToDBES
              SET no_commande = :new.no_commande, code_client = :new.code_client, no_employe = :new.no_employe,
                date_commande = :new.date_commande, date_envoi = :new.date_envoi, port = :new.port
              WHERE no_commande = :old.no_commande;
          ELSIF (paysclient$ IN
                 ('Suede', 'Norvege', 'Danemark', 'Finlande', 'Belgique', 'Irlande', 'Pologne', 'Royaume-Uni', 'Allemagne', 'Islande',
                           'Luxembourg', 'Pays-Bas'))
            THEN
              UPDATE commandesEN
              SET no_commande = :new.no_commande, code_client = :new.code_client, no_employe = :new.no_employe,
                date_commande = :new.date_commande, date_envoi = :new.date_envoi, port = :new.port
              WHERE no_commande = :old.no_commande;
          ELSE
            UPDATE commandesOI
            SET no_commande = :new.no_commande, code_client = :new.code_client, no_employe = :new.no_employe,
              date_commande = :new.date_commande, date_envoi = :new.date_envoi, port = :new.port
            WHERE no_commande = :old.no_commande;
          END IF;
        END IF;
    ELSIF (DELETING)
      THEN
        IF (paysclient$ IN ('Antigua-et-Barbuda', 'Argentine', 'Bahamas', 'Barbade', 'Belize', 'Bolivie', 'Bresil',
                                                  'Canada', 'Chili', 'Colombie', 'Costa Rica', 'Cuba', 'Republique dominicaine', 'Dominique',
                                                                                               'Equateur', 'Etats-Unis', 'Grenade', 'Guatemala', 'Guyana', 'Haiti', 'Honduras', 'Jamaique',
                                                                                                                                                                                'Mexique', 'Nicaragua', 'Panama', 'Paraguay', 'Perou', 'Saint-Christophe-et-Nieves', 'Sainte-Lucie',
                                                                                                                                                                                'Saint-Vincent-et-les Grenadines', 'Salvador', 'Suriname', 'Trinite-et-Tobago', 'Uruguay',
                            'Venezuela'))
        THEN
          DELETE FROM hcburca.Commandes_AM@LinkToDBUS
          WHERE no_commande = :old.no_commande;
        ELSIF (paysclient$ IN
               ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican',
                           'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie',
                'Autriche', 'Suisse'))
          THEN
            DELETE FROM lpoisse.Commandeses@LinkToDBES
            WHERE no_commande = :old.no_commande;
        ELSIF (paysclient$ IN
               ('Suede', 'Norvege', 'Danemark', 'Finlande', 'Belgique', 'Irlande', 'Pologne', 'Royaume-Uni', 'Allemagne', 'Islande',
                         'Luxembourg', 'Pays-Bas'))
          THEN
            DELETE FROM commandesEN
            WHERE no_commande = :old.no_commande;
        ELSE
          DELETE FROM commandesOI
          WHERE no_commande = :old.no_commande;
        END IF;
    END IF;

    EXCEPTION
    WHEN no_data_found THEN
    raise_application_error(-20011, 'Erreur : le client indiqué est inconnu.');

  END;


/*
Trigger appelé lors d'une action LMD sur la vue 'DETAILS_COMMANDES'
*/
CREATE OR REPLACE TRIGGER modify_DetailsCommandes
INSTEAD OF
UPDATE OR
INSERT OR
DELETE ON DETAILS_COMMANDES
FOR EACH ROW
  DECLARE
    paysTest VARCHAR2(24);
  BEGIN
    IF (UPDATING OR INSERTING)
    THEN
      SELECT pays
      INTO paystest
      FROM CLIENTS
        NATURAL JOIN COMMANDES
      WHERE no_commande = :new.no_commande;
    END IF;

    IF INSERTING
    THEN --Insertion à contrôler

      IF (paysTest IN
          ('Suede', 'Norvege', 'Danemark', 'Finlande', 'Belgique', 'Irlande', 'Pologne', 'Royaume-Uni', 'Allemagne', 'Islande', 'Luxembourg', 'Pays-Bas'))
      THEN
        INSERT
        INTO DETAILS_COMMANDESEN VALUES
          (
            :new.no_commande,
            :new.ref_produit,
            :new.prix_unitaire,
            :new.quantite,
            :new.remise
          );
      ELSIF (paysTest IN
             ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 'Autriche', 'Suisse'))
        THEN
          INSERT
          INTO lpoisse.details_commandeses@LinkToDBES VALUES
            (
              :new.no_commande,
              :new.ref_produit,
              :new.prix_unitaire,
              :new.quantite,
              :new.remise
            );
      ELSIF (paysTest IN
             ('Antigua-et-Barbuda', 'Argentine', 'Bahamas', 'Barbade', 'Belize', 'Bolivie', 'Bresil', 'Canada', 'Chili', 'Colombie', 'Costa Rica', 'Cuba', 'Republique dominicaine', 'Dominique', 'Equateur', 'Etats-Unis', 'Grenade', 'Guatemala', 'Guyana', 'Haiti', 'Honduras', 'Jamaique', 'Mexique', 'Nicaragua', 'Panama', 'Paraguay', 'Perou', 'Saint-Christophe-et-Nieves', 'Sainte-Lucie', 'Saint-Vincent-et-les Grenadines', 'Salvador', 'Suriname', 'Trinite-et-Tobago', 'Uruguay', 'Venezuela'))
        THEN
          INSERT
          INTO hcburca.Details_Commandes_AM@LinkToDBUS VALUES
            (
              :new.no_commande,
              :new.ref_produit,
              :new.prix_unitaire,
              :new.quantite,
              :new.remise
            );
      ELSE
        INSERT
        INTO details_commandesOI VALUES
          (
            :new.no_commande,
            :new.ref_produit,
            :new.prix_unitaire,
            :new.quantite,
            :new.remise
          );
      END IF;
    END IF;
    IF UPDATING
    THEN -- Modification à contrôler : on ne peut pas modifier les données d'un stock non local !

      IF (:old.ref_produit = :new.ref_produit AND :old.NO_COMMANDE = :new.no_commande)
      THEN
        IF (paysTest IN
            ('Suede', 'Norvege', 'Danemark', 'Finlande', 'Belgique', 'Irlande', 'Pologne', 'Royaume-Uni', 'Allemagne', 'Islande', 'Luxembourg', 'Pays-Bas'))
        THEN
          UPDATE DETAILS_COMMANDESEN
          SET ref_produit = :new.ref_produit,
            NO_COMMANDE   = :new.no_commande,
            PRIX_UNITAIRE = :new.PRIX_UNITAIRE,
            QUANTITE      = :new.QUANTITE,
            REMISE        = :new.REMISE
          WHERE ref_produit = :old.ref_produit
                AND no_commande = :old.no_commande;
        ELSIF (paysTest IN
               ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 'Autriche', 'Suisse'))
          THEN
            UPDATE lpoisse.details_commandeses@LinkToDBES
            SET ref_produit = :new.ref_produit,
              NO_COMMANDE   = :new.no_commande,
              PRIX_UNITAIRE = :new.PRIX_UNITAIRE,
              QUANTITE      = :new.QUANTITE,
              REMISE        = :new.REMISE
            WHERE ref_produit = :old.ref_produit
                  AND no_commande = :old.no_commande;
        ELSIF (paysTest IN
               ('Antigua-et-Barbuda', 'Argentine', 'Bahamas', 'Barbade', 'Belize', 'Bolivie', 'Bresil', 'Canada', 'Chili', 'Colombie', 'Costa Rica', 'Cuba', 'Republique dominicaine', 'Dominique', 'Equateur', 'Etats-Unis', 'Grenade', 'Guatemala', 'Guyana', 'Haiti', 'Honduras', 'Jamaique', 'Mexique', 'Nicaragua', 'Panama', 'Paraguay', 'Perou', 'Saint-Christophe-et-Nieves', 'Sainte-Lucie', 'Saint-Vincent-et-les Grenadines', 'Salvador', 'Suriname', 'Trinite-et-Tobago', 'Uruguay', 'Venezuela'))
          THEN
            UPDATE hcburca.Details_Commandes_AM@LinkToDBUS
            SET ref_produit = :new.ref_produit,
              NO_COMMANDE   = :new.no_commande,
              PRIX_UNITAIRE = :new.PRIX_UNITAIRE,
              QUANTITE      = :new.QUANTITE,
              REMISE        = :new.REMISE
            WHERE ref_produit = :old.ref_produit
                  AND no_commande = :old.no_commande;
        ELSE
          UPDATE details_commandesOI
          SET ref_produit = :new.ref_produit,
            NO_COMMANDE   = :new.no_commande,
            PRIX_UNITAIRE = :new.PRIX_UNITAIRE,
            QUANTITE      = :new.QUANTITE,
            REMISE        = :new.REMISE
          WHERE ref_produit = :old.ref_produit
                AND no_commande = :old.no_commande;
        END IF;
        ELSE
          raise_application_error(-20012, 'Vous ne pouvez pas changez le numero de commande');
      END IF;
    END IF;
    IF DELETING
    THEN

      --   DBMS_OUTPUT.PUT_LINE(:old.no_commande||' - ' || :old.ref_produit);
      SELECT pays
      INTO paysTest
      FROM CLIENTS
        NATURAL JOIN COMMANDES
      WHERE no_commande = :old.no_commande;

      IF (paysTest IN
          ('Suede', 'Norvege', 'Danemark', 'Finlande', 'Belgique', 'Irlande', 'Pologne', 'Royaume-Uni', 'Allemagne', 'Islande', 'Luxembourg', 'Pays-Bas'))
      THEN
        DELETE
        FROM DETAILS_COMMANDESEN
        WHERE ref_produit = :old.ref_produit
              AND no_commande = :old.no_commande;

      ELSIF (paysTest IN
             ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 'Autriche', 'Suisse'))
        THEN

          DELETE
          FROM lpoisse.details_commandeses@LinkToDBES
          WHERE ref_produit = :old.ref_produit
                AND no_commande = :old.no_commande;
      ELSIF (paysTest IN
             ('Antigua-et-Barbuda', 'Argentine', 'Bahamas', 'Barbade', 'Belize', 'Bolivie', 'Bresil', 'Canada', 'Chili', 'Colombie', 'Costa Rica', 'Cuba', 'Republique dominicaine', 'Dominique', 'Equateur', 'Etats-Unis', 'Grenade', 'Guatemala', 'Guyana', 'Haiti', 'Honduras', 'Jamaique', 'Mexique', 'Nicaragua', 'Panama', 'Paraguay', 'Perou', 'Saint-Christophe-et-Nieves', 'Sainte-Lucie', 'Saint-Vincent-et-les Grenadines', 'Salvador', 'Suriname', 'Trinite-et-Tobago', 'Uruguay', 'Venezuela'))
        THEN
          DELETE
          FROM hcburca.Details_Commandes_AM@LinkToDBUS
          WHERE ref_produit = :old.ref_produit
                AND no_commande = :old.no_commande;
      ELSE
        DELETE
        FROM details_commandesOI
        WHERE ref_produit = :old.ref_produit
              AND no_commande = :old.no_commande;
      END IF;
    END IF;

    EXCEPTION
    WHEN no_data_found THEN
    raise_application_error(-20012, 'La commande indiquée est inconnue');
  END;
