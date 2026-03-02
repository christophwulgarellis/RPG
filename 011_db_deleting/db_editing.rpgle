**free

ctl-opt                      dftactgrp(*no) decedit('0,') actgrp(*caller) bnddir('AUFGABEN');

// DELETE PGM

/Copy QCPYSRC,PGMINFO
/Copy QPTTSRC,PERSON
/Copy QPTTSRC,MSG
/Copy QPTTSRC,DATE
/Copy QPTTSRC,STRING
/Copy QPTTSRC,CALENDAR


dcl-f  PERSON_DEL            workstn indDS(DSPFInd);        // PERSON_DEL

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

dcl-pi *n;
  p_RRN                      packed(11);
end-pi;



IF Init();

DOW NOT (DSPFInd.F3 OR DSPFInd.F12);

  ExcScreen();

  IF DSPFInd.Cmdkey; // = kontrolliert ob irgendeine FTaste gedrückt ist
    ChkCmdKeys();
  ELSE;
    PrcEnter();
  ENDIF;

ENDDO;

ENDIF;

*inlr = *on;


dcl-proc Init; // Header UserId und PGMName

dcl-pi *n                    ind;
end-pi;


  IF NOT RtvPersonByRRN(p_RRN : o_PERSON00);
    SndDiagMsg('ERR0017');
    RETURN *off;
  ENDIF;


  F0PGMNAME  = d_PgmInfo.PgmName;
  F0USERID   = d_PgmInfo.UserId;
  Q_PGMQUEUE = d_PgmInfo.PgmName;
  SetMsgQ(Q_PGMQUEUE);
  SETMSGF('MSGF18': '*LIBL');


  p_RRN      = o_person00.ID; // ----------------
  F0VORNAME  = o_PERSON00.VORNAME;
  F0NACHNAME = o_PERSON00.NACHNAME;
  F0TITEL    = o_PERSON00.TITEL;
  F0GEBDATUM = %char(o_PERSON00.GEBDATUM : *iso0);
  F0GEBORT   = o_PERSON00.GEBORT;
  F0NATION   = o_PERSON00.NATION;
  F0GROESSE  = %char(o_PERSON00.GROESSE);
  F0AUGENFAR = o_PERSON00.Augenfarbe;   // ---------------


  ClrMsgQ();


RETURN *on;

end-proc;

dcl-proc ExcScreen;


  // Message Subfile aktualisieren
  WRITE F0MSGCTL;

  // Hauptbildschirm anzeigen
  WRITE F0RECORD;

  READ F0RECORD;


  p_RRN      = o_person00.ID; // ----------------
  F0VORNAME  = o_PERSON00.VORNAME;
  F0NACHNAME = o_PERSON00.NACHNAME;
  F0TITEL    = o_PERSON00.TITEL;
  F0GEBDATUM = %char(o_PERSON00.GEBDATUM : *iso0);
  F0GEBORT   = o_PERSON00.GEBORT;
  F0NATION   = o_PERSON00.NATION;
  F0GROESSE  = %char(o_PERSON00.GROESSE);
  F0AUGENFAR = o_PERSON00.Augenfarbe;   // ---------------

  CLEAR %subarr(DSPFInd.all : 30 : 20);

  ClrMsgQ();

end-proc;


dcl-proc ChkCmdKeys; // Check Command Keys

  SELECT;

  WHEN DSPFInd.F3;

  WHEN DSPFInd.F12;

  WHEN DSPFInd.F5;

  OTHER;
    // ungülige Befehlstaste

  ENDSL;

end-proc;


dcl-proc PrcEnter;


  dcl-s X                    int(10);
  dcl-s w_Idx1               int(10);
  dcl-ds d_ChkPerson         likeds(z_ChkPerson) inz;



  DelPerson(o_Person00 : p_RRN);

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
