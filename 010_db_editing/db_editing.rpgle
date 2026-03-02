**free

ctl-opt                      dftactgrp(*no) decedit('0,') actgrp(*caller) bnddir('AUFGABEN');


/Copy QCPYSRC,PGMINFO
/Copy QPTTSRC,PERSON
/Copy QPTTSRC,MSG
/Copy QPTTSRC,DATE
/Copy QPTTSRC,STRING
/Copy QPTTSRC,CALENDAR


dcl-f  PERSONWK              workstn indDS(DSPFInd) SFILE(F0SUBFIL : S_SF); // S_SF = RRNFELD

dcl-ds o_PERSON00            likeds(z_Person) inz(*likeds);

dcl-s S_SF                   packed(4);

dcl-s p_RRN                  packed(11);

dcl-s PageSize               int(10) inz(13);   // Anzahl Zeilen pro Seite
dcl-s EndOfFile              ind inz(*off);     // Flag: Ende erreicht?
dcl-s StartOfFile            ind inz(*off);
dcl-s g_ViewMode             ind inz(*off);
dcl-s g_RowDbRrn             packed(11:0) dim(200) inz;


dcl-ds g_PageFirstKey        likeds(z_PersonPKey) inz(*likeds);
dcl-ds g_PageLastKey         likeds(z_PersonPKey) inz(*likeds);



dcl-ds d_RefInd              qualified dim(9);
  RefName                    zoned(2);
  IndNbr                     zoned(2);
end-ds;

dcl-ds DSPFInd               qualified;
  all                        ind dim(99) pos(1);
  F3                         ind pos(3);
  F5                         ind pos(5);
  F6                         ind pos(6);
  F11                        ind pos(11);
  F12                        ind pos(12);
  F17                        ind pos(17);
  F18                        ind pos(18);
  Cmdkey                     ind pos(25);
  Pageup                     ind pos(27);
  Pagedown                   ind pos(28);
  Change                     ind pos(29);
  Vorname                    ind pos(31);
  Nachname                   ind pos(32);
  Titel                      ind pos(33);
  Gebdatum                   ind pos(34);
  Gebort                     ind pos(35);
  Nation                     ind pos(36);
  Groesse                    ind pos(37);
  Augenfarbe                 ind pos(38);
  CSRLOC                     ind pos(86);
  Ende                       ind pos(92);
  SFLCLR                     ind pos(93);
  SFLDSP                     ind pos(94);
end-ds;



dcl-pr AUFG009               extpgm('AUFG009');
end-pr;

dcl-pr AUFG010               extpgm('AUFG010');
 p_rrn                       packed(11) const;
end-pr;

dcl-pr AUFG012               extpgm('AUFG012');
 p_rrn                       packed(11) const;
end-pr;

dcl-pr AUFG013               extpgm('AUFG013');
 p_rrn                       packed(11) const;
end-pr;

dcl-ds g_Start               likeds(z_PersonPKey) inz(*likeds);
dcl-c  c_PageSize            13;
dcl-s  g_lastRRN             packed(11);




Init();

DOW NOT (DSPFInd.F3 OR DSPFInd.F12);
  SetMsgQ(d_PgmInfo.PgmName);
  ExcScreen();

  IF DSPFInd.Cmdkey;
    ChkCmdKeys();
  ELSE;
    PrcEnter();
  ENDIF;

ENDDO;


*inlr = *on;


dcl-proc Init;

  dcl-ds startKey            likeds(z_PersonPKey) inz;


  SETMSGF('MSGF18': '*LIBL');
  SetMsgQ(d_PgmInfo.PgmName);
  F0PGMNAME  = d_PgmInfo.PgmName;
  F0USERID   = d_PgmInfo.UserId;
  F0MSGQ     = d_PgmInfo.PgmName;

  GetData(startKey : POS_FIRST); // baut und schreibt die 13 (c_PageSize) Zeilen selbst


end-proc;




dcl-proc ExcScreen;

  F0SFLRCDN = 1; // Cursor auf Position 1


  WRITE F0MSGCTL;
  WRITE F0HEADER;
  WRITE F0FOOTER;
  READ  F0HEADER;


  ClrMsgQ();

end-proc;



