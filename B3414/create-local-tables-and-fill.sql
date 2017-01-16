CREATE table Clients_AM as (
  Select * from Ryori.Clients@tplink
  where Pays in ('Antigua-et-Barbuda', 'Argentine', 'Bahamas', 'Barbade', 'Belize', 'Bolivie', 'Bresil',
  'Canada', 'Chili', 'Colombie','Costa Rica', 'Cuba', 'Republique dominicaine', 'Dominique',
  'Equateur', 'Etats-Unis', 'Grenade', 'Guatemala', 'Guyana', 'Haiti','Honduras', 'Jamaique',
  'Mexique', 'Nicaragua', 'Panama', 'Paraguay', 'Perou', 'Saint-Christophe-et-Nieves', 'Sainte-Lucie',
  'Saint-Vincent-et-les Grenadines', 'Salvador', 'Suriname', 'Trinite-et-Tobago', 'Uruguay',
  'Venezuela')
);


CREATE TABLE Employes as (
  Select * from Ryori.Employes@tplink
);


CREATE table Commandes_AM as(
  Select com.* from Ryori.Commandes@tplink com, Ryori.Clients@tplink cli 
  where com.code_client = cli.code_client and cli.pays in ('Antigua-et-Barbuda', 'Argentine', 'Bahamas', 'Barbade', 'Belize', 'Bolivie', 'Bresil',
  'Canada', 'Chili', 'Colombie','Costa Rica', 'Cuba', 'Republique dominicaine', 'Dominique',
  'Equateur', 'Etats-Unis', 'Grenade', 'Guatemala', 'Guyana', 'Haiti','Honduras', 'Jamaique',
  'Mexique', 'Nicaragua', 'Panama', 'Paraguay', 'Perou', 'Saint-Christophe-et-Nieves', 'Sainte-Lucie',
  'Saint-Vincent-et-les Grenadines', 'Salvador', 'Suriname', 'Trinite-et-Tobago', 'Uruguay',
  'Venezuela')
);

CREATE table Details_Commandes_AM as(
  Select detcom.* from Ryori.Details_Commandes@tplink detcom, Commandes_AM com 
  where detcom.no_commande = com.no_commande
);

CREATE table Stock_AM as(
  Select * from Ryori.Stock@tplink
  where Pays in ('Antigua-et-Barbuda', 'Argentine', 'Bahamas', 'Barbade', 'Belize', 'Bolivie', 'Bresil',
  'Canada', 'Chili', 'Colombie','Costa Rica', 'Cuba', 'Republique dominicaine', 'Dominique',
  'Equateur', 'Etats-Unis', 'Grenade', 'Guatemala', 'Guyana', 'Haiti','Honduras', 'Jamaique',
  'Mexique', 'Nicaragua', 'Panama', 'Paraguay', 'Perou', 'Saint-Christophe-et-Nieves', 'Sainte-Lucie',
  'Saint-Vincent-et-les Grenadines', 'Salvador', 'Suriname', 'Trinite-et-Tobago', 'Uruguay',
  'Venezuela')
);