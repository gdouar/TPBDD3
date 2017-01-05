/*
  Trigger remplaçant l'insertion dans une vue spécifique (Stocks)
*/

CREATE OR REPLACE TRIGGER modify_Stocks INSTEAD OF UPDATE OR INSERT or delete ON Stock
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
  /*
  
                  WIP : il faut pouvoir identifier les colonnes ayant été mises à jour...
  
  IF UPDATING THEN          -- Modification à contrôler
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
        INDISPONIBLE = :new.INDISPONIBLE;
      end if;
    
  END IF;*/
  
   IF deleting THEN       --Suppression standard
      delete from stockes where ref_produit = :new.ref_produit AND pays = :new.pays;
    end if;
  
  
  
END;