dcl-proc ChkCmdKeys; // Check Command Keys

  SELECT;

  WHEN DSPFInd.F3;

  WHEN DSPFInd.F12;

  // --- PageDown --- //
  WHEN DSPFInd.Pagedown;
    PrcPageDown();

  // --- PageUp --- //
  WHEN DSPFInd.Pageup;
    PrcPageUp();

  // --- Anfang --- //
  WHEN DSPFInd.F17;
    PrcToStart();

  // --- Ende --- //
  WHEN DSPFInd.F18;
    PrcToEnd();
    // DSPFInd.Ende = *on;

  // --- Refresh --- //
  WHEN DSPFInd.F5;
    PrcRefresh();

  // --- ToggleView --- //
  WHEN DSPFInd.F11;
    PrcToggleView();

  // --- Create --- //
  WHEN DSPFInd.F6;
    PrcCreate();


  OTHER;

  ENDSL;

end-proc;




dcl-proc PrcEnter;

  dcl-s IDinput              packed(11:0);
  dcl-s i                    int(3);
  dcl-ds Result              likeds(z_PersonList) inz;

  READC F0SUBFIL;

  SELECT;

  WHEN F0OPTION = '2';
      AUFG010(F0FRRCDNBR);

  WHEN F0OPTION = '4';
      AUFG012(F0FRRCDNBR);

  WHEN F0OPTION = '5';
      AUFG013(F0FRRCDNBR);

  ENDSL;

  IF PrcParseRRN(%trim(F0POSTO) : IDinput);
    PrcSearchByID(IDinput);

    CLEAR F0POSTO;
    CLEAR F0OPTION;
    CLEAR F0FILTER;

    RETURN;
  ENDIF;


IF %trim(F0FILTER) <> '';


   // Suche ausführen
   IF PrcNameFilter(%trim(F0FILTER) : %trim(F0FILTER) : Result);

    ExcScreen();
   ENDIF;

   // Eingaben zurücksetzen
   CLEAR F0FILTER;
   CLEAR F0OPTION;
   CLEAR F0POSTO;

   RETURN;

ENDIF;


end-proc;




dcl-proc SetEndInd;

  // Wenn am Ende der Datei (kein weiterer PageDown möglich)  "Ende"
  IF EndOfFile = *on;
    DSPFInd.Ende = *on;      // Footer zeigt "Ende"
    SndDiagMsg('ERR0018');
  ELSE;
    DSPFInd.Ende = *off;     // Footer zeigt "Weitere..."
  ENDIF;

end-proc;




dcl-proc PrcToStart;

  dcl-ds startKey            likeds(z_PersonPKey) inz;

  // Ab Anfang laden
  GetData(startKey : POS_FIRST);
  SetEndInd();

  // Cursor auf erste sichtbare Subfile-Zeile
  F0SFLRCDN = 1;


end-proc;



dcl-proc PrcToEnd;

  dcl-ds endKey              likeds(z_PersonPKey) inz;


  GetData(endKey : POS_LAST);

  SetEndInd();


end-proc;



dcl-proc PrcPageDown;

  IF EndOfFile;
     SetEndInd();
    RETURN;
  ENDIF;

  GetData(g_PageLastKey : POS_NEXT);
  SetEndInd();

end-proc;



dcl-proc PrcPageUp;

  IF StartOfFile;
    RETURN;
  ENDIF;

  GetData(g_PageFirstKey : POS_PREV);
  SetEndInd();

end-proc;



dcl-proc PrcRefresh;

  dcl-s saveCursor           packed(5:0);

  // Cursorposition
  saveCursor = F0SFLRCDN;

  // Seite neu laden
  GetData(g_PageFirstKey : POS_AT);

  CLEAR F0POSTO;


  // Cursorposition wiederherstellen
  IF saveCursor > 0;
    F0SFLRCDN = saveCursor;
  ENDIF;

end-proc;



dcl-proc PrcToggleView;

  dcl-s saveCursor           packed(5:0);

  g_ViewMode = NOT g_ViewMode;

  saveCursor = F0SFLRCDN;

  // Seite an FirstKey neu aufbauen
  GetData(g_PageFirstKey : POS_AT);
  SndDiagMsg('ERR0020');

  IF saveCursor > 0;
    F0SFLRCDN = saveCursor;
  ENDIF;

end-proc;



dcl-proc PrcCreate;

  dcl-s saveCursor           packed(5:0);

  saveCursor = F0SFLRCDN;

  CALLP AUFG009();

  // Daten neu laden (aktuelle Seite)
  GetData(g_PageFirstKey : POS_AT);


  // Cursorposition wiederherstellen
  IF saveCursor > 0;
    F0SFLRCDN = saveCursor;
  ENDIF;

end-proc;



dcl-proc WrtSubF;

  dcl-pi *n;
   p_line                    char(73) value;
  end-pi;

  CLEAR F0OPTION;      // Suchfeld "Listenanfang bei.. " clearen

  S_SF += 1;
  F0SFLRCDN = S_SF;
  F0SFLLINE = p_line;
  WRITE F0SUBFIL;

