**free

// Aufgabe004 = Kassenbon Datenstruktur
// Pro Bereich Templates erstellen und am Schluss zusammenfügen in "RECHNUNG"
// Danach Werte einfügen

// Zusatz zu AUFG004.0 Logger testing
//ctl-opt dftactgrp(*no) bnddir('KURS18DIR');

// /include QCPYSRC,logger


dcl-ds t_Header         qualified template inz;
  Firmenname            varchar(20);
  PLZ                   int(5);
  Anschrift             varchar(50);
  Telefon               varchar(20);
end-ds;


dcl-ds t_Datum          qualified template inz;
  Jahr                  zoned(4);
  Monat                 zoned(2);
  Tag                   zoned(2);
  JJJJMMTT              zoned(8) pos(1);
end-ds;


dcl-ds t_Positionen     qualified template inz;
  Produktname           varchar(20);
  Possumme1             packed(10:2);
end-ds;


dcl-ds t_Summen_Steuern qualified template;
  Possumme1             packed(10:2);
  Possumme2             packed(10:2);
  Possumme3             packed(10:2);
  Steuern               varchar(10);
  Waehrung              char(3) inz('EUR');
end-ds;


dcl-ds t_Zahlungsdaten  qualified template inz;
  Zahlungsart           varchar(20);
  Zahlungsbetrag        int(20);
end-ds;


// am Schluss alle Templates in "RECHNUNG" zusammenfügen mit LIKEDS
dcl-ds Rechnung         qualified inz;
  Header                likeds(t_Header);
  Datum                 likeds(t_Datum);
  Positionen            likeds(t_Positionen) dim(3);
  Summen_Steuern        likeds(t_Summen_Steuern);
  Zahlungsdaten         likeds(t_Zahlungsdaten);
end-ds;


// Header definieren
Rechnung.Header.Firmenname = 'Billa Plus';
Rechnung.Header.PLZ        = 1210;
Rechnung.Header.Anschrift  = 'Pragerstrasse 30';
Rechnung.Header.Telefon    = 'Tel: 0123456789';


// Datum definieren
Rechnung.Datum.JJJJMMTT = %dec(%date());


// Positionen Array definieren
Rechnung.Positionen(1).Produktname = 'Apfel';
Rechnung.Positionen(2).Produktname = 'Birne';
Rechnung.Positionen(3).Produktname = 'Melone';

Rechnung.Positionen(1).Possumme1 = 3.53;
Rechnung.Positionen(2).Possumme1 = 2.92;
Rechnung.Positionen(3).Possumme1 = 4.77;


// Summen_Steuern definieren
Rechnung.Summen_Steuern.Steuern = '20%';

// Zahlungsdaten definieren
Rechnung.Zahlungsdaten.Zahlungsart    = 'Karte';
Rechnung.Zahlungsdaten.Zahlungsbetrag = 20;

// DSPLY Rechnung.Zahlungsdaten.Zahlungsart;
// DSPLY Rechnung.Zahlungsdaten.Zahlungsbetrag;


// READ Kunden i_Kunden;

// DOW NOT %eof;
//   DSPLY ('Position: ' + Positionen.Produktname);

//   READ Rechnung Positionen;

// ENDDO;


// logger testing:
//log('loginfo' : Rechnung.Header.Anschrift);

*inlr = *on;
