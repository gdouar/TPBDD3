/*
	Trigger appel� lors d'une action LMD sur la vue 'Stock'
*/
create or replace TRIGGER modify_Stocks INSTEAD OF UPDATE OR INSERT or delete ON Stock
FOR EACH ROW
BEGIN

  IF INSERTING  THEN          --Insertion � contr�ler
     IF NOT (:NEW.pays in ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 
    'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 
    'Autriche', 'Suisse')) THEN
        RAISE_APPLICATION_ERROR(-20008, 'Erreur : le pays sp�cifi� n''a pas �t� reconnu.');
    else
      INSERT INTO Stockes 
      VALUES (:new.ref_produit,:new.pays, :new.unites_stock, :new.unites_commandees, :new.indisponible);
    end if;  
  end if;
  /*
  
					<!>   TODO:  WIP, il faut pouvoir identifier les colonnes ayant �t� mises � jour...   <!>
					
  
  IF UPDATING THEN          -- Modification � contr�ler : on ne peut pas modifier les donn�es d'un stock non local !
     IF NOT (:NEW.pays in ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 
    'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 
    'Autriche', 'Suisse')) THEN
      RAISE_APPLICATION_ERROR(-20008, 'Erreur : le pays sp�cifi� n''a pas �t� reconnu.');
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
    
  END IF;*/
  
 IF deleting THEN       --Suppression � v�rifier ; on ne peut pas supprimer un stock ne faisant pas partie de la r�gion du site (gestion du stock LOCAL seulement)
    IF NOT (:old.pays in ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 
    'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 
    'Autriche', 'Suisse')) THEN
        RAISE_APPLICATION_ERROR(-20008, 'Erreur : le pays sp�cifi� n''a pas �t� reconnu.');
    else
      delete from stockes where ref_produit = :old.ref_produit AND pays = :old.pays;
    end if;
 end if;
END;
/

/*
	Trigger appel� lors d'une action LMD sur la vue 'Clients'
*/
create or replace TRIGGER modify_Clients INSTEAD OF UPDATE OR INSERT or delete ON Clients
FOR EACH ROW
BEGIN

  IF INSERTING  THEN          --Insertion � contr�ler : on ne peut pas ajouter un client non local, car la gestion de ces clients ne d�pend pas de l'application SellIt Europe du Sud
     IF NOT (:NEW.pays in ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 
    'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 
    'Autriche', 'Suisse')) THEN
        RAISE_APPLICATION_ERROR(-20008, 'Erreur : le pays sp�cifi� n''a pas �t� reconnu.');
    else
      INSERT INTO Clientses 
      VALUES (:new.code_client,:new.societe, :new.adresse, :new.ville, :new.code_postal, :new.pays, :new.telephone, :new.fax);
    end if;  
  end if;
  
 
  /*
					<!>   TODO:  WIP, il faut pouvoir identifier les colonnes ayant �t� mises � jour...   <!>
					
  IF UPDATING THEN          -- Modification � contr�ler : on ne peut pas modifier les donn�es d'un client non local !
     IF NOT (:NEW.pays in ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 
    'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 
    'Autriche', 'Suisse')) THEN
      RAISE_APPLICATION_ERROR(-20008, 'Erreur : le pays sp�cifi� n''a pas �t� reconnu.');
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
*/
  
 IF deleting THEN       --Suppression standard, on ne peut pas supprimer un client non local, car la gestion de ces clients ne d�pend pas de l'application SellIt Europe du Sud
    IF NOT (:old.pays in ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 
    'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 
    'Autriche', 'Suisse')) THEN
        RAISE_APPLICATION_ERROR(-20008, 'Erreur : le pays sp�cifi� n''a pas �t� reconnu.');
    else
      delete from clientses where code_client = :old.code_client;
    end if;
 end if;
END;
/

/*
	Trigger appel� lors d'une action LMD sur la vue 'Commandes'
*/
create or replace TRIGGER modify_Commandes INSTEAD OF UPDATE OR INSERT or delete ON Commandes
FOR EACH ROW
DECLARE
clientCountry Clients.pays%Type;
BEGIN
	
  IF INSERTING  THEN          --Insertion � contr�ler : on ne peut pas ajouter des commandes d'un client �tranger (on ne travaille que sur les clients locaux)
	
	SELECT pays INTO clientCountry
	FROM Clients
	WHERE CODE_CLIENT = :new.CODE_CLIENT;
	
     IF NOT (clientCountry in ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 
    'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 
    'Autriche', 'Suisse')) THEN
        RAISE_APPLICATION_ERROR(-20009, 'Erreur : le client de la commande renseign�e ne se trouve pas dans la bonne r�gion.');
    else
      INSERT INTO Commandeses 
      VALUES (:new.NO_COMMANDE, :new.CODE_CLIENT, :new.NO_EMPLOYE, :new.DATE_COMMANDE, :new.DATE_ENVOI, :new.PORT);
    end if;  
  end if;
  
 /*
				<!>   TODO:  WIP, il faut pouvoir identifier les colonnes ayant �t� mises � jour...   <!>
				
  IF UPDATING THEN          -- Modification � contr�ler : on ne peut pas modifier les donn�es d'une commande d'un client �tranger !
  	
	SELECT pays INTO clientCountry
	FROM Clients
	WHERE CODE_CLIENT = :new.CODE_CLIENT;
	
     IF NOT (clientCountry in ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 
    'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 
    'Autriche', 'Suisse')) THEN
      RAISE_APPLICATION_ERROR(-20009, 'Erreur : le client de la commande renseign�e ne se trouve pas dans la bonne r�gion.');
      else
        update Commandeses          
        set 
        NO_COMMANDE = :new.NO_COMMANDE,
        CODE_CLIENT = :NEW.CODE_CLIENT,
        NO_EMPLOYE = :new.NO_EMPLOYE,
        DATE_COMMANDE = :new.DATE_COMMANDE,
        DATE_ENVOI = :new.DATE_ENVOI,
		PORT = :new.PORT,
		where no_commande = :old.no_commande;
      end if;
*/
  
 IF deleting THEN       --Suppression � v�rifier : on ne peut pas supprimer des commandes d'un client �tranger (on ne travaille que sur les clients locaux)
 	
	SELECT pays INTO clientCountry
	FROM Clients
	WHERE CODE_CLIENT = :old.CODE_CLIENT;
 
    IF NOT (clientCountry in ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 
    'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 
    'Autriche', 'Suisse')) THEN
        RAISE_APPLICATION_ERROR(-20009, 'Erreur : le client de la commande renseign�e ne se trouve pas dans la bonne r�gion.');
    else
      delete from Commandeses where no_commande = :old.no_commande;
    end if;
 end if;
 
 
 EXCEPTION
  WHEN NO_DATA_FOUND THEN 
    RAISE_APPLICATION_ERROR(-200010, 'Erreur : Le client associ� � la commande est inconnu.');		--Interception de l'erreur NO_DATA_FOUND (joue le r�le de la contrainte d'int�grit�)
 
