/*
 requête sur stock
 */

-- on prend tout sans sélection
select * from stock;
/*
  résultat: 237 tuples en 0.02 secondes
  le plan d'exécution montre que la vue est faite d'une union entre toutes les tables avec les prédicats de filtre par défaut
  définis dans la vue. Sur les tables remote, il n'y a pas de sélection.
  On fait la sélection après la mise en place de la vue.
  Le coût est de 12.
 */

-- on fait des sélections sur les pays
SELECT * from STOCK where PAYS='Suede';
/*
  O tuples en 0.013 secondes
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
  78 tuples en 0.017 secondes
  Le plan d'exécution montre que la table 'STOCKEN' est filtré avec  un prédicat pays=Suede et une utilisation de l'index.
  La table 'STOCKOI' est elle aussi prise en compte avec la combinaison des prédicats déjà définis et les prédicats
  de sélection. Elle doit être scannée entièrement.
  Les tables remotes sont elle aussi utilisées sans filtre préalable.
  Le coût est de 9
 */


select * from lpoisse.stockes@LinkToDBES;
/*
  77 tuples en 0.008 secondes
  on sélectionne la table dans son intégralité
 */

select * from lpoisse.stockes@LinkToDBES where pays='France';
/*
  76 tuples en 0.009 secondes
  on utilise l'index sur la clé primaire pour la sélection
 */

/*
  Si on souhaite utiliser des prédicats prédifinies. Il faudrait définir des vues avec des prédicats pour chaque
  fragment.
*/

select * from CLIENTS NATURAL JOIN  COMMANDES;
/*
  833 tuples en 0.609 secondes
  aucune sélection
 */

select count(*) from CLIENTS NATURAL JOIN  COMMANDES where pays='Espagne';
/*
  25 tuples en  0.024 secondes
  on tire profit de l'utilisation des prédicats sur la vue clients.
 */

/*
  Globalement, les prédicats définis au niveau de la vue servent à éliminer des accès aux tables.
  Si la combinaison des prédicats définis et des prédicats de sélection pour une table donne 'null is not null', on n'a donc
  nullement besoin d'accéder à la table en question.
  Sinon, il y a deux cas. Si la table est en local, l'expression est simplifié et normalisé pour la sélection. Par contre,
  si la table est distante, tous les tubles sont récupérés.

  A noter par ailleurs que les prédicats sur la table STOCKOI ne semblent pas se comporter comme ceux sur les autres tables.
  En effet, dès qu'il y a plus d'un prédicat simple sur cette table, l'optimiseur ne fait plus la combinaison logique des
  prédicats alors qu'il pourrait donner des 'null is not null'.
 */
