**free

dcl-f Person    disk usage(*input) rename(Person : PersonR) infds(Persinfo);
dcl-f Persaw    disk usage(*input : *output) rename(Persaw : PersawR);

dcl-ds Persinfo   qualified;
  RRN             int(10) pos(397);
end-ds;

dcl-ds Strucktur  qualified dim(4);
  links           char(40);
  rechts          char(40);
end-ds;

dcl-ds i_Person   likerec(PERSONR : *input) inz;
dcl-ds i_Persaw   likerec(PERSAWR : *input) inz;
dcl-ds o_Persaw   likerec(PERSAWR : *output) inz;

dcl-s X           int(10);

// Tricky Part mit SEQNBR kommt hier hin
// SEQNBR soll pro Programmdurchlauf um 1 erhöht werden
// Mit SETGT *hival positioniere den Zeiger hinter die letzte Zeile
// Mit READP lese ich von DIESER Stelle rückwärts EINE Zeile nach oben


o_Persaw.SEQNBR = 1;
SETGT *hival PERSAWR;
READP PERSAWR i_Persaw;

// Wenn nicht am ENDE vom File: o_Persaw.SEQNBR = i_Persaw.SEQNBR + 1
IF NOT %eof;
  o_Persaw.SEQNBR = i_Persaw.SEQNBR + 1;
ENDIF;


READ Person i_Person;

DOW NOT %eof;

  Strucktur(1).links  = 'Name: '         + i_Person.VORNAME;
  Strucktur(1).rechts = 'Geburtsort: '   + i_Person.GEBORT;

  Strucktur(2).links  = 'Nachname: '     + %upper(i_Person.NACHNAME);
  Strucktur(2).rechts = 'Augenfarbe: '   + i_Person.AUGENFARBE;

  Strucktur(3).links  = 'Titel: '        + i_Person.TITEL;
  Strucktur(3).rechts = 'Geburtsdatum: ' + %char(i_Person.GEBDATUM);

  Strucktur(4).links  = 'Nation: '       + i_Person.NATION;
  Strucktur(4).rechts = 'Grösse: '       + %char(i_Person.GROESSE);

  FOR X = 1 TO 4;

    o_Persaw.PERSRRN = Persinfo.RRN;
    o_Persaw.LINENBR = X;
    o_Persaw.CRTTIME = %timestamp();
    o_Persaw.TEXT    = Strucktur(X);

    WRITE PERSAWR o_Persaw;
  ENDFOR;

  // Nächste Person
  READ PERSON i_Person;
ENDDO;

*inlr = *on;
