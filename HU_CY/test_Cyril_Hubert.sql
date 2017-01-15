/*
  Test contraintes en local
 */
-- quelques tests pour vérifier les contraintes sur les bases locales
insert into CLIENTSEN values ('ALFKI',	'Alfreds Futterkiste','Obere Str. 57	','Berlin'	,'12209'	,'Allemagne'	,'030-0074321'	,'030-0076545');
-- déjà présent:  violation de contrainte unique

insert into COMMANDESOI values(1051,null,3 ,NULL ,null,null);
-- impossible d'insérer null

insert INTO COMMANDESEN values(1051,'clclo',3 ,sysdate ,sysdate,279);
--  pas de client référencé avec ce nom: violation de contrainte d'intégrité (clé étrangère sur code_clients)

insert into DETAILS_COMMANDESEN values(850	,54	,37.25,	20	,0);
-- pas de commande avec ce numéro: violation de contrainte de clé étrangère

insert into STOCKEN values ('62','Allemagne',null,'17','0');
-- clé primaire déjà utilisé:  violation de contrainte unique

UPDATE STOCKEN set REF_PRODUIT=58 where PAYS='Allemagne' and REF_PRODUIT='100'; --maj correcte


/*
  Contraintes de clés étrangères sur les autres bases
 */
insert into COMMANDESEN values(105,'VAFFE',	15,sysdate,sysdate,555);
-- no_employe invalide: signalé via trigger
insert into DETAILS_COMMANDESEN values(101,	1555,	37.25,	20,	0);
-- no_produit invalide: signalé via trigger
insert into STOCKEN VALUES (1000,	'Allemagne',17,null,		0);
-- no_produit invalide: signalé via trigger
DELETE  from FOURNISSEURS where NO_FOURNISSEUR=11;
-- fournisseurs référencé dans produits, impossible à supprimer: signalé via trigger

/*
  Gestion des IMD sur les vues
 */
--test sur la vue stock
SELECT REF_PRODUIT,count(*)
  FROM STOCK NATURAL JOIN PRODUITS
GROUP BY REF_PRODUIT;
insert into STOCK VALUES (2,'Croatie',17,40,0);
SELECT * FROM lpoisse.stockes@LinkToDBES where pays='Croatie';
update STOCK SET UNITES_COMMANDEES=50 where pays='Croatie';
DELETE FROM STOCK where pays='Croatie';

insert into STOCK VALUES (2,'Pays-Bas',17,40,0);
SELECT * FROM STOCKEN where pays='Pays-Bas';
update STOCK SET UNITES_COMMANDEES=50 where pays='Pays-Bas';
DELETE FROM STOCK where pays='Pays-Bas';


insert into STOCK VALUES (2,'Chili',17,40,0);
SELECT * FROM hcburca.stock_am@LinkToDBUS where pays='Chili';
update STOCK SET INDISPONIBLE=-1 where pays='Chili' and REF_PRODUIT=2; -- impossible de maj: étrange...
DELETE FROM STOCK where pays='Chili' and REF_PRODUIT=2; --impossible de supprimer... manque de permission

insert into STOCK VALUES (2,'Russie',17,40,0);
SELECT * FROM STOCKOI where pays='Russie';
update STOCK SET UNITES_COMMANDEES=50 where pays='Russie';
DELETE FROM STOCK where pays='Russie';

update STOCK SET pays='Chine' WHERE PAYS='Russie'; -- pas autorisé à changer le pays

--tests sur la vue 'Clients'
SELECT * from CLIENTS;
SELECT * from CLIENTS NATURAL join COMMANDES;

insert into CLIENTS values('CHO','Chop-suey', 'Chinese','Hauptstr. 29	Bern','	3012','Bulgarie',	'0452-076545	',NULL );
SELECT * from  lpoisse.ClientsES@LinkToDBES where pays='Bulgarie';
update CLIENTS SET pays='France' where pays='Bulgarie'; -- pas autorisé à changer le pays
update CLIENTS SET CODE_POSTAL=3568 where CODE_CLIENT='CHO'; -- update réussi
SELECT * FROM CLIENTS where CODE_CLIENT='CHO'; --1 tuple

insert into CLIENTS values('CHO','Chop-suey', 'Chinese','Hauptstr. 29	Bern','	3012','Norvege',	'0452-076545	',NULL );
SELECT * from  CLIENTSEN where pays='Norvege';
update CLIENTS SET CODE_CLIENT='CHO' where pays='Norvege'; -- violation de PK car 2 tuples selectionnés, clé primaire identiques mais sur 2 sites différents
update CLIENTS SET CODE_POSTAL=3568 where CODE_CLIENT='CHO'; -- update réussi
SELECT * FROM CLIENTS where CODE_CLIENT='CHO'; --2 tuples

