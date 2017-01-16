-- Contraintes primary key

ALTER TABLE clients_am ADD CONSTRAINT pkClient PRIMARY KEY(code_client);
ALTER TABLE commandes_am ADD CONSTRAINT pkCommande PRIMARY KEY (no_commande);
ALTER TABLE employes ADD CONSTRAINT pkEmploye PRIMARY KEY (no_employe);
ALTER TABLE details_commandes_am ADD CONSTRAINT pkDetails PRIMARY KEY (no_commande, ref_produit);
ALTER TABLE stock_am ADD CONSTRAINT pkStock PRIMARY KEY (ref_produit, pays);

-- Contraintes foreign key

ALTER TABLE employes ADD CONSTRAINT fkEmployeEmploye FOREIGN KEY (rend_Compte) REFERENCES Employes(no_employe);
ALTER TABLE commandes_am ADD CONSTRAINT fkCommandesClients FOREIGN KEY (code_client) REFERENCES Clients_am(code_client);
ALTER TABLE commandes_am ADD CONSTRAINT fkCommandesEmployes FOREIGN KEY (no_employe) REFERENCES Employes(no_employe);
ALTER TABLE details_commandes_am ADD CONSTRAINT fkDetailsCommandesCommandes FOREIGN KEY (no_commande) REFERENCES Commandes_am(no_commande) ON DELETE CASCADE;

-- Trigger contraintes foreign key pour les references non-locales

-- details_commandes_am -> produits
CREATE OR REPLACE TRIGGER FKDETAILSCOMMANDESPRODUITS 
BEFORE INSERT OR UPDATE ON details_commandes_am 
FOR EACH ROW
DECLARE

  refprod$ details_commandes_am.ref_produit%TYPE;
  
BEGIN
  Select ref_produit into refprod$ 
  From lpoisse.produits@linkES
  Where ref_produit = :New.ref_produit;
  
  EXCEPTION
      WHEN NO_DATA_FOUND THEN
        Raise_application_error(-20001, 'Le produit n''existe pas');
END;
/

-- stock_am -> produits
CREATE OR REPLACE TRIGGER FKSTOCKPRODUITS 
BEFORE INSERT OR UPDATE ON stock_am 
FOR EACH ROW
DECLARE

  refprod$ stock_am.ref_produit%TYPE;
  
BEGIN
  Select ref_produit into refprod$ 
  From lpoisse.produits@linkES
  Where ref_produit = :New.ref_produit;
  
  EXCEPTION
      WHEN NO_DATA_FOUND THEN
        Raise_application_error(-20001, 'Le produit n''existe pas');
END;
/