END;
/


/*
	Trigger appel� lors d'une action LMD sur la vue 'D�tailsCommandes'
*/
create or replace TRIGGER modify_DetailsCommandes INSTEAD OF UPDATE OR INSERT or delete ON details_commandes
FOR EACH ROW
DECLARE
clientCountry Clients.pays%Type;
BEGIN
	
  IF INSERTING  THEN          --Insertion � contr�ler : on ne peut pas ajouter des d�tails de commandes d'un client �tranger (on ne travaille que sur les clients locaux)
	
	SELECT c.pays INTO clientCountry
	FROM Commande NATURAL JOIN Clients c
	WHERE CODE_CLIENT = (
		SELECT CODE_CLIENT FROM Commandes c2 WHERE c2.NO_COMMANDE = :new.NO_COMMANDE
	);
	
     IF NOT (clientCountry in ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 
    'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 
    'Autriche', 'Suisse')) THEN
        RAISE_APPLICATION_ERROR(-20009, 'Erreur : le client de la commande renseign�e ne se trouve pas dans la bonne r�gion.');
    else
      INSERT INTO DETAILS_Commandeses 
      VALUES (:new.NO_COMMANDE, :new.REF_PRODUIT, :new.PRIX_UNITAIRE, :new.QUANTITE, :new.REMISE);
    end if;  
  end if;
  
 /*
				<!>   TODO:  WIP, il faut pouvoir identifier les colonnes ayant �t� mises � jour...   <!>
				
  IF UPDATING THEN          -- Modification � contr�ler : on ne peut pas modifier les donn�es d'un d�tail de commande d'un client �tranger !
  	
	SELECT c.pays INTO clientCountry
	FROM Commande NATURAL JOIN Clients c
	WHERE CODE_CLIENT = (
		SELECT CODE_CLIENT FROM Commandes c2 WHERE c2.NO_COMMANDE = :new.NO_COMMANDE
	);
	
     IF NOT (clientCountry in ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 
    'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 
    'Autriche', 'Suisse')) THEN
      RAISE_APPLICATION_ERROR(-20009, 'Erreur : le client de la commande renseign�e ne se trouve pas dans la bonne r�gion.');
      else
        update DETAILS_Commandeses          
        set 
        NO_COMMANDE = :new.NO_COMMANDE,
        REF_PRODUIT = :NEW.REF_PRODUIT,
        PRIX_UNITAIRE = :new.PRIX_UNITAIRE,
        QUANTITE = :new.QUANTITE,
        REMISE = :new.REMISE,
		where NO_COMMANDE = :old.NO_COMMANDE AND REF_PRODUIT=:old.REF_PRODUIT;
      end if;
*/
  
 IF deleting THEN       --Suppression � v�rifier : on ne peut pas supprimer des d�tails de commandes d'un client �tranger (on ne travaille que sur les clients locaux)
 	
	SELECT c.pays INTO clientCountry
	FROM Commande NATURAL JOIN Clients c
	WHERE CODE_CLIENT = (
		SELECT CODE_CLIENT FROM Commandes c2 WHERE c2.NO_COMMANDE = :old.NO_COMMANDE
	);
 
    IF NOT (clientCountry in ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 
    'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 
    'Autriche', 'Suisse')) THEN
        RAISE_APPLICATION_ERROR(-20009, 'Erreur : le client de la commande renseign�e ne se trouve pas dans la bonne r�gion.');
    else
      delete from DETAILS_Commandeses where NO_COMMANDE = :old.NO_COMMANDE AND REF_PRODUIT=:old.REF_PRODUIT;
    end if;
 end if;
 
 
 EXCEPTION
  WHEN NO_DATA_FOUND THEN 
    RAISE_APPLICATION_ERROR(-200010, 'Erreur : Le client associ� � la commande est inconnu.');		--Interception de l'erreur NO_DATA_FOUND (joue le r�le de la contrainte d'int�grit�)
 
END;
