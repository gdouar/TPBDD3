-- test insert on commande
INSERT INTO COMMANDES VALUES (7000, '12345', 3, CURRENT_DATE, null, null);  -- ES
INSERT INTO COMMANDES VALUES (5000, 'FOLKO', 3, CURRENT_DATE, null, null);  -- EN
INSERT INTO COMMANDES VALUES (6666, 'PICCO', 3, CURRENT_DATE, null, null);  -- OI
COMMIT;

-- test update on commandes
UPDATE COmmandes SET date_envoi = CURRENT_DATE WHERE code_client = '12345'; -- ES
UPDATE COmmandes SET date_envoi = CURRENT_DATE WHERE code_client = 'FOLKO'; -- EN
UPDATE COmmandes SET date_envoi = CURRENT_DATE WHERE code_client = 'PICCO'; -- OI
COMMIT;

-- test delete on commandes
DELETE FROM Commandes WHERE code_client = '12345';  -- ES
DELETE FROM Commandes WHERE code_client = 'FOLKO';  -- EN
DELETE FROM Commandes WHERE code_client = 'PICCO';  -- OI
COMMIT;

-- test insert on clients 
INSERT INTO CLIENTS VALUES ('haha', 'DARK side', 'death star', 'far far away', 666, 'Espagne', 'here''s my number', 'call me maybe'); -- ES
INSERT INTO CLIENTS VALUES ('hihi', 'cold', 'st. cold, 31', 'Coldington', '-300', 'Suede', '000', '111'); -- EN
INSERT INTO CLIENTS VALUES ('un', 'bla', 'blabla', 'Blablatown', '666', 'Autriche', '000', '111');  -- OI
COMMIT;

-- test update on clients
UPDATE CLIENTS SET code_postal = 'new666' WHERE code_client = 'haha'; -- ES
UPDATE CLIENTS SET code_postal = 'new-300' WHERE code_client = 'hihi';  -- EN 
UPDATE CLIENTS SET code_postal = 'new' WHERE code_client = 'un';  -- OI
COMMIT;

-- test delete on clients
DELETE FROM CLIENTS WHERE code_client = 'haha'; -- ES
DELETE FROM CLIENTS WHERE code_client = 'hihi'; -- EN 
DELETE FROM CLIENTS WHERE code_client = 'un'; -- OI
COMMIT;