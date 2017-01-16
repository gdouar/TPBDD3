-- Création materialized view pour Produits tout les jours
CREATE MATERIALIZED VIEW MV_PRODUITS 
  REFRESH COMPLETE
  NEXT SYSDATE +1
  AS 
    SELECT * 
    FROM LPOISSE.PRODUITS@LINKES;

-- Le produit le plus commandé en Amérique
SELECT d.REF_PRODUIT,count(*)
FROM MV_PRODUITS p, DETAILS_COMMANDES_AM d
WHERE p.REF_PRODUIT = d.REF_PRODUIT
GROUP BY d.REF_PRODUIT
HAVING count(*) =
       (SELECT max(count(*))
        FROM MV_PRODUITS p, DETAILS_COMMANDES_AM d
        WHERE p.REF_PRODUIT = d.REF_PRODUIT
        GROUP BY d.REF_PRODUIT);
        
-- consulter les informations d'un produit d'Amerique
SELECT *
 FROM MV_PRODUITS where REF_PRODUIT=2;-- ok

-- Création materialized view pour categories toutes les semaines
CREATE MATERIALIZED VIEW MV_CATEGORIES
  REFRESH FAST
  NEXT SYSDATE + 7
  AS
  SELECT *
    from lpoisse.categories@LinkES;

-- Création materialized view pour Fournisseurs toutes les semaines
CREATE MATERIALIZED VIEW MV_FOURNISSEURS
  REFRESH FAST
  NEXT SYSDATE + 7
  AS
  SELECT *
    from cpottiez.FOURNISSEURS@tplink; 
    
DROP MATERIALIZED VIEW MV_FOURNISSEURS;
DROP MATERIALIZED VIEW MV_PRODUITS;
    
-- Connaître les informations des fournisseurs du site AM
SELECT * from COMMANDES_AM c NATURAL JOIN MV_FOURNISSEURS f;

-- log for employes and grant access to log in order to enable other sites to make a refresh fast
CREATE MATERIALIZED VIEW LOG ON EMPLOYES;

GRANT SELECT ON MLOG$_EMPLOYES TO lpoisse;
GRANT SELECT ON MLOG$_EMPLOYES TO zvergne;
GRANT SELECT ON MLOG$_EMPLOYES TO jcharlesni;
GRANT SELECT ON MLOG$_EMPLOYES TO cpottiez;
GRANT SELECT ON MLOG$_EMPLOYES TO hhamelin;