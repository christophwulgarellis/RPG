**free

ctl-opt                      dftactgrp(*no) decedit('0,') actgrp(*caller) bnddir('AUFGABEN');


/Copy QCPYSRC,PGMINFO
/Copy QPTTSRC,PERSON
/Copy QPTTSRC,MSG
/Copy QPTTSRC,DATE
/Copy QPTTSRC,STRING
/Copy QPTTSRC,CALENDAR


dcl-f  PERSON_AD             workstn indDS(DSPFInd);

dcl-ds o_PERSON00            likeds(z_Person) inz(*likeds);


dcl-ds d_RefInd              qualified dim(9);
  RefName                    zoned(2);
  IndNbr                     zoned(2);
end-ds;

dcl-ds DSPFInd               qualified;
  all                        ind dim(99) pos(1);
  F3                         ind pos(3);
  F5                         ind pos(5);
  F12                        ind pos(12);
  Cmdkey                     ind pos(25);
  Change                     ind pos(29);
  Vorname                    ind pos(31);
  Nachname                   ind pos(32);
  Titel                      ind pos(33);
  Gebdatum                   ind pos(34);
  Gebort                     ind pos(35);
  Nation                     ind pos(36);
  Groesse                    ind pos(37);
  Augenfarbe                 ind pos(38);
end-ds;


dcl-c  REF_VORNAME           1;
dcl-c  REF_NACHNAME          2;
dcl-c  REF_TITEL             3;
dcl-c  REF_GEBDATUM          4;
dcl-c  REF_GEBORT            5;
dcl-c  REF_NATION            6;
dcl-c  REF_GROESSE           7;
dcl-c  REF_AUGENFAR          8;
dcl-c  REF_DUPLIKAT          9;



Init();

DOW NOT (DSPFInd.F3 OR DSPFInd.F12);

  ExcScreen();

  IF DSPFInd.Cmdkey; // = kontrolliert ob irgendeine FTaste gedrückt ist
    ChkCmdKeys();
  ELSE;
    PrcEnter();
  ENDIF;

ENDDO;

*inlr = *on;

dcl-proc Init; // Header UserId und PGMName

  F0PGMNAME  = d_PgmInfo.PgmName;
  F0USERID   = d_PgmInfo.UserId;
  Q_PGMQUEUE = d_PgmInfo.PgmName; // Zeige Nachrichten aus dem aktuellen Programm
  SetMsgQ(Q_PGMQUEUE);
  SETMSGF('MSGF18': '*LIBL');
  ClrMsgQ();


// d_RefInd Datenstrucktur befüllen
  d_RefInd(1).RefName = REF_VORNAME;
  d_RefInd(1).IndNbr  = 31;

  d_RefInd(2).RefName = REF_NACHNAME;
  d_RefInd(2).IndNbr  = 32;

  d_RefInd(3).RefName = REF_TITEL;
  d_RefInd(3).IndNbr  = 33;

  d_RefInd(4).RefName = REF_GEBDATUM;
  d_RefInd(4).IndNbr  = 34;

  d_RefInd(5).RefName = REF_GEBORT;
  d_RefInd(5).IndNbr  = 35;

  d_RefInd(6).RefName = REF_NATION;
  d_RefInd(6).IndNbr  = 36;

  d_RefInd(7).RefName = REF_GROESSE;
  d_RefInd(7).IndNbr  = 37;

  d_RefInd(8).RefName = REF_AUGENFAR;
  d_RefInd(8).IndNbr  = 38;

  d_RefInd(9).RefName = REF_DUPLIKAT;
  d_RefInd(9).IndNbr  = 39;


end-proc;

dcl-proc ExcScreen;


  // Message Subfile aktualisieren
  WRITE F0MSGCTL;

  // Hauptbildschirm anzeigen
  EXFMT F0RECORD;


  F0VORNAME   = %trim(F0VORNAME);
  F0NACHNAME  = %trim(F0NACHNAME);
  F0TITEL     = %trim(F0TITEL);
  F0GEBORT    = %trim(F0GEBORT);
  F0NATION    = %trim(F0NATION);
  F0GROESSE   = %trim(F0GROESSE);
  F0AUGENFAR  = %trim(F0AUGENFAR);

  CLEAR %subarr(DSPFInd.all : 30 : 20);

  ClrMsgQ();

end-proc;


