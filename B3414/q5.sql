-- quel est le fournisseur de produits le plus employ� en Am�rique avec la vue mat�rialis�e
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
 On remarque qu'il consulte la vue mat�rialis�e qui subit un full scan sur la primary key et la jointure qui subit s�lection avec des access predicates et des filter predicates toujours avec un full scan sur la primary key.
 Le coup est de 5.
 */

-- quel est le fournisseur de produits le plus employ� en Am�riqye sans la vue mat�rialis�e
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
Le co�t est de 6.
 */



-- conna�tre le nombre de produits du site Am�rique avec la vue mat�rialis�e
SELECT count(*) from COMMANDES_AM c NATURAL JOIN MV_PRODUITS m;
/*
        1 tuple en 0.003 secondes
        Encore une fois on effectue un merge join avec des full scan sur les cl�s primaires
        Le co�t est de 24.
 */

-- conna�tre le nombre de produits du site Am�rique sans la vue mat�rialis�e
SELECT count(*) from COMMANDES_AM c NATURAL JOIN Produits p;
/*
        1 tuple en 0.015 secondes soit environ 5 fois plus de temps qu'avec la materialized view
        Ici �a va �tre tr�s similaire � l'arbre de la requete pr�c�dente sauf que l'on va consulter toute la table produits
        Le co�t est de 24.
 */

/*
  On constate un net gain de temps pour l'obtention du m�me r�sultat en utilisant
  les vues mat�rialis�es.
 */