insert into CLIENTS values('CHO','Chop-suey', 'Chinese','Hauptstr. 29	Bern','	3012','Russie',	'0452-076545	',NULL );
SELECT * from  CLIENTSOI where pays='Russie';
update CLIENTS SET CODE_POSTAL=3568 where CODE_CLIENT='CHO'; -- update réussi
SELECT * FROM CLIENTS where CODE_CLIENT='CHO'; -- 3 tuples avec la même PK dans 3 sites différents

DELETE  from CLIENTS where CODE_CLIENT='CHO';
COMMIT ;

insert into CLIENTS values('CHO1','Chop-suey', 'Chinese','Hauptstr. 29	Bern','	3012','Chili',	'0452-076545	',NULL );
SELECT * from  hcburca.clients_am@LinkToDBUS where pays='Chili';
update CLIENTS SET CODE_POSTAL=3568 where CODE_CLIENT='CHO1'; -- update réussi
SELECT * FROM CLIENTS where CODE_CLIENT='CHO1'; -- 1 tuples

-- tests sur la vue 'Commandes'
select c.NO_EMPLOYE, count(*)
  FROM COMMANDES c,EMPLOYES e
    where c.NO_EMPLOYE=e.NO_EMPLOYE
  GROUP BY c.NO_EMPLOYE;

select cl.CODE_CLIENT, count(*)
  from CLIENTS cl, COMMANDES c
  where c.CODE_CLIENT=cl.CODE_CLIENT
  group by cl.CODE_CLIENT;

insert into CLIENTS values('CHO','Chop-suey', 'Chinese','Hauptstr. 29	Bern','	3012','Russie',	'0452-076545	',NULL ); --ok dans OI
insert into COMMANDES values(5415,'CHO',1,sysdate,sysdate,469); --ok dans OI
SELECT * from COMMANDESOI where NO_COMMANDE=5415;
delete from COMMANDES where NO_COMMANDE=5415; --ok
delete from CLIENTS where CODE_CLIENT='CHO';--ok

insert INTO COMMANDES values(1051,'clclo',3 ,sysdate ,sysdate,279); -- client inconnu
insert INTO COMMANDES values(901,'ALFKI',3 ,sysdate ,sysdate,279);
select * from COMMANDESEN where NO_COMMANDE=901; --placé dans commandesEN, en accord avec le pays du client
update COMMANDES set CODE_CLIENT='FURIB' where NO_COMMANDE=901; -- pas autorisé à changer le code_client
delete FROM  COMMANDES where NO_COMMANDE='901';

-- tests sur la vue 'Details_Commandes'
select *
  from   DETAILS_COMMANDES NATURAL join COMMANDES ;

select NO_COMMANDE from COMMANDES MINUS SELECT DISTINCT NO_COMMANDE from DETAILS_COMMANDES; --commande sans détails

insert into DETAILS_COMMANDES values(5000,70,75,14,0.1);
select * from DETAILS_COMMANDES where NO_COMMANDE=6000;
update DETAILS_COMMANDES set no_commande=6000 where NO_COMMANDE=5000 AND REF_PRODUIT=70; -- ne peut pas changer le numéro de commande
update DETAILS_COMMANDES set no_commande=9000 where NO_COMMANDE=5000 AND REF_PRODUIT=70; --numéro de commande inconnu

-- tests sur la vue Employes
insert into EMPLOYES values (15,5,'Suyama','Michael','ReprÈsentant(e)',	'M.',	sysdate,	sysdate,2534,	600); -- ok
UPDATE EMPLOYES SET  REND_COMPTE=55 WHERE NO_EMPLOYE=15; --  violation de FK : 55 pas employé
DELETE FROM EMPLOYES WHERE NO_EMPLOYE=12;
SELECT * from EMPLOYES WHERE NO_EMPLOYE=12;

-- tests sur la vue Produits
insert into PRODUITS values (101,'Ikura',4,11,'12 pots (200 g)',155); -- violation de FK pas de catégorie
insert into PRODUITS values (100,'Ikura',4,8,'12 pots (200 g)',155); --insertion ok
update PRODUITS set NO_FOURNISSEUR=35 where REF_PRODUIT=100; --fournisseur inexistant
delete from PRODUITS where REF_PRODUIT=100;

SELECT f.NO_FOURNISSEUR, count(*)
  from FOURNISSEURS f, PRODUITS p
where f.NO_FOURNISSEUR=p.NO_FOURNISSEUR
GROUP BY f.NO_FOURNISSEUR;

SELECT c.CODE_CATEGORIE,count(*)
  from CATEGORIES c, PRODUITS p
where c.CODE_CATEGORIE=p.CODE_CATEGORIE
GROUP BY c.CODE_CATEGORIE;

-- test sur la vue 'Categorie'
insert into CATEGORIES values(9,'Poissons et fruits de mer','Poissons, fruits de mer, escargots'); --insertion ok
SELECT * from CATEGORIES;
update CATEGORIES set NOM_CATEGORIE='Céréales' where CODE_CATEGORIE=9; --ok
DELETE from CATEGORIES where CODE_CATEGORIE=7; --violation contrainte  catégories référencée ailleurs
DELETE from CATEGORIES where CODE_CATEGORIE=9;





