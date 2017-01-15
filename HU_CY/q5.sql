-- quelle est la categorie de produits la plus commandée en EN avec la vue matérialisée
SELECT c.CODE_CATEGORIE, count(*)
FROM MW_PRODUITS m, DETAILS_COMMANDESEN d, MW_CATEGORIES c
WHERE m.REF_PRODUIT = d.REF_PRODUIT and m.CODE_CATEGORIE=c.CODE_CATEGORIE
GROUP BY c.CODE_CATEGORIE
HAVING count(*) =
       (SELECT max(count(*))
        FROM MW_PRODUITS m, DETAILS_COMMANDESEN d, MW_CATEGORIES c
        WHERE m.REF_PRODUIT = d.REF_PRODUIT and m.CODE_CATEGORIE=c.CODE_CATEGORIE
        GROUP BY c.CODE_CATEGORIE);
/*
 un tuple en 0.007 seconde
 */

-- quelle est la categorie de produits la plus commandée en EN sans la vue matérialisée
SELECT c.CODE_CATEGORIE, count(*)
FROM PRODUITS m, DETAILS_COMMANDESEN d, CATEGORIES c
WHERE m.REF_PRODUIT = d.REF_PRODUIT and m.CODE_CATEGORIE=c.CODE_CATEGORIE
GROUP BY c.CODE_CATEGORIE
HAVING count(*) =
       (SELECT max(count(*))
        FROM PRODUITS m, DETAILS_COMMANDESEN d, CATEGORIES c
        WHERE m.REF_PRODUIT = d.REF_PRODUIT and m.CODE_CATEGORIE=c.CODE_CATEGORIE
        GROUP BY c.CODE_CATEGORIE);

/*
un tuple en 0.055, soit environ 8 fois plus de temps qu'avec la materialized view
 */



-- connaître le nombre d'employés du site EN avec la vue matérialisée
SELECT count(*) from COMMANDESEN c NATURAL JOIN MW_Employes e;
/*
        1 tuple en 0.008 seconde
 */

-- connaître le nombre d'employés du site EN sans la vue matérialisée
SELECT count(*) from COMMANDESEN c NATURAL JOIN Employes e;
/*
        1 tuple en 0.185 secondes soit environ 23 fois plus de temps qu'avec la materialized view
 */

/*
  On constate un net gain de temps pour l'obtention du même résultat en utilisant
  les vues matérialisées.
 */