dcl-proc ChkCmdKeys; // Check Command Keys

  SELECT;

  WHEN DSPFInd.F3;

  WHEN DSPFInd.F12;

  WHEN DSPFInd.F5;

    CLEAR F0VORNAME;
    CLEAR F0NACHNAME;
    CLEAR F0TITEL;
    CLEAR F0GEBORT;
    CLEAR F0NATION;
    CLEAR F0AUGENFAR;
    CLEAR F0GROESSE;
    CLEAR F0GEBDATUM;

  OTHER;
    // ungülige Befehlstaste

  ENDSL;

end-proc;


dcl-proc PrcEnter;


  dcl-s X                    int(10);
  dcl-s w_Idx1               int(10);
  dcl-ds d_ChkPerson         likeds(z_ChkPerson) inz;


  // PFLICHTFELDER
  IF F0VORNAME = *blank OR NOT IsAlpha(F0VORNAME);
    DSPFInd.Vorname = *on;
    SndDiagMsg('ERR0001');
  ENDIF;


  IF ( F0NACHNAME = *blank ) OR (NOT IsAlpha(F0NACHNAME));
    DSPFInd.Nachname = *on;
    SndDiagMsg('ERR0002');
  ENDIF;


  IF F0GEBDATUM = *blank OR NOT IsValDate(F0GEBDATUM);
    DSPFInd.Gebdatum   = *on;
    SndDiagMsg('ERR0004');
  ENDIF;

  IF F0NATION = *blank OR NOT IsAlpha(F0NATION);
    DSPFInd.Nation = *on;
    SndDiagMsg('ERR0006');
  ENDIF;


  // Nur Fehler anzeigen wenn falsch befüllt

  IF (F0TITEL <> *blank) AND NOT (IsAlpha(F0TITEL));
    DSPFInd.Titel = *on;
    SndDiagMsg('ERR0003');
  ENDIF;


  IF (F0GEBORT <> *blank) AND NOT (IsAlpha(F0GEBORT));
    DSPFInd.Gebort = *on;
    SndDiagMsg('ERR0005');
  ENDIF;

  IF (F0GROESSE <> *blank) AND NOT IsNum(F0GROESSE);
    DSPFInd.Groesse    = *on;
    SndDiagMsg('ERR0007');
  ENDIF;

  IF (F0AUGENFAR <> *blank) AND NOT IsAlpha(F0AUGENFAR);
    DSPFInd.Augenfarbe = *on;
    SndDiagMsg('ERR0008');
  ENDIF;


// Check ob Indikator auf *on ist
  IF %lookup(*on : DSPFInd.all : 31 : 8) > 0;
    RETURN;
  ENDIF;

// Variablen zuweisen
  o_PERSON00.VORNAME    = F0VORNAME;
  o_PERSON00.NACHNAME   = F0NACHNAME;
  o_PERSON00.TITEL      = F0TITEL;
  o_PERSON00.GEBORT     = F0GEBORT;
  o_PERSON00.NATION     = F0NATION;
  o_PERSON00.AUGENFARBE = F0AUGENFAR;
  o_PERSON00.GEBDATUM   = %date(F0GEBDATUM : *iso0);

  IF F0GROESSE <> *blank;
    o_PERSON00.GROESSE = %uns(F0GROESSE);
  ENDIF;


IF NOT ChkPerson(o_PERSON00 : d_ChkPerson);
// Wenn Der Logische Check keinen Fehler aufwirft direkt zu Write

    FOR X = 1 TO %elem(d_RefInd);

    w_Idx1 = %lookup(d_RefInd(X).RefName
                   : d_ChkPerson.Entry(*).Ref); // in w_Idx1 kommt die Position von den Fehlern im

      IF w_Idx1 <> 0;
         IndZuweis(d_RefInd(X).IndNbr
         : d_ChkPerson.Entry(w_Idx1).MsgId
         : d_ChkPerson.Entry(w_Idx1).MsgData);

      ENDIF;

    ENDFOR;
    RETURN;

ENDIF;

  SndDiagMsg('ERR0009');

  IF DSPFInd.Change;
    RETURN;
  ENDIF;

  WrtPerson(o_Person00);
  DSPFInd.F12 = *on;
end-proc;



dcl-proc IndZuweis;
  dcl-pi *n;
    p_Indikator              zoned(2);
    p_MsgId                  char(7);
    p_MsgData                varchar(500) options(*nopass);
  end-pi;

  DSPFInd.all(p_Indikator) = *on;
  SndDiagMsg(p_MsgId : p_MsgData);


end-proc;
