/*
Trigger appelé lors d'une action LMD sur la vue 'Stock'
*/
CREATE OR REPLACE TRIGGER modify_Stocks INSTEAD OF
  UPDATE OR
  INSERT OR
  DELETE ON Stock FOR EACH ROW BEGIN IF INSERTING THEN --Insertion à contrôler
	IF (:NEW.pays IN ('Suede', 'Norvege', 'Danemark', 'Finlande', 'Belgique', 'Irlande', 'Pologne', 'Royaume-Uni', 'Allemagne', 'Islande', 'Luxembourg', 'Pays-Bas')) THEN
  INSERT
  INTO STOCKEN VALUES
	(
  	:new.ref_produit,
  	:new.pays,
  	:new.unites_stock,
  	:new.unites_commandees,
  	:new.indisponible
	);
ELSIF (:NEW.pays IN ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 'Autriche', 'Suisse')) THEN
  INSERT
  INTO lpoisse.stockes@LinkToDBES VALUES
	(
  	:new.ref_produit,
  	:new.pays,
  	:new.unites_stock,
  	:new.unites_commandees,
  	:new.indisponible
	);
ELSIF (:NEW.pays IN('Antigua-et-Barbuda', 'Argentine', 'Bahamas', 'Barbade', 'Belize', 'Bolivie', 'Bresil', 'Canada', 'Chili', 'Colombie','Costa Rica', 'Cuba', 'Republique dominicaine', 'Dominique', 'Equateur', 'Etats-Unis', 'Grenade', 'Guatemala', 'Guyana', 'Haiti','Honduras', 'Jamaique', 'Mexique', 'Nicaragua', 'Panama', 'Paraguay', 'Perou', 'Saint-Christophe-et-Nieves', 'Sainte-Lucie', 'Saint-Vincent-et-les Grenadines', 'Salvador', 'Suriname', 'Trinite-et-Tobago', 'Uruguay', 'Venezuela')) THEN
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
IF UPDATING THEN -- Modification à contrôler : on ne peut pas modifier les données d'un stock non local !
  IF (:NEW.pays IN ('Suede', 'Norvege', 'Danemark', 'Finlande', 'Belgique', 'Irlande', 'Pologne', 'Royaume-Uni', 'Allemagne', 'Islande', 'Luxembourg', 'Pays-Bas')) THEN
	UPDATE STOCKEN
	SET ref_produit 	= :new.ref_produit,
  	PAYS          	= :NEW.PAYS,
  	UNITES_STOCK  	= :new.UNITES_STOCK,
  	UNITES_COMMANDEES = :new.UNITES_COMMANDEES,
  	INDISPONIBLE  	= :new.INDISPONIBLE
	WHERE ref_produit   = :old.ref_produit
	AND pays        	= :old.PAYS;
  ELSIF (:NEW.pays IN ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 'Autriche', 'Suisse')) THEN
	UPDATE lpoisse.stockes@LinkToDBES
	SET ref_produit 	= :new.ref_produit,
  	PAYS          	= :NEW.PAYS,
  	UNITES_STOCK  	= :new.UNITES_STOCK,
  	UNITES_COMMANDEES = :new.UNITES_COMMANDEES,
  	INDISPONIBLE  	= :new.INDISPONIBLE
	WHERE ref_produit   = :old.ref_produit
	AND pays        	= :old.PAYS;
  ELSIF (:NEW.pays IN('Antigua-et-Barbuda', 'Argentine', 'Bahamas', 'Barbade', 'Belize', 'Bolivie', 'Bresil', 'Canada', 'Chili', 'Colombie','Costa Rica', 'Cuba', 'Republique dominicaine', 'Dominique', 'Equateur', 'Etats-Unis', 'Grenade', 'Guatemala', 'Guyana', 'Haiti','Honduras', 'Jamaique', 'Mexique', 'Nicaragua', 'Panama', 'Paraguay', 'Perou', 'Saint-Christophe-et-Nieves', 'Sainte-Lucie', 'Saint-Vincent-et-les Grenadines', 'Salvador', 'Suriname', 'Trinite-et-Tobago', 'Uruguay', 'Venezuela')) THEN
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
	UPDATE STOCKOI
	SET ref_produit 	= :new.ref_produit,
  	PAYS          	= :NEW.PAYS,
  	UNITES_STOCK  	= :new.UNITES_STOCK,
  	UNITES_COMMANDEES = :new.UNITES_COMMANDEES,
  	INDISPONIBLE  	= :new.INDISPONIBLE
	WHERE ref_produit   = :old.ref_produit
	AND pays        	= :old.PAYS;
  END IF;
