-- toutes les droits pour autres sites pour la table stock

GRANT select, update, insert, delete on stock_am to lpoisse; 
GRANT select, update, insert, delete on stock_am to zvergne;
Grant select, update, insert, delete on stock_am to hhamelin;
Grant select, update, insert, delete on stock_am to cpottiez;

-- droits lectures autres sites pour la table employes

GRANT select, update, insert, delete on employes to lpoisse; 
GRANT select, update, insert, delete on employes to zvergne;
Grant select, update, insert, delete on employes to hhamelin;
Grant select, update, insert on employes to cpottiez;

-- droits lectures autres sites pour la table clients_am

GRANT select, update, insert, delete on clients_am to lpoisse; 
GRANT select, update, insert, delete on clients_am to zvergne;
Grant select, update, insert, delete on clients_am to hhamelin;
Grant select, update, insert, delete on clients_am to cpottiez;

-- droits lectures autres sites pour la table commandes_am

GRANT select, update, insert, delete on commandes_am to lpoisse; 
GRANT select, update, insert, delete on commandes_am to zvergne;
Grant select, update, insert, delete on commandes_am to hhamelin;
Grant select, update, insert, delete on commandes_am to cpottiez;

-- droits lectures autres sites pour la table details_commandes_am

GRANT select, update, insert, delete on details_commandes_am to lpoisse; 
GRANT select, update, insert, delete on details_commandes_am to zvergne;
Grant select, update, insert, delete on details_commandes_am to hhamelin;
Grant select, update, insert, delete on details_commandes_am to cpottiez;

COMMIT;