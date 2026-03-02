**free

ctl-opt dftactgrp(*no) bnddir('KURS18DIR');

/Copy qcpysrc,logger
//01.10.25 AUFGABE2 Final
dcl-s X      int(10);
dcl-s Z      int(10) inz(1);
dcl-s Base   varchar(30) dim(10);
dcl-s Namen1 varchar(30) dim(10);
dcl-s Namen2 varchar(30) dim(10);
dcl-s Namen3 varchar(30) dim(10);
dcl-s Namen4 varchar(30) dim(10);
dcl-s Namen5 varchar(30) dim(10);

// BasisGerüst
Base(1)  = 'Name1  ';
Base(2)  = '  name2';
Base(3)  = '   name3';
Base(4)  = '  ';
Base(5)  = 'Name5';
Base(6)  = '   Name6  ';
Base(7)  = '   ';
Base(8)  = 'Name8   ';
Base(9)  = ' ';
Base(10) = 'name10';

// Liste 1
//Namen1(1)  = 'Name1  ';
//Namen1(2)  = '  name2';
//Namen1(3)  = '   name3';
//Namen1(4)  = '  ';
//Namen1(5)  = 'Name5';
//Namen1(6)  = '   Name6  ';
//Namen1(7)  = '   ';
//Namen1(8)  = 'Name8   ';
//Namen1(9)  = ' ';
//Namen1(10) = 'name10';

// Liste 2
//Namen2(1)  = 'Liste1  ';
//Namen2(2)  = '      ';
//Namen2(3)  = '   Liste3';
//Namen2(4)  = ' Liste4   ';
//Namen2(5)  = 'Liste 5';
//Namen2(6)  = '     ';
//Namen2(7)  = '  Liste7 ';
//Namen2(8)  = '  Liste8   ';
//Namen2(9)  = ' ';
//Namen2(10) = 'liste10';

// Liste 3
Namen3(1)  = 'Liste1  ';
Namen3(2)  = '  liste2';
Namen3(3)  = '   Liste3';
Namen3(4)  = '    ';
Namen3(5)  = 'Liste5';
Namen3(6)  = '     ';
Namen3(7)  = '  Liste7 ';
Namen3(8)  = '  Liste8   ';
Namen3(9)  = ' ';
Namen3(10) = 'liste10';

// Liste 4
//Namen4(1)  = 'Liste1  ';
//Namen4(2)  = '  liste2';
//Namen4(3)  = '   ';
//Namen4(4)  = '    ';
//Namen4(5)  = 'Liste 5';
//Namen4(6)  = 'Liste6     ';
//Namen4(7)  = '   ';
//Namen4(8)  = '   Liste8   ';
//Namen4(9)  = ' Liste9 ';
//Namen4(10) = '  ';

// Liste 5
//Namen5(1)  = 'Liste1  ';
//Namen5(2)  = '   liste2';
//Namen5(3)  = '   Liste3';
//Namen5(4)  = ' Liste 5   ';
//Namen5(5)  = '    ';
//Namen5(6)  = '  LISTE6   ';
//Namen5(7)  = '    liste7 ';
//Namen5(8)  = '    ';
//Namen5(9)  = ' ';
//Namen5(10) = 'liste10';


   // Nur hier Ändern! //

   Base = Namen3;


   FOR X = 1 TO %elem(Base);              // Blanks entfernen und Capitalize
     Base(X) = %trim(Base(X));            // Basis für die Testfälle 'NAMEN'

     IF %len(%trim(Base(X))) > 0;         // Wenn die getrimmte Länge größer als 0 Dann:
       Base(X) = %upper(Base(X) : 1 : 1); // Setze den Anfangsbuchstaben auf Groß

       IF X <> Z;                         // Wenn Index X UNGLEICH Z ist dann:
         Base(Z) = Base(X);               // Setze Z auf den aktuellen Wert
         Base(X) = ' ';                   // Setze Index X auf Blank
       ENDIF;

       Z += 1;                            // Erhöhe Z um 1, zählt gültige Elemente
     ENDIF;

   ENDFOR;


   Namen3 = Base;

   // Länge auf Null abfragen und dann Leerzeile löschen

   FOR X = 1 TO %elem(Base);  // Für jedes Element in Base
     DSPLY Base(X);            // Display Base ab Index 1
   ENDFOR;

log('Das ist ein schöner Text1');


*inlr = *on;
