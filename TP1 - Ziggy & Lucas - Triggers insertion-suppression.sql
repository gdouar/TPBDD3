/*
	Trigger appelé lors d'une action LMD sur la vue 'Stock'
*/
create or replace TRIGGER modify_Stocks INSTEAD OF UPDATE OR INSERT or delete ON Stock
FOR EACH ROW
BEGIN

  IF INSERTING  THEN          --Insertion à contrôler
     IF NOT (:NEW.pays in ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 
    'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 
    'Autriche', 'Suisse')) THEN
        RAISE_APPLICATION_ERROR(-20008, 'Erreur : le pays spécifié n''a pas été reconnu.');
    else
      INSERT INTO Stockes 
      VALUES (:new.ref_produit,:new.pays, :new.unites_stock, :new.unites_commandees, :new.indisponible);
    end if;  
  end if;
  
  IF UPDATING THEN          -- Modification à contrôler : on ne peut pas modifier les données d'un stock non local !
     IF NOT (:NEW.pays in ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 
    'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 
    'Autriche', 'Suisse')) THEN
      RAISE_APPLICATION_ERROR(-20008, 'Erreur : le pays spécifié n''a pas été reconnu.');
      else
        update stockes          
        set 
        ref_produit = :new.ref_produit,
        PAYS = :NEW.PAYS,
        UNITES_STOCK = :new.UNITES_STOCK,
        UNITES_COMMANDEES = :new.UNITES_COMMANDEES,
        INDISPONIBLE = :new.INDISPONIBLE
		WHERE ref_produit = :old.ref_produit AND pays=:old.PAYS;
      end if;
    
  END IF;
  
 IF deleting THEN       --Suppression à vérifier ; on ne peut pas supprimer un stock ne faisant pas partie de la région du site (gestion du stock LOCAL seulement)
    DBMS_OUTPUT.PUT_LINE('Pays = ' || :old.pays);
    IF NOT (:old.pays in ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 
    'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 
    'Autriche', 'Suisse')) THEN
        RAISE_APPLICATION_ERROR(-20008, 'Erreur : le pays spécifié n''a pas été reconnu.');
    else
      delete from stockes where ref_produit = :old.ref_produit AND pays = :old.pays;
    end if;
 end if;
END;
/

/*
	Trigger appelé lors d'une action LMD sur la vue 'Clients'
*/
create or replace TRIGGER modify_Clients INSTEAD OF UPDATE OR INSERT or delete ON Clients
FOR EACH ROW
BEGIN

  IF INSERTING  THEN          --Insertion à contrôler : on ne peut pas ajouter un client non local, car la gestion de ces clients ne dépend pas de l'application SellIt Europe du Sud
     IF NOT (:NEW.pays in ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 
    'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 
    'Autriche', 'Suisse')) THEN
        RAISE_APPLICATION_ERROR(-20008, 'Erreur : le pays spécifié n''a pas été reconnu.');
    else
      INSERT INTO Clientses 
      VALUES (:new.code_client,:new.societe, :new.adresse, :new.ville, :new.code_postal, :new.pays, :new.telephone, :new.fax);
    end if;  
  end if;
  
  IF UPDATING THEN          -- Modification à contrôler : on ne peut pas modifier les données d'un client non local !
     IF NOT (:NEW.pays in ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 
    'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 
    'Autriche', 'Suisse')) THEN
      RAISE_APPLICATION_ERROR(-20008, 'Erreur : le pays spécifié n''a pas été reconnu.');
      else
        
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
      end if;
  end if;
  
 IF deleting THEN       --Suppression standard, on ne peut pas supprimer un client non local, car la gestion de ces clients ne dépend pas de l'application SellIt Europe du Sud
    IF NOT (:old.pays in ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 
    'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 
    'Autriche', 'Suisse')) THEN
        RAISE_APPLICATION_ERROR(-20008, 'Erreur : le pays spécifié n''a pas été reconnu.');
    else
      delete from clientses where code_client = :old.code_client;
    end if;
 end if;
END;
/

