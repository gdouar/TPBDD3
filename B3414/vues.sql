CREATE OR REPLACE VIEW CLIENTS AS
  SELECT *
  FROM CLIENTS_AM where pays in ('Antigua-et-Barbuda', 'Argentine', 'Bahamas', 'Barbade', 'Belize', 'Bolivie', 'Bresil',
  'Canada', 'Chili', 'Colombie','Costa Rica', 'Cuba', 'Republique dominicaine', 'Dominique',
  'Equateur', 'Etats-Unis', 'Grenade', 'Guatemala', 'Guyana', 'Haiti','Honduras', 'Jamaique',
  'Mexique', 'Nicaragua', 'Panama', 'Paraguay', 'Perou', 'Saint-Christophe-et-Nieves', 'Sainte-Lucie',
  'Saint-Vincent-et-les Grenadines', 'Salvador', 'Suriname', 'Trinite-et-Tobago', 'Uruguay',
  'Venezuela')
  UNION ALL 
  SELECT * 
  FROM lpoisse.clientsES@linkES where PAYS in 
('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 
    'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 
    'Autriche', 'Suisse')
  UNION ALL 
  SELECT * 
  FROM cpottiez.clientsEN@tplink where pays in ('Suede', 'Norvege', 'Danemark', 'Finlande', 'Belgique', 'Irlande', 'Pologne', 'Royaume-Uni', 'Allemagne', 'Islande', 'Luxembourg', 'Pays-Bas')
  UNION ALL 
  SELECT *
  FROM cpottiez.clientsOI@tplink where pays not in ('Antigua-et-Barbuda', 'Argentine', 'Bahamas', 'Barbade', 'Belize', 'Bolivie', 'Bresil',
  'Canada', 'Chili', 'Colombie','Costa Rica', 'Cuba', 'Republique dominicaine', 'Dominique',
  'Equateur', 'Etats-Unis', 'Grenade', 'Guatemala', 'Guyana', 'Haiti','Honduras', 'Jamaique',
  'Mexique', 'Nicaragua', 'Panama', 'Paraguay', 'Perou', 'Saint-Christophe-et-Nieves', 'Sainte-Lucie',
  'Saint-Vincent-et-les Grenadines', 'Salvador', 'Suriname', 'Trinite-et-Tobago', 'Uruguay',
  'Venezuela') and pays not in ('Suede', 'Norvege', 'Danemark', 'Finlande', 'Belgique', 'Irlande', 'Pologne', 'Royaume-Uni', 'Allemagne', 'Islande', 'Luxembourg', 'Pays-Bas')
  and pays not in ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 
    'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 
    'Autriche', 'Suisse');
  
CREATE OR REPLACE VIEW COMMANDES AS
  SELECT *
  FROM COMMANDES_AM
  UNION ALL 
  SELECT * 
  FROM lpoisse.COMMANDESES@linkES
  UNION ALL 
  SELECT * 
  FROM cpottiez.COMMANDESEN@tplink 
  UNION ALL 
  SELECT *
  FROM cpottiez.COMMANDESOI@tplink ;
  
CREATE OR REPLACE VIEW DETAILS_COMMANDES AS
  SELECT *
  FROM Details_COMMANDES_AM
  UNION ALL 
  SELECT * 
  FROM lpoisse.Details_COMMANDESES@linkES
  UNION ALL 
  SELECT * 
  FROM cpottiez.Details_COMMANDESEN@tplink
  UNION ALL 
  SELECT *
  FROM cpottiez.Details_COMMANDESOI@tplink;
  
CREATE OR REPLACE VIEW STOCK AS 
   SELECT *
   FROM stock_AM where pays in ('Antigua-et-Barbuda', 'Argentine', 'Bahamas', 'Barbade', 'Belize', 'Bolivie', 'Bresil',
  'Canada', 'Chili', 'Colombie','Costa Rica', 'Cuba', 'Republique dominicaine', 'Dominique',
  'Equateur', 'Etats-Unis', 'Grenade', 'Guatemala', 'Guyana', 'Haiti','Honduras', 'Jamaique',
  'Mexique', 'Nicaragua', 'Panama', 'Paraguay', 'Perou', 'Saint-Christophe-et-Nieves', 'Sainte-Lucie',
  'Saint-Vincent-et-les Grenadines', 'Salvador', 'Suriname', 'Trinite-et-Tobago', 'Uruguay',
  'Venezuela')
   UNION ALL 
   SELECT * 
   FROM lpoisse.stockES@linkES where PAYS in 
('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 
    'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 
    'Autriche', 'Suisse')
   UNION ALL 
   SELECT * 
   FROM cpottiez.stockEN@tplink where pays in ('Suede', 'Norvege', 'Danemark', 'Finlande', 'Belgique', 'Irlande', 'Pologne', 'Royaume-Uni', 'Allemagne', 'Islande', 'Luxembourg', 'Pays-Bas')
   UNION ALL 
   SELECT *
   FROM cpottiez.stockOI@tplink where pays not in ('Antigua-et-Barbuda', 'Argentine', 'Bahamas', 'Barbade', 'Belize', 'Bolivie', 'Bresil',
  'Canada', 'Chili', 'Colombie','Costa Rica', 'Cuba', 'Republique dominicaine', 'Dominique',
  'Equateur', 'Etats-Unis', 'Grenade', 'Guatemala', 'Guyana', 'Haiti','Honduras', 'Jamaique',
  'Mexique', 'Nicaragua', 'Panama', 'Paraguay', 'Perou', 'Saint-Christophe-et-Nieves', 'Sainte-Lucie',
  'Saint-Vincent-et-les Grenadines', 'Salvador', 'Suriname', 'Trinite-et-Tobago', 'Uruguay',
  'Venezuela') and pays not in ('Suede', 'Norvege', 'Danemark', 'Finlande', 'Belgique', 'Irlande', 'Pologne', 'Royaume-Uni', 'Allemagne', 'Islande', 'Luxembourg', 'Pays-Bas')
  and pays not in ('Espagne', 'Portugal', 'Andorre', 'France', 'Gibraltar', 'Italie', 'Saint-Marin', 'Vatican', 
    'Malte', 'Albanie', 'Bosnie-Herzegovine', 'Croatie', 'Grece', 'Macedoine', 'Montenegro', 'Serbie', 'Slovenie', 'Bulgarie', 
    'Autriche', 'Suisse');
    
-- Vue 'Produits'
CREATE OR REPLACE VIEW PRODUITS
AS
  (SELECT *
   FROM lpoisse.produits@LinkES
  );
  
-- Vue 'Fournisseurs'
CREATE OR REPLACE VIEW FOURNISSEURS
AS
  (SELECT *
   FROM cpottiez.fournisseurs@tplink
   );