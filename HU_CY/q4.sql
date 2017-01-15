--création materialized view pour employes toutes les semaines
CREATE MATERIALIZED VIEW MW_Employes
  REFRESH FAST
  NEXT sysdate + 7 -- tous les 7 jours
  as
  SELECT *
  FROM hcburca.employes@LinkToDBUS;

-- consulter le salaire d'un employé d'europe du nord
SELECT *
 FROM MW_Employes where PRENOM='Nancy';-- ok

-- connaître les informations des employés du site EN
SELECT * from COMMANDESEN c NATURAL JOIN MW_Employes e;


--création materialized view pour produits tous les jours
CREATE MATERIALIZED VIEW MW_PRODUITS
  REFRESH COMPLETE
  NEXT sysdate + 1
  AS
  SELECT * FROM lpoisse.produits@LinkToDBES;


-- le produit le plus commandé en europe du nord
SELECT d.REF_PRODUIT,count(*)
FROM MW_PRODUITS m, DETAILS_COMMANDESEN d
WHERE m.REF_PRODUIT = d.REF_PRODUIT
GROUP BY d.REF_PRODUIT
HAVING count(*) =
       (SELECT max(count(*))
        FROM MW_PRODUITS m, DETAILS_COMMANDESEN d
        WHERE m.REF_PRODUIT = d.REF_PRODUIT
        GROUP BY d.REF_PRODUIT);

--création materialized view pour categories toutes les semaines
CREATE MATERIALIZED VIEW MW_CATEGORIES
  REFRESH FAST
  NEXT SYSDATE + 7
  AS
  SELECT *
    from lpoisse.categories@LinkToDBES;

-- quelle est la categorie de produits la plus commandé en EN
SELECT c.CODE_CATEGORIE, count(*)
FROM MW_PRODUITS m, DETAILS_COMMANDESEN d, MW_CATEGORIES c
WHERE m.REF_PRODUIT = d.REF_PRODUIT and m.CODE_CATEGORIE=c.CODE_CATEGORIE
GROUP BY c.CODE_CATEGORIE
HAVING count(*) =
       (SELECT max(count(*))
        FROM MW_PRODUITS m, DETAILS_COMMANDESEN d, MW_CATEGORIES c
        WHERE m.REF_PRODUIT = d.REF_PRODUIT and m.CODE_CATEGORIE=c.CODE_CATEGORIE
        GROUP BY c.CODE_CATEGORIE);


-- log for founisseurs and grant access to log in order to enable other sites to make a refresh fast
CREATE MATERIALIZED VIEW LOG ON FOURNISSEURS;

GRANT SELECT ON MLOG$_FOURNISSEURS TO lpoisse;
GRANT SELECT ON MLOG$_FOURNISSEURS TO zvergne;
GRANT SELECT ON MLOG$_FOURNISSEURS TO hcburca;
GRANT SELECT ON MLOG$_FOURNISSEURS TO jcharlesni;
GRANT SELECT ON MLOG$_FOURNISSEURS TO hhamelin;


