
-- requ�te sur stock

-- on prend tout sans s�lection
select * from stock;
/*
  r�sultat: 231 tuples en 0.0143 secondes
  le plan d'ex�cution montre que la vue est faite d'une union entre toutes les tables avec les pr�dicats de filtre par d�faut
  d�finis dans la vue. Sur les tables remote, il n'y a pas de s�lection.
  On fait la s�lection apr�s la mise en place de la vue.
  Le co�t est de 13.
 */

-- on fait des s�lections sur les pays
SELECT * from STOCK where PAYS='Mexique';
/*
  O tuples en 0.016 secondes
  le plan d'ex�cution ne s�lectionne que la table 'STOCK_AM',
   puisque la combinaison des pr�dicats de filtre et du pr�dicat
  de la s�lection donne des filtres de type 'null is not null' sur les autres tables. Le Mexique est dans la liste des
  pays d'Am�rique mais pas dans les autres. Il est donc inutile de s'occuper des tables distantes.
  De plus, le plan d'ex�cution montre que l'index est utilis� pour la selection puisque le pays fait partie de la
   cl� primaire et que l'index permet d'acc�l�rer la s�lection.
   Le co�t est ici de 10.
 */

-- on prend un pays de chaque zone
SELECT * from STOCK where PAYS in('Suede','Mexique','France');
/*
  76 tuples en 0.033 secondes
  Le plan d'ex�cution montre que la table 'STOCK_AM' est filtr� avec  un pr�dicat pays=Mexique et une utilisation de l'index.
  Les tables remotes sont elle aussi utilis�es sans filtre pr�alable.
  Le co�t est de 10.
 */


select * from lpoisse.stockes@linkES;
/*
  76 tuples en 0.013 secondes
  on s�lectionne la table dans son int�gralit�
 */

select * from lpoisse.stockes@linkES where pays='France';
/*
  76 tuples en 0.012 secondes
  on utilise l'index sur la cl� primaire pour la s�lection
 */

/*
  Si on souhaite utiliser des pr�dicats pr�difinies. Il faudrait d�finir des vues avec des pr�dicats pour chaque
  fragment.
*/

select * from CLIENTS NATURAL JOIN  COMMANDES;
/*
  833 tuples en 0.115 secondes
  aucune s�lection
 */

select count(*) from CLIENTS NATURAL JOIN  COMMANDES where pays='Espagne';
/*
  25 tuples en  0.461 secondes
  on tire profit de l'utilisation des pr�dicats sur la vue clients.
 */

/*
  Globalement, les pr�dicats d�finis au niveau de la vue servent � �liminer des acc�s aux tables.
  Si la combinaison des pr�dicats d�finis et des pr�dicats de s�lection pour une table donne 'null is not null', on n'a donc
  nullement besoin d'acc�der � la table en question.
  Sinon, il y a deux cas. Si la table est en local, l'expression est simplifi� et normalis� pour la s�lection. Par contre,
  si la table est distante, tous les tubles sont r�cup�r�s.
  A noter par ailleurs que les pr�dicats sur la table STOCKOI ne semblent pas se comporter comme ceux sur les autres tables.
  En effet, d�s qu'il y a plus d'un pr�dicat simple sur cette table, l'optimiseur ne fait plus la combinaison logique des
  pr�dicats alors qu'il pourrait donner des 'null is not null'.
 */