end-proc;



dcl-proc ClrSubF;

  S_SF = 0;
  CLEAR g_RowDbRrn;
  DSPFInd.SFLCLR = *on;
  WRITE F0HEADER;
  DSPFInd.SFLCLR = *off;  // SFLCLR = Subfile leeren

end-proc;



// dcl-proc PrcParseRRN;

//   dcl-pi *n                  ind;
//     p_in                     char(20) const;
//     p_rrn                    packed(11:0);
//   end-pi;

//   dcl-c allowedDigits        '0123456789';
//   dcl-s s                    char(20);

//   s = %trim(p_in);

//   if s = '';
//     return *off;
//   endif;

//   // Prüfen mit %check (gibt Position des ersten unerlaubten Zeichens zurück)
//   // if %check(allowedDigits : s) > 0;
//   //   return *off;
//   // endif;

//   p_rrn = %dec(s : 11 : 0);

//   if p_rrn <= 0;
//     return *off;
//   endif;

//   return *on;

// end-proc;



dcl-proc PrcParseRRN;

  dcl-pi *n ind;
    p_in    char(20) const;
    p_rrn   packed(11:0);
  end-pi;

  dcl-s s char(20);
  dcl-s i int(10);

  s = %trim(p_in);

  IF s = '';
    RETURN *off;
  ENDIF;

  // Nur Ziffern erlaubt
  FOR i = 1 TO %len(%trim(s));
    IF %subst(s : i : 1) < '0' OR %subst(s : i : 1) > '9';
      SndDiagMsg('ERR0021');
      RETURN *off;
    ENDIF;
  ENDFOR;

  // In packed wandeln
  p_rrn = %dec(s : 11 : 0);

  IF p_rrn <= 0;
    RETURN *off;
  ENDIF;

  RETURN *on;

end-proc;




dcl-proc PrcSearchByID;

  dcl-pi *n;
    p_rrn                    packed(11:0) const;
  end-pi;

  dcl-ds o_Person            likeds(z_Person) inz(*likeds);
  dcl-ds startKey            likeds(z_PersonPKey) inz;

  // 1) Person zur RRN lesen
  IF NOT RtvPersonByRRN(p_rrn : o_Person);
    SndDiagMsg('ERR0019' + %char(p_rrn));
    RETURN;
  ENDIF;

  // 2) StartKey aus o_Person bauen
  startKey.ID = o_Person.ID;

  // 3) Seite NEU laden an der Position des Datensatzes
  GetData(startKey : POS_AT);


end-proc;




