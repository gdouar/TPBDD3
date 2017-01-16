




create or replace TRIGGER fkEmployes BEFORE DELETE or update ON Employes
FOR EACH ROW
DECLARE
number_of_rows NUMBER; 

BEGIN

    SELECT count(*) into number_of_rows
    from Commandes
    where NO_EMPLOYE = :old.NO_EMPLOYE;

  if(deleting) then
    IF number_of_rows <> 0 THEN
      raise_application_error(-20002, 'Erreur : l''employé à supprimer est déjà référencé dans une commande');
    end if;
    end if;
    
  if(updating) then
    IF number_of_rows <> 0 THEN
      raise_application_error(-20002, 'Erreur : l''employé à mettre à jour est déjà référencé dans une commande');
    end if;
    end if;

END;



-- update primary keys to include local prefix
UPDATE CLIENTS_AM SET Code_Client = 'AM' || rtrim(Code_Client);

-- vues

  
CREATE OR REPLACE TRIGGER MODIFY_COMMANDES
INSTEAD OF DELETE OR INSERT OR UPDATE ON COMMANDES 
FOR EACH ROW
DECLARE
  paysclient$ clients_am.pays%TYPE;
BEGIN
  if (inserting or updating) then 
    SELECT DISTINCT Pays INTO paysclient$
    FROM CLIENTS
    WHERE code_client = :new.code_client;
  elsif (deleting) then 
    SELECT DISTINCT Pays INTO paysclient$
    FROM CLIENTS
    WHERE code_client = :old.code_client;
  end if;
  
  if (inserting) then
    if (paysclient$ in ('Antigua-et-Barbuda', 'Argentine', 'Bahamas', 'Barbade', 'Belize', 'Bolivie', 'Bresil',
                      'Canada', 'Chili', 'Colombie','Costa Rica', 'Cuba', 'Republique dominicaine', 'Dominique',
                      'Equateur', 'Etats-Unis', 'Grenade', 'Guatemala', 'Guyana', 'Haiti','Honduras', 'Jamaique',
                      'Mexique', 'Nicaragua', 'Panama', 'Paraguay', 'Perou', 'Saint-Christophe-et-Nieves', 'Sainte-Lucie',
                      'Saint-Vincent-et-les Grenadines', 'Salvador', 'Suriname', 'Trinite-et-Tobago', 'Uruguay',
                      'Venezuela')) then
      INSERT INTO Commandes_AM VALUES (:new.no_commande, :new.code_client, :new.no_employe, :new.date_commande, :new.date_envoi, :new.port);
    elsif (paysclient$ in ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 
                             'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 
                             'Autriche', 'Suisse')) then
      INSERT INTO lpoisse.commandesES@linkES VALUES (:new.no_commande, :new.code_client, :new.no_employe, :new.date_commande, :new.date_envoi, :new.port);
    elsif (paysclient$ in ('Suede', 'Norvege', 'Danemark', 'Finlande', 'Belgique', 'Irlande', 'Pologne', 'Royaume-Uni', 'Allemagne', 'Islande', 
                             'Luxembourg', 'Pays-Bas')) then 
      INSERT INTO cpottiez.commandesEN@tplink VALUES (:new.no_commande, :new.code_client, :new.no_employe, :new.date_commande, :new.date_envoi, :new.port);
    else 
      INSERT INTO cpottiez.commandesOI@tplink VALUES (:new.no_commande, :new.code_client, :new.no_employe, :new.date_commande, :new.date_envoi, :new.port);
    end if;
  elsif (updating) then
    if (paysclient$ in ('Antigua-et-Barbuda', 'Argentine', 'Bahamas', 'Barbade', 'Belize', 'Bolivie', 'Bresil',
                      'Canada', 'Chili', 'Colombie','Costa Rica', 'Cuba', 'Republique dominicaine', 'Dominique',
                      'Equateur', 'Etats-Unis', 'Grenade', 'Guatemala', 'Guyana', 'Haiti','Honduras', 'Jamaique',
                      'Mexique', 'Nicaragua', 'Panama', 'Paraguay', 'Perou', 'Saint-Christophe-et-Nieves', 'Sainte-Lucie',
                      'Saint-Vincent-et-les Grenadines', 'Salvador', 'Suriname', 'Trinite-et-Tobago', 'Uruguay',
                      'Venezuela')) then
      UPDATE Commandes_AM SET no_commande = :new.no_commande, code_client = :new.code_client, no_employe = :new.no_employe, 
                              date_commande = :new.date_commande, date_envoi = :new.date_envoi, port = :new.port
                          WHERE no_commande = :old.no_commande;
    elsif (paysclient$ in ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 
                             'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 
                             'Autriche', 'Suisse')) then
      UPDATE lpoisse.commandesES@linkES SET no_commande = :new.no_commande, code_client = :new.code_client, no_employe = :new.no_employe, 
                              date_commande = :new.date_commande, date_envoi = :new.date_envoi, port = :new.port
                          WHERE no_commande = :old.no_commande;
    elsif (paysclient$ in ('Suede', 'Norvege', 'Danemark', 'Finlande', 'Belgique', 'Irlande', 'Pologne', 'Royaume-Uni', 'Allemagne', 'Islande', 
                             'Luxembourg', 'Pays-Bas')) then 
      UPDATE cpottiez.commandesEN@tplink SET no_commande = :new.no_commande, code_client = :new.code_client, no_employe = :new.no_employe, 
                              date_commande = :new.date_commande, date_envoi = :new.date_envoi, port = :new.port
                          WHERE no_commande = :old.no_commande;
    else 
      UPDATE cpottiez.commandesOI@tplink SET no_commande = :new.no_commande, code_client = :new.code_client, no_employe = :new.no_employe, 
                              date_commande = :new.date_commande, date_envoi = :new.date_envoi, port = :new.port
                          WHERE no_commande = :old.no_commande;
    end if;
  elsif (deleting) then 
    if (paysclient$ in ('Antigua-et-Barbuda', 'Argentine', 'Bahamas', 'Barbade', 'Belize', 'Bolivie', 'Bresil',
                      'Canada', 'Chili', 'Colombie','Costa Rica', 'Cuba', 'Republique dominicaine', 'Dominique',
                      'Equateur', 'Etats-Unis', 'Grenade', 'Guatemala', 'Guyana', 'Haiti','Honduras', 'Jamaique',
                      'Mexique', 'Nicaragua', 'Panama', 'Paraguay', 'Perou', 'Saint-Christophe-et-Nieves', 'Sainte-Lucie',
                      'Saint-Vincent-et-les Grenadines', 'Salvador', 'Suriname', 'Trinite-et-Tobago', 'Uruguay',
                      'Venezuela')) then
      DELETE FROM commandes_AM WHERE no_commande = :old.no_commande;
    elsif (paysclient$ in ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 
                             'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 
                             'Autriche', 'Suisse')) then
      DELETE FROM lpoisse.commandesES@linkES WHERE no_commande = :old.no_commande;
    elsif (paysclient$ in ('Suede', 'Norvege', 'Danemark', 'Finlande', 'Belgique', 'Irlande', 'Pologne', 'Royaume-Uni', 'Allemagne', 'Islande', 
                             'Luxembourg', 'Pays-Bas')) then 
      DELETE FROM cpottiez.commandesEN@tplink WHERE no_commande = :old.no_commande;
    else 
      DELETE FROM cpottiez.commandesOI@tplink WHERE no_commande = :old.no_commande;
    end if;
  end if;

