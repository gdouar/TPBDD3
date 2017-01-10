--Vue EMPLOYES
CREATE OR REPLACE VIEW employes
AS
(SELECT * FROM hcburca.Employes@dbLinkUS
);
desc employes;

select * from stock;
desc stock;
select * from produits;
insert into stock 
values (1 , 'Mexique', 5 , 1 ,0);
-- Test stock
insert into stock values (2,'Portugal',54,1,0); 
update stock set unites_stock =null where pays='Portugal' and ref_produit=2;
delete from stock where pays='Portugal' and ref_produit=2;

insert into stock values (777, 'Portugal', 54, 1, 0); 
delete from stock where pays='Panama';
update stock set unites_stock=444 where pays='Panama';

--Test clients
desc clients;
insert into clients values ('12345', 'sqf', 'qztf', 'seoiuhrt', 'qhf', 'Panama', '0000000000', 'zoir'); --Ne fonctionne pas : Panama inconnu
insert into clients values ('12345', 'chech', 'qztf', 'seoiuhrt', 'qhf', 'France', '0000000000', 'zoir'); --Fonctionne : la France est en Europe du Sud
update clients set pays='Panama' where code_client='12345'; -- Ne fonctionne pas : Panama inconnu
update clients set pays='Espagne' where code_client='12345';  -- Fonctionne : espagne reconnue
delete from clients where pays='Panama'; -- Comme en centralisé, si aucun tuple n'est repéré, aucune erreur n'intervient.
                                          -- La requête n'efface aucune ligne ! (Ce comportement peut néanmoins avoir des effets de bord, cf rapport)


 -- Test commandes              
select * from commandes natural join clients;
desc commandes;
insert into commandes values ('123457','VINET',2,SYSDATE,SYSDATE,25); --Fonctionne : VINET fait partie de l'Eruope du Sud
insert into commandes values ('123457','OTTIK',2,SYSDATE,SYSDATE,25); --Ne fonctionne pas : OTTIK est allemand
insert into commandes values ('123457','ZIGGY',2,SYSDATE,SYSDATE,25); -- Ne fonctionne pas : ZIGGY est inconnu (peu importe le site)

update commandes set code_client='OTTIK' where NO_COMMANDE='123457'; -- Ne fonctionne pas : OTTIK est allemand
update commandes set code_client='ZIGGY' where NO_COMMANDE='123457'; -- Ne fonctionne pas : ZIGGY est inconnu (peu importe le site)

delete from commandes where NO_COMMANDE='123457';   --OK : la commande est liée à un client français (VINET)
delete from commandes where NO_COMMANDE='5555';         -- Comme en centralisé, si aucun tuple n'est repéré, aucune erreur n'intervient.                                                        -- La requête n'efface aucune ligne ! (Ce comportement peut néanmoins avoir des effets de bord, cf rapport)
delete from commandes where NO_COMMANDE='10508';    --KO:  la commande est liée à un client français (OTTIK)                          


--Test DetailsCommandes
desc details_commandes;
insert into details_commandes values (123457,2,54,1,1.2); --OK : la commande 123457 est rattachée au client français VINET
insert into details_commandes values (444,2,54,1,1.2); --KO : le client de la commande 444 est inconnu car la commande 444 n'existe pas
insert into details_commandes values (10279,2,54,1,1.2); --KO : le client de la commande 10279 (LEHMS) est allemand

update details_commandes set no_commande = 10279 where no_commande=123457;  --KO : le client de la commande 10279 est allemand
update details_commandes set quantite = 1 where no_commande=123457;  -- OK : le client de la commande 123457 est français
update details_commandes set no_commande = 122 where no_commande=123457; --KO : le client de la commande 122 est inconnu car la commande n'existe pas

delete from details_commandes where no_commande = 10279; --KO : le client de la commande 10279 est allemand
delete from details_commandes where no_commande = 123457; -- OK : le client de la commande 123457 est français 
delete from details_commandes where no_commande = 122;      -- OK mais ne supprime rien car la commande 122 est absente de la table