END IF;
IF DELETING THEN --Suppression à vérifier ; on ne peut pas supprimer un stock ne faisant pas partie de la région du site (gestion du stock LOCAL seulement)
  IF (:old.pays IN ('Suede', 'Norvege', 'Danemark', 'Finlande', 'Belgique', 'Irlande', 'Pologne', 'Royaume-Uni', 'Allemagne', 'Islande', 'Luxembourg', 'Pays-Bas')) THEN
	DELETE FROM STOCKEN WHERE ref_produit = :old.ref_produit AND pays = :old.pays;
  ELSIF (:old.pays IN ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 'Autriche', 'Suisse')) THEN
	DELETE
	FROM lpoisse.stockes@LinkToDBES
	WHERE ref_produit = :old.ref_produit
	AND pays      	= :old.pays;
  ELSIF (:old.pays IN('Antigua-et-Barbuda', 'Argentine', 'Bahamas', 'Barbade', 'Belize', 'Bolivie', 'Bresil', 'Canada', 'Chili', 'Colombie','Costa Rica', 'Cuba', 'Republique dominicaine', 'Dominique', 'Equateur', 'Etats-Unis', 'Grenade', 'Guatemala', 'Guyana', 'Haiti','Honduras', 'Jamaique', 'Mexique', 'Nicaragua', 'Panama', 'Paraguay', 'Perou', 'Saint-Christophe-et-Nieves', 'Sainte-Lucie', 'Saint-Vincent-et-les Grenadines', 'Salvador', 'Suriname', 'Trinite-et-Tobago', 'Uruguay', 'Venezuela')) THEN
	DELETE
	FROM hcburca.stock_am@LinkToDBUS
	WHERE ref_produit = :old.ref_produit
	AND pays      	= :old.pays;
  ELSE
	DELETE FROM STOCKOI WHERE ref_produit = :old.ref_produit AND pays = :old.pays;
  END IF;
END IF;
END;



/*
  Trigger de modification d'un client
*/

create or replace TRIGGER modify_Clients INSTEAD OF UPDATE OR INSERT or delete ON Clients
FOR EACH ROW
BEGIN
IF INSERTING then 

