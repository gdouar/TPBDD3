-- quel est le fournisseur de produits le plus employé en Amérique avec la vue matérialisée
SELECT f.NO_FOURNISSEUR , count(*)
FROM MV_PRODUITS m, DETAILS_COMMANDES_AM d, MV_FOURNISSEURS f
WHERE m.REF_PRODUIT = d.REF_PRODUIT and m.NO_FOURNISSEUR=f.NO_FOURNISSEUR
GROUP BY f.NO_FOURNISSEUR
HAVING count(*) =
       (SELECT max(count(*))
        FROM MV_PRODUITS m, DETAILS_COMMANDES_AM d, MV_FOURNISSEURS f
        WHERE m.REF_PRODUIT = d.REF_PRODUIT and m.NO_FOURNISSEUR=f.NO_FOURNISSEUR
        GROUP BY f.NO_FOURNISSEUR);
/*
 un tuple en 0.012 secondes
 On remarque qu'il consulte la vue matérialisée qui subit un full scan sur la primary key et la jointure qui subit sélection avec des access predicates et des filter predicates toujours avec un full scan sur la primary key.
 Le coup est de 5.
 */

-- quel est le fournisseur de produits le plus employé en Amériqye sans la vue matérialisée
SELECT f.NO_FOURNISSEUR, count(*)
FROM PRODUITS m, DETAILS_COMMANDES_AM d, FOURNISSEURS f
WHERE m.REF_PRODUIT = d.REF_PRODUIT and m.NO_FOURNISSEUR=f.NO_FOURNISSEUR
GROUP BY f.NO_FOURNISSEUR
HAVING count(*) =
       (SELECT max(count(*))
        FROM PRODUITS m, DETAILS_COMMANDES_AM d, FOURNISSEURS f
        WHERE m.REF_PRODUIT = d.REF_PRODUIT and m.NO_FOURNISSEUR=f.NO_FOURNISSEUR
        GROUP BY f.NO_FOURNISSEUR);

/*
un tuple en 0.149, soit environ 14 fois plus de temps qu'avec la materialized view
On remarque qu'ici des nested loops apparaissent en bas des arbres et que ce ne sont plus des merge join mais des hash join.
Le coût est de 6.
 */



-- connaître le nombre de produits du site Amérique avec la vue matérialisée
SELECT count(*) from COMMANDES_AM c NATURAL JOIN MV_PRODUITS m;
/*
        1 tuple en 0.003 secondes
        Encore une fois on effectue un merge join avec des full scan sur les clés primaires
        Le coût est de 24.
 */

-- connaître le nombre de produits du site Amérique sans la vue matérialisée
SELECT count(*) from COMMANDES_AM c NATURAL JOIN Produits p;
/*
        1 tuple en 0.015 secondes soit environ 5 fois plus de temps qu'avec la materialized view
        Ici ça va être très similaire à l'arbre de la requete précédente sauf que l'on va consulter toute la table produits
        Le coût est de 24.
 */

/*
  On constate un net gain de temps pour l'obtention du même résultat en utilisant
  les vues matérialisées.
 */