/*
	Trigger appelé lors d'une action LMD sur la vue 'Commandes'
*/
create or replace TRIGGER modify_Commandes INSTEAD OF UPDATE OR INSERT or delete ON Commandes
FOR EACH ROW
DECLARE
clientCountry Clients.pays%Type;
BEGIN
	
  IF INSERTING  THEN          --Insertion à contrôler : on ne peut pas ajouter des commandes d'un client étranger (on ne travaille que sur les clients locaux)
	
	SELECT pays INTO clientCountry
	FROM Clients
	WHERE CODE_CLIENT = :new.CODE_CLIENT;
	
     IF NOT (clientCountry in ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 
    'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 
    'Autriche', 'Suisse')) THEN
        RAISE_APPLICATION_ERROR(-20009, 'Erreur : le client de la commande renseignée ne se trouve pas dans la bonne région.');
    else
      INSERT INTO Commandeses 
      VALUES (:new.NO_COMMANDE, :new.CODE_CLIENT, :new.NO_EMPLOYE, :new.DATE_COMMANDE, :new.DATE_ENVOI, :new.PORT);
    end if;  
  end if;

  IF UPDATING THEN          -- Modification à contrôler : on ne peut pas modifier les données d'une commande d'un client étranger !
  	
	SELECT pays INTO clientCountry
	FROM Clients
	WHERE CODE_CLIENT = :new.CODE_CLIENT;
	
     IF NOT (clientCountry in ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 
    'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 
    'Autriche', 'Suisse')) THEN
      RAISE_APPLICATION_ERROR(-20009, 'Erreur : le client de la commande renseignée ne se trouve pas dans la bonne région.');
      else
        update Commandeses          
        set 
        NO_COMMANDE = :new.NO_COMMANDE,
        CODE_CLIENT = :NEW.CODE_CLIENT,
        NO_EMPLOYE = :new.NO_EMPLOYE,
        DATE_COMMANDE = :new.DATE_COMMANDE,
        DATE_ENVOI = :new.DATE_ENVOI,
        PORT = :new.PORT
        where no_commande = :old.no_commande;
      end if;
  END IF;
  
 IF deleting THEN       --Suppression à vérifier : on ne peut pas supprimer des commandes d'un client étranger (on ne travaille que sur les clients locaux)
 	
	SELECT pays INTO clientCountry
	FROM Clients
	WHERE CODE_CLIENT = :old.CODE_CLIENT;
 
    IF NOT (clientCountry in ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 
    'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 
    'Autriche', 'Suisse')) THEN
        RAISE_APPLICATION_ERROR(-20009, 'Erreur : le client de la commande renseignée ne se trouve pas dans la bonne région.');
    else
      delete from Commandeses where no_commande = :old.no_commande;
    end if;
 end if;
 
 
 EXCEPTION
  WHEN NO_DATA_FOUND THEN 
    RAISE_APPLICATION_ERROR(-20010, 'Erreur : Le client associé à la commande est inconnu.');		--Interception de l'erreur NO_DATA_FOUND (joue le rôle de la contrainte d'intégrité)
 
END;
/

/*
	Trigger appelé lors d'une action LMD sur la vue 'DétailsCommandes'
*/
create or replace TRIGGER modify_DetailsCommandes INSTEAD OF UPDATE OR INSERT or delete ON details_commandes
FOR EACH ROW
DECLARE
clientCountry Clients.pays%Type;
BEGIN
	
  IF INSERTING  THEN          --Insertion à contrôler : on ne peut pas ajouter des détails de commandes d'un client étranger (on ne travaille que sur les clients locaux)
	
	SELECT DISTINCT c.pays INTO clientCountry
	FROM Commandes NATURAL JOIN Clients c
	WHERE CODE_CLIENT = (
		SELECT CODE_CLIENT FROM Commandes c2 WHERE c2.NO_COMMANDE = :new.NO_COMMANDE
	);
	
     IF NOT (clientCountry in ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 
    'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 
    'Autriche', 'Suisse')) THEN
        RAISE_APPLICATION_ERROR(-20009, 'Erreur : le client de la commande renseignée ne se trouve pas dans la bonne région.');
    else
      INSERT INTO DETAILS_Commandeses 
      VALUES (:new.NO_COMMANDE, :new.REF_PRODUIT, :new.PRIX_UNITAIRE, :new.QUANTITE, :new.REMISE);
    end if;  
  end if;
  
  IF UPDATING THEN          -- Modification à contrôler : on ne peut pas modifier les données d'un détail de commande d'un client étranger !
  	
	SELECT DISTINCT c.pays INTO clientCountry
	FROM Commandes NATURAL JOIN Clients c
	WHERE CODE_CLIENT = (
		SELECT CODE_CLIENT FROM Commandes c2 WHERE c2.NO_COMMANDE = :new.NO_COMMANDE
	);
	
     IF NOT (clientCountry in ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 
    'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 
    'Autriche', 'Suisse')) THEN
      RAISE_APPLICATION_ERROR(-20009, 'Erreur : le client de la commande renseignée ne se trouve pas dans la bonne région.');
      else
        update DETAILS_Commandeses          
        set 
        NO_COMMANDE = :new.NO_COMMANDE,
        REF_PRODUIT = :NEW.REF_PRODUIT,
        PRIX_UNITAIRE = :new.PRIX_UNITAIRE,
        QUANTITE = :new.QUANTITE,
        REMISE = :new.REMISE
        where NO_COMMANDE = :old.NO_COMMANDE AND REF_PRODUIT=:old.REF_PRODUIT;
      end if;
  END IF;
  
 IF deleting THEN       --Suppression à vérifier : on ne peut pas supprimer des détails de commandes d'un client étranger (on ne travaille que sur les clients locaux)
 	
	SELECT DISTINCT c.pays INTO clientCountry
	FROM Commandes NATURAL JOIN Clients c
	WHERE CODE_CLIENT = (
		SELECT CODE_CLIENT FROM Commandes c2 WHERE c2.NO_COMMANDE = :old.NO_COMMANDE
	);
 
    IF NOT (clientCountry in ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 
    'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 
    'Autriche', 'Suisse')) THEN
        RAISE_APPLICATION_ERROR(-20009, 'Erreur : le client de la commande renseignée ne se trouve pas dans la bonne région.');
    else
      delete from DETAILS_Commandeses where NO_COMMANDE = :old.NO_COMMANDE AND REF_PRODUIT=:old.REF_PRODUIT;
    end if;
 end if;
 
 
 EXCEPTION
  WHEN NO_DATA_FOUND THEN 
    RAISE_APPLICATION_ERROR(-20010, 'Erreur : Le client associé à la commande est inconnu.');		--Interception de l'erreur NO_DATA_FOUND (joue le rôle de la contrainte d'intégrité)
 
END;