IF (:NEW.pays in ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 
    'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 
    'Autriche', 'Suisse')) THEN
    
      INSERT INTO Clientses 
      VALUES (:new.code_client,:new.societe, :new.adresse, :new.ville, :new.code_postal, :new.pays, :new.telephone, :new.fax);
     
   ELSIF (:new.pays in  ('Antigua-et-Barbuda', 'Argentine', 'Bahamas', 'Barbade', 'Belize', 'Bolivie', 'Bresil',
  'Canada', 'Chili', 'Colombie','Costa Rica', 'Cuba', 'Republique dominicaine', 'Dominique',
  'Equateur', 'Etats-Unis', 'Grenade', 'Guatemala', 'Guyana', 'Haiti','Honduras', 'Jamaique',
  'Mexique', 'Nicaragua', 'Panama', 'Paraguay', 'Perou', 'Saint-Christophe-et-Nieves', 'Sainte-Lucie',
  'Saint-Vincent-et-les Grenadines', 'Salvador', 'Suriname', 'Trinite-et-Tobago', 'Uruguay',
  'Venezuela')) then
          INSERT INTO hcburca.Clients_am@dbLinkUS 
         VALUES (:new.code_client,:new.societe, :new.adresse, :new.ville, :new.code_postal, :new.pays, :new.telephone, :new.fax);

      ELSIF  (:new.pays in ('Suede', 'Norvege', 'Danemark', 'Finlande', 'Belgique', 'Irlande', 'Pologne', 'Royaume-Uni', 'Allemagne', 'Islande', 'Luxembourg', 'Pays-Bas'))
        then
         INSERT INTO cpottiez.ClientsEN@dblinkMain
         VALUES (:new.code_client,:new.societe, :new.adresse, :new.ville, :new.code_postal, :new.pays, :new.telephone, :new.fax);

      else
         INSERT INTO cpottiez.ClientsOI@dblinkMain
          VALUES (:new.code_client,:new.societe, :new.adresse, :new.ville, :new.code_postal, :new.pays, :new.telephone, :new.fax);
  end if;
	END IF;
  
  if UPDATING THEN
  
  if(:New.pays <> :OLD.pays) then
     RAISE_APPLICATION_ERROR(-20010,'Attention, vous n''êtes pas autorisé à changer le pays de l''entreprise');
    end if;
     IF (:NEW.pays in ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 
    'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 
    'Autriche', 'Suisse')) THEN
    update clientses          
        set 
        code_client = :new.code_client,
        societe = :NEW.societe,
        adresse = :new.adresse,
        ville = :new.ville,
        code_postal = :new.code_postal,
        pays = :new.pays,
        telephone = :new.telephone,
        fax = :new.fax
      WHERE code_client = :old.code_client;
      ELSIF  (:new.pays in ('Antigua-et-Barbuda', 'Argentine', 'Bahamas', 'Barbade', 'Belize', 'Bolivie', 'Bresil',
  'Canada', 'Chili', 'Colombie','Costa Rica', 'Cuba', 'Republique dominicaine', 'Dominique',
  'Equateur', 'Etats-Unis', 'Grenade', 'Guatemala', 'Guyana', 'Haiti','Honduras', 'Jamaique',
  'Mexique', 'Nicaragua', 'Panama', 'Paraguay', 'Perou', 'Saint-Christophe-et-Nieves', 'Sainte-Lucie',
  'Saint-Vincent-et-les Grenadines', 'Salvador', 'Suriname', 'Trinite-et-Tobago', 'Uruguay',
  'Venezuela')) then
        update hcburca.clients_am@dblinkUS          
        set 
        code_client = :new.code_client,
        societe = :NEW.societe,
        adresse = :new.adresse,
        ville = :new.ville,
        code_postal = :new.code_postal,
        pays = :new.pays,
        telephone = :new.telephone,
        fax = :new.fax
      WHERE code_client = :old.code_client;
      ELSIF  (:new.pays in ('Suede', 'Norvege', 'Danemark', 'Finlande', 'Belgique', 'Irlande', 
      'Pologne', 'Royaume-Uni', 'Allemagne', 'Islande', 'Luxembourg', 'Pays-Bas')) then
       update cpottiez.clientsen@dbLinkMain          
        set 
        code_client = :new.code_client,
        societe = :NEW.societe,
        adresse = :new.adresse,
        ville = :new.ville,
        code_postal = :new.code_postal,
        pays = :new.pays,
        telephone = :new.telephone,
        fax = :new.fax
      WHERE code_client = :old.code_client;
      else
        update cpottiez.clientsoi@dbLinkMain          
        set 
        code_client = :new.code_client,
        societe = :NEW.societe,
        adresse = :new.adresse,
        ville = :new.ville,
        code_postal = :new.code_postal,
        pays = :new.pays,
        telephone = :new.telephone,
        fax = :new.fax
      WHERE code_client = :old.code_client;
      end if;
  end if;
  
  IF DELETING THEN
  
    IF  (:old.pays in ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 
    'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 
    'Autriche', 'Suisse')) THEN
    delete from clientses where code_client = :old.code_client;
    
    ELSIF (:old.pays in  ('Antigua-et-Barbuda', 'Argentine', 'Bahamas', 'Barbade', 'Belize', 'Bolivie', 'Bresil',
  'Canada', 'Chili', 'Colombie','Costa Rica', 'Cuba', 'Republique dominicaine', 'Dominique',
  'Equateur', 'Etats-Unis', 'Grenade', 'Guatemala', 'Guyana', 'Haiti','Honduras', 'Jamaique',
  'Mexique', 'Nicaragua', 'Panama', 'Paraguay', 'Perou', 'Saint-Christophe-et-Nieves', 'Sainte-Lucie',
  'Saint-Vincent-et-les Grenadines', 'Salvador', 'Suriname', 'Trinite-et-Tobago', 'Uruguay',
  'Venezuela')) then
        delete from hcburca.clients_AM@dbLinkUS where code_client = :old.code_client;
   ELSIF (:old.pays in ('Suede', 'Norvege', 'Danemark', 'Finlande', 'Belgique', 
   'Irlande', 'Pologne', 'Royaume-Uni', 'Allemagne', 'Islande', 'Luxembourg', 'Pays-Bas'))then
         delete from cpottiez.clientsEN@dbLinkMain where code_client = :old.code_client;
    else
         delete from cpottiez.clientsOI@dbLinkMain where code_client= :old.code_client;
    end if;
  END IF;
