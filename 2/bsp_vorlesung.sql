CREATE TYPE MitarbeiterTyp as Object(name VARCHAR2(100)) NOT FINAL;
CREATE TYPE AngestellterTyp under MitarbeiterTyp(vertragsDt VARCHAR2(8));
CREATE TYPE TelefonTyp as TABLE OF VARCHAR2(30);
CREATE TYPE ManagerTyp under MitarbeiterTyp(gehalt INT, telNr TelefonTyp);
CREATE TYPE AngestelltenlisteTyp as TABLE OF REF AngestellterTyp;
CREATE TYPE ProjektTyp as Object(name VARCHAR2(100), wird_geleitet REF ManagerTyp, teilnehmer AngestelltenlisteTyp);

CREATE TABLE Angestellter OF AngestellterTyp;
CREATE TABLE ManagerTbl OF ManagerTyp NESTED TABLE TelNr STORE AS foobar;
CREATE TABLE Projekt OF ProjektTyp NESTED TABLE teilnehmer STORE AS blub;

INSERT INTO Angestellter VALUES(AngestellterTyp('Mueller', '1-9-2005'));
INSERT INTO Angestellter VALUES(AngestellterTyp('Schmitt', '1-1-1999'));
INSERT INTO ManagerTbl VALUES(ManagerTyp('Schweizer', 60000, TelefonTyp('089 123', '089 456')));

INSERT INTO Projekt VALUES(ProjektTyp('p7', (SELECT REF(m) FROM ManagerTbl m WHERE name='Schweizer'), AngestelltenlisteTyp()));
INSERT INTO TABLE(SELECT teilnehmer FROM Projekt WHERE name='p7') (SELECT REF(a) FROM Angestellter a WHERE a.name='Mueller' OR a.name='Schmitt');

SELECT * FROM Angestellter;
SELECT value(w) FROM Angestellter w;
SELECT p.name, DEREF(p.wird_geleitet) FROM Projekt p;
SELECT p.name, DEREF(p.wird_geleitet).name FROM Projekt p;
SELECT p.name, DEREF(a.COLUMN_VALUE) FROM Projekt p, TABLE(p.teilnehmer)a;
SELECT p.name, DEREF(a.COLUMN_VALUE).name FROM Projekt p, TABLE(p.teilnehmer)a;