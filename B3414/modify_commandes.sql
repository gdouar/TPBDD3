-- trigger pour modifier la vue commandes
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