end;

/* 
	Trigger pour insert, update, delete on Commandes
*/
create or replace TRIGGER MODIFY_COMMANDES
INSTEAD OF DELETE OR INSERT OR UPDATE ON COMMANDES 
FOR EACH ROW
DECLARE
  paysclient$ varchar2(15);
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
      INSERT INTO hcburca.Commandes_AM@dblinkus VALUES (:new.no_commande, :new.code_client, :new.no_employe, :new.date_commande, :new.date_envoi, :new.port);
    elsif (paysclient$ in ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 
                             'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 
                             'Autriche', 'Suisse')) then
      INSERT INTO commandesES VALUES (:new.no_commande, :new.code_client, :new.no_employe, :new.date_commande, :new.date_envoi, :new.port);
    elsif (paysclient$ in ('Suede', 'Norvege', 'Danemark', 'Finlande', 'Belgique', 'Irlande', 'Pologne', 'Royaume-Uni', 'Allemagne', 'Islande', 
                             'Luxembourg', 'Pays-Bas')) then 
      INSERT INTO cpottiez.commandesEN@dblinkmain VALUES (:new.no_commande, :new.code_client, :new.no_employe, :new.date_commande, :new.date_envoi, :new.port);
    else 
      INSERT INTO cpottiez.commandesOI@dblinkmain VALUES (:new.no_commande, :new.code_client, :new.no_employe, :new.date_commande, :new.date_envoi, :new.port);
    end if;
  elsif (updating) then
    if (paysclient$ in ('Antigua-et-Barbuda', 'Argentine', 'Bahamas', 'Barbade', 'Belize', 'Bolivie', 'Bresil',
                      'Canada', 'Chili', 'Colombie','Costa Rica', 'Cuba', 'Republique dominicaine', 'Dominique',
                      'Equateur', 'Etats-Unis', 'Grenade', 'Guatemala', 'Guyana', 'Haiti','Honduras', 'Jamaique',
                      'Mexique', 'Nicaragua', 'Panama', 'Paraguay', 'Perou', 'Saint-Christophe-et-Nieves', 'Sainte-Lucie',
                      'Saint-Vincent-et-les Grenadines', 'Salvador', 'Suriname', 'Trinite-et-Tobago', 'Uruguay',
                      'Venezuela')) then
      UPDATE hcburca.Commandes_AM@dblinkus SET no_commande = :new.no_commande, code_client = :new.code_client, no_employe = :new.no_employe, 
                              date_commande = :new.date_commande, date_envoi = :new.date_envoi, port = :new.port
                          WHERE no_commande = :old.no_commande;
    elsif (paysclient$ in ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 
                             'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 
                             'Autriche', 'Suisse')) then
      UPDATE commandesES SET no_commande = :new.no_commande, code_client = :new.code_client, no_employe = :new.no_employe, 
                              date_commande = :new.date_commande, date_envoi = :new.date_envoi, port = :new.port
                          WHERE no_commande = :old.no_commande;
    elsif (paysclient$ in ('Suede', 'Norvege', 'Danemark', 'Finlande', 'Belgique', 'Irlande', 'Pologne', 'Royaume-Uni', 'Allemagne', 'Islande', 
                             'Luxembourg', 'Pays-Bas')) then 
      UPDATE cpottiez.commandesEN@dblinkmain SET no_commande = :new.no_commande, code_client = :new.code_client, no_employe = :new.no_employe, 
                              date_commande = :new.date_commande, date_envoi = :new.date_envoi, port = :new.port
                          WHERE no_commande = :old.no_commande;
    else 
      UPDATE cpottiez.commandesOI@dblinkmain SET no_commande = :new.no_commande, code_client = :new.code_client, no_employe = :new.no_employe, 
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
      DELETE FROM hcburca.Commandes_AM@dblinkus WHERE no_commande = :old.no_commande;
    elsif (paysclient$ in ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 
                             'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 
                             'Autriche', 'Suisse')) then
      DELETE FROM commandesES WHERE no_commande = :old.no_commande;
    elsif (paysclient$ in ('Suede', 'Norvege', 'Danemark', 'Finlande', 'Belgique', 'Irlande', 'Pologne', 'Royaume-Uni', 'Allemagne', 'Islande', 
                             'Luxembourg', 'Pays-Bas')) then 
      DELETE FROM cpottiez.commandesEN@dblinkmain WHERE no_commande = :old.no_commande;
    else 
      DELETE FROM cpottiez.commandesOI@dblinkmain WHERE no_commande = :old.no_commande;
    end if;
  end if;