END;
/

-- test insert on commande
INSERT INTO COMMANDES VALUES (7000, '12345', 3, CURRENT_DATE, null, null);
INSERT INTO COMMANDES VALUES (5000, 'FOLKO', 3, CURRENT_DATE, null, null);
INSERT INTO COMMANDES VALUES (6666, 'PICCO', 3, CURRENT_DATE, null, null);
COMMIT;

-- test update on commandes
UPDATE COmmandes SET date_envoi = CURRENT_DATE WHERE code_client = '12345';
UPDATE COmmandes SET date_envoi = CURRENT_DATE WHERE code_client = 'FOLKO';
UPDATE COmmandes SET date_envoi = CURRENT_DATE WHERE code_client = 'PICCO';
COMMIT;

-- test delete on commandes
DELETE FROM Commandes WHERE code_client = '12345';
DELETE FROM Commandes WHERE code_client = 'FOLKO';
DELETE FROM Commandes WHERE code_client = 'PICCO';
COMMIT;

-- test insert on clients 
INSERT INTO CLIENTS VALUES ('haha', 'DARK side', 'death star', 'far far away', 666, 'Espagne', 'here''s my number', 'call me maybe');
INSERT INTO CLIENTS VALUES ('hihi', 'cold', 'st. cold, 31', 'Coldington', '-300', 'Suede', '000', '111');
INSERT INTO CLIENTS VALUES ('un', 'bla', 'blabla', 'Blablatown', '666', 'Autriche', '000', '111');
COMMIT;

-- test update on clients
UPDATE CLIENTS SET code_postal = 'new666' WHERE code_client = 'haha';
UPDATE CLIENTS SET code_postal = 'new-300' WHERE code_client = 'hihi';
UPDATE CLIENTS SET code_postal = 'new' WHERE code_client = 'un';
COMMIT;

-- test delete on clients
DELETE FROM CLIENTS WHERE code_client = 'haha';
DELETE FROM CLIENTS WHERE code_client = 'hihi';
DELETE FROM CLIENTS WHERE code_client = 'un';
COMMIT;

-- materialized view log

-- materialized views
CREATE MATERIALIZED VIEW PRODUITS 
REFRESH COMPLETE
NEXT sysdate +1/4096
AS 
  SELECT * 
  FROM LPOISSE.PRODUITS@LINKES;

DROP MATERIALIZED VIEW PRODUITS;
