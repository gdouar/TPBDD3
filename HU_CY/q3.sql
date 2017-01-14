/*
 requête sur stock
 */

-- on prend tout sans sélection
select * from stock;
/*
  le plan d'exécution montre que la vue est faite d'une union entre toutes les tables avec les prédicats de filtre par défaut
  définis dans la vue. Sur les tables remote, il n'y a pas de sélection.
  On fait la sélection après la mise en place de la vue.
  Le coût est de 12.
 */

-- on fait des sélections sur les pays
SELECT * from STOCK where PAYS='Suede';
/*
  le plan d'exécution ne sélectionne que la table 'STOCKEN' (avec une sélection pays=Suede),
   puisque la combinaison des prédicats de filtre et du prédicat
  de la sélection donne des filtres de type 'null is not null' sur les autres tables. La Suede est dans la liste des
  pays d'Europe du nord mais pas dans les autres. Il est donc inutile de s'occuper des tables distantes et de 'STOCKOI'.
  De plus, le plan d'exécution montre que l'index est utilisé pour la selection puisque le pays fait partie de la
   clé primaire et que l'index permet d'accélèrer la sélection.
   Le coût est ici de 4.
 */

-- on prend un pays de chaque zone
SELECT * from STOCK where PAYS in('Suede','Mexique','France');
/*
  Le plan d'exécution montre que la table 'STOCKEN' est filtré avec  un prédicat pays=Suede et une utilisation de l'index.
  La table 'STOCKOI' est elle aussi prise en compte avec la combinaison des prédicats déjà définis et les prédicats
  de sélection. Elle doit être scannée entièrement.
  Les tables remotes sont elle aussi utilisées sans filtre préalable.
  Le coût est de 9
 */


select * from lpoisse.stockes@LinkToDBES;
/*
  on sélectionne la table dans son intégralité
 */

select * from lpoisse.stockes@LinkToDBES where pays='France';
/*
  on utilise l'index sur la clé primaire pour la sélection
 */