dcl-proc GetData;

  dcl-pi *n;
   p_StartKey                likeds(z_PersonPKey) const;
   p_PosMode                 char(10)  const;   // 'FIRST'|'NEXT'|'PREV'|'LAST'|'AT'
  end-pi;

  dcl-ds d_View1             qualified inz;
    ID                       char(5)  pos(1);
    Name                     char(50) pos(9);
    GebDat                   char(8)  pos(63);
    Nat                      char(2)  pos(72);
  end-ds;

  dcl-ds d_View2             qualified inz;
    ID                       char(5)  pos(1);
    Titel                    char(20) pos(9);
    GebOrt                   char(20) pos(33);
    Groesse                  char(3)  pos(57);
    AFarbe                   char(10) pos(62);
  end-ds;

  dcl-ds w_PersonListReq     likeds(z_PersonListReq) inz;
  dcl-ds w_PersonList        likeds(z_PersonList)    inz;
  dcl-ds o_Person            likeds(z_Person)        inz(*likeds);
  dcl-s  i                   uns(10);

  // --- Subfile leeren & Marker/Flags reset ---
  ClrSubF();
  w_PersonListReq.NbrReqRcds         = c_PageSize;       // 13 Zeilen
  w_PersonListReq.PosPerson.key      = p_StartKey;
  w_PersonListReq.PosPerson.PosMode  = p_PosMode;

  CLEAR g_Start;
  CLEAR g_PageFirstKey;
  CLEAR g_PageLastKey;
  StartOfFile = *off;
  EndOfFile   = *off;

  IF ListPersons(w_PersonListReq : w_PersonList);

    // --- Subfile füllen ---
    FOR i = 1 TO w_PersonList.nbrEntries;
      o_Person       = w_PersonList.entry(i).Person;        // Person laden
      IF g_ViewMode;
        d_View2.ID     = %char(o_Person.ID);
        d_View2.Titel  = %trim(o_Person.TITEL);
        d_View2.Groesse= %char(o_Person.GROESSE);
        d_View2.GebOrt = %trim(o_Person.GEBORT);
        d_View2.AFarbe = %trim(o_Person.AUGENFARBE);
        WrtSubF(d_View2);
      ELSE;
        d_View1.ID     = %char(o_Person.ID);
        d_View1.Name   = %trim(o_Person.VORNAME) + ' ' + %trim(o_Person.NACHNAME);
        d_View1.GebDat = %char(o_Person.GEBDATUM : *iso0);
        d_View1.Nat    = o_Person.NATION;

        F0FRRCDNBR = w_PersonList.entry(i).rrn;             // Hier gebe ich die RRN der Zeile an damit ich sie aufrufen

        WrtSubF(d_View1);
      ENDIF;
    ENDFOR;

    // --- First/Last-Key der Seite sichern ---
    EVAL-CORR g_PageFirstKey = w_PersonList.entry(1).Person;
    EVAL-CORR g_PageLastKey  = w_PersonList.entry(w_PersonList.nbrEntries).Person;
    EVAL-CORR g_Start        = g_PageFirstKey;

    // --- Anfang/Ende bestimmen anhand der Richtung & MoreRcdsAvail ---
    SELECT;
      WHEN p_PosMode IN %list(POS_FIRST : POS_NEXT : POS_AT);
        // Vorwärts gelesen: MoreRcdsAvail signalisiert es gibt mehr unten
        IF w_PersonList.MoreRcdsAvail = *on;
          EndOfFile = *off;
        ELSE;
          EndOfFile = *on;       // unten Ende erreicht
        ENDIF;

        // Oben sind wir am Anfang, wenn FIRST (und weniger als PageSize) oder PREV zuvor *on war
        // Falls du ein explizites HasMoreUp brauchst, siehe optionalen Fix in ListPersons.
        // Hier einfache Heuristik:
        IF p_PosMode = POS_FIRST;
          StartOfFile = *on;     // wir beginnen oben
        ENDIF;

      WHEN p_PosMode IN %list(POS_PREV : POS_LAST);
        // Rückwärts gelesen: MoreRcdsAvail signalisiert es gibt mehr oben
        IF w_PersonList.MoreRcdsAvail = *on;
          StartOfFile = *off;
        ELSE;
          StartOfFile = *on;     // oben Anfang erreicht
        ENDIF;

        // Unten (Ende) erkennen wir heuristisch: wenn weniger als PageSize geliefert wurde, könnte unten Ende sein.
        // Für präzise Erkennung: beim nächsten PageDown wieder prüfen (oder erweitere ListPersons um HasMoreDown für PR
        IF w_PersonList.nbrEntries < c_PageSize;
          EndOfFile = *on;
        ENDIF;
    ENDSL;

  ELSE;
    // Keine Daten: klar Anfang und Ende
    StartOfFile = *on;
    EndOfFile   = *on;
  ENDIF;


end-proc;



// Legende:

// F0POSTO = Listenanfang Inputfeld
// F0OPTION = Ausw Inputfeld
// F0SFLLINE = Text neben Ausw Inputfeld
// F0PGMNAME = Toplinks ProgrammnamenFeld
// F0USERID = Toplinks UserID namenfeld
// S_SF = RRN
// SFLSIZ(13) = Max. Anzahl Sätze im Subfile-Puffer
// SFLPAG(13) = Anzahl gleichzeitig sichtbarer Sätze
// F0CSRFLD = Feldname, auf dem der Cursor stand
// F0CSRPOS = Zeichenposition im Feld
// F0LINE = Bildschirmzeile
// F0POS = Spaltenposition
// A 86 CSRLOC(F0LINE F0POS) = Nur wenn Indikator 86 = ON: Cursor wird gesetzt auf (F0LINE, F0POS)
// A SFLCSRRRN(&F0SFLCSRRN) = Gibt die Subfile-Zeile (RRN) zurück, in der der Cursor sitzt

// F0CSRFMT = Format unter dem Cursor
// F0CSRFLD = Feld  unter dem Cursor
// F0CSRPOS = Position im Feld
// F0SFLCSRRN = Subfile-RRN vom Cursor
// F0SFLRCDN = Alternative RRN-Methode
// F0JOBNAME, F0USER = Systeminfos (meist nicht genutzt)
// F0LINE / F0POS =  Zielposition zum Cursor Setzen


// SFLCTL = Subfilecontrol
// SFLSIZ = maximale Anzahl Records im Subfile-Puffer
// SFLPAG(1) = Anzahl Zeilen pro Seite
// SFLDSP = anzeigen
// SFLCLR = Subfile leeren
// SFLEND = Ende erreicht kein PageDown mehr möglich