EXCEPTION
  WHEN no_data_found then 
  raise_application_error(-20011, 'Erreur : le client indiqué est inconnu.');

END;
/

/*
Trigger appelé lors d'une action LMD sur la vue 'DETAILS_COMMANDES'
*/
create or replace TRIGGER modify_DetailsCommandes INSTEAD OF
  UPDATE OR
  INSERT OR
  DELETE ON DETAILS_COMMANDES FOR EACH ROW 
  DECLARE 
  paysTest VARCHAR2(24);
  BEGIN 
  if(updating or inserting) then
    SELECT pays into paystest
    FROM CLIENTS natural join COMMANDES
    where no_commande = :new.no_commande;
    end if;
    
  IF INSERTING THEN         --Insertion à contrôler
        
    IF (paysTest   IN ('Suede', 'Norvege', 'Danemark', 'Finlande', 'Belgique', 'Irlande', 'Pologne', 'Royaume-Uni', 'Allemagne', 'Islande', 'Luxembourg', 'Pays-Bas')) THEN
      INSERT
      INTO cpottiez.DETAILS_COMMANDESEN@dblinkmain VALUES
        (
          :new.no_commande,
          :new.ref_produit,
          :new.prix_unitaire,
          :new.quantite,
          :new.remise
        );
    ELSIF (paysTest IN ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 'Autriche', 'Suisse')) THEN
      INSERT
      INTO details_commandesES VALUES
        (
          :new.no_commande,
          :new.ref_produit,
          :new.prix_unitaire,
          :new.quantite,
          :new.remise
        );
    ELSIF (paysTest IN('Antigua-et-Barbuda', 'Argentine', 'Bahamas', 'Barbade', 'Belize', 'Bolivie', 'Bresil', 'Canada', 'Chili', 'Colombie','Costa Rica', 'Cuba', 'Republique dominicaine', 'Dominique', 'Equateur', 'Etats-Unis', 'Grenade', 'Guatemala', 'Guyana', 'Haiti','Honduras', 'Jamaique', 'Mexique', 'Nicaragua', 'Panama', 'Paraguay', 'Perou', 'Saint-Christophe-et-Nieves', 'Sainte-Lucie', 'Saint-Vincent-et-les Grenadines', 'Salvador', 'Suriname', 'Trinite-et-Tobago', 'Uruguay', 'Venezuela')) THEN
      INSERT
      INTO hcburca.Details_Commandes_AM@dbLinkUS VALUES
        (
          :new.no_commande,
          :new.ref_produit,
          :new.prix_unitaire,
          :new.quantite,
          :new.remise
        );
    ELSE
      INSERT
      INTO cpottiez.details_commandesOI@dblinkmain VALUES
        (
          :new.no_commande,
          :new.ref_produit,
          :new.prix_unitaire,
          :new.quantite,
          :new.remise
        );
    END IF;
  END IF;
  IF UPDATING THEN -- Modification à contrôler : on ne peut pas modifier les données d'un stock non local !

    IF(:old.ref_produit= :new.ref_produit AND :old.NO_COMMANDE= :new.no_commande) then
      IF (paysTest IN ('Suede', 'Norvege', 'Danemark', 'Finlande', 'Belgique', 'Irlande', 'Pologne', 'Royaume-Uni', 'Allemagne', 'Islande', 'Luxembourg', 'Pays-Bas')) THEN
        UPDATE cpottiez.DETAILS_COMMANDESEN@dblinkmain
        SET ref_produit   = :new.ref_produit,
          NO_COMMANDE     = :new.no_commande,
          PRIX_UNITAIRE   = :new.PRIX_UNITAIRE,
          QUANTITE        = :new.QUANTITE,
          REMISE          = :new.REMISE
        WHERE ref_produit = :old.ref_produit
        AND no_commande   = :old.no_commande;
      ELSIF (paysTest IN ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 'Autriche', 'Suisse')) THEN
        UPDATE details_commandesES
        SET ref_produit   = :new.ref_produit,
          NO_COMMANDE     = :new.no_commande,
          PRIX_UNITAIRE   = :new.PRIX_UNITAIRE,
          QUANTITE        = :new.QUANTITE,
          REMISE          = :new.REMISE
        WHERE ref_produit = :old.ref_produit
        AND no_commande   = :old.no_commande;
      ELSIF (paysTest IN('Antigua-et-Barbuda', 'Argentine', 'Bahamas', 'Barbade', 'Belize', 'Bolivie', 'Bresil', 'Canada', 'Chili', 'Colombie','Costa Rica', 'Cuba', 'Republique dominicaine', 'Dominique', 'Equateur', 'Etats-Unis', 'Grenade', 'Guatemala', 'Guyana', 'Haiti','Honduras', 'Jamaique', 'Mexique', 'Nicaragua', 'Panama', 'Paraguay', 'Perou', 'Saint-Christophe-et-Nieves', 'Sainte-Lucie', 'Saint-Vincent-et-les Grenadines', 'Salvador', 'Suriname', 'Trinite-et-Tobago', 'Uruguay', 'Venezuela')) THEN
        UPDATE hcburca.Details_Commandes_AM@dbLinkUS
        SET ref_produit   = :new.ref_produit,
          NO_COMMANDE     = :new.no_commande,
          PRIX_UNITAIRE   = :new.PRIX_UNITAIRE,
          QUANTITE        = :new.QUANTITE,
          REMISE          = :new.REMISE
        WHERE ref_produit = :old.ref_produit
        AND no_commande   = :old.no_commande;
      ELSE
        UPDATE cpottiez.details_commandesOI@dblinkmain
        SET ref_produit   = :new.ref_produit,
          NO_COMMANDE     = :new.no_commande,
          PRIX_UNITAIRE   = :new.PRIX_UNITAIRE,
          QUANTITE        = :new.QUANTITE,
          REMISE          = :new.REMISE
        WHERE ref_produit = :old.ref_produit
        AND no_commande   = :old.no_commande;
      END IF;
    END IF;
  END IF;
  IF DELETING THEN 
   
--   DBMS_OUTPUT.PUT_LINE(:old.no_commande||' - ' || :old.ref_produit); 
    SELECT pays into paysTest
    FROM CLIENTS natural join COMMANDES
    where no_commande = :old.no_commande;
        
   IF (paysTest  IN ('Suede', 'Norvege', 'Danemark', 'Finlande', 'Belgique', 'Irlande', 'Pologne', 'Royaume-Uni', 'Allemagne', 'Islande', 'Luxembourg', 'Pays-Bas')) THEN
      DELETE
      FROM cpottiez.DETAILS_COMMANDESEN@dblinkmain
      WHERE ref_produit = :old.ref_produit
      AND no_commande   = :old.no_commande;
      
      ELSIF (paysTest IN ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 'Autriche', 'Suisse')) THEN
      
      DELETE
      FROM details_commandesES
      WHERE ref_produit = :old.ref_produit
      AND no_commande   = :old.no_commande;
    ELSIF (paysTest IN('Antigua-et-Barbuda', 'Argentine', 'Bahamas', 'Barbade', 'Belize', 'Bolivie', 'Bresil', 'Canada', 'Chili', 'Colombie','Costa Rica', 'Cuba', 'Republique dominicaine', 'Dominique', 'Equateur', 'Etats-Unis', 'Grenade', 'Guatemala', 'Guyana', 'Haiti','Honduras', 'Jamaique', 'Mexique', 'Nicaragua', 'Panama', 'Paraguay', 'Perou', 'Saint-Christophe-et-Nieves', 'Sainte-Lucie', 'Saint-Vincent-et-les Grenadines', 'Salvador', 'Suriname', 'Trinite-et-Tobago', 'Uruguay', 'Venezuela')) THEN
      DELETE
      FROM hcburca.Details_Commandes_AM@dbLinkUS
      WHERE ref_produit = :old.ref_produit
      AND no_commande   = :old.no_commande;
    ELSE
      DELETE
      FROM cpottiez.details_commandesOI@dblinkmain
      WHERE ref_produit = :old.ref_produit
      AND no_commande   = :old.no_commande;
    END IF;
  END IF;
  
  exception
    when no_data_found then
      raise_application_error(-20012, 'La commande indiquée est inconnue');
END;