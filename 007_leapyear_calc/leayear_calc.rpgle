**free
ctl-opt main(aufg008) dftactgrp(*no) bnddir('AUFGABEN');


/Copy QPTTSRC,CALENDAR


dcl-proc AlleFeiertage;
  dcl-pi *n         likeds(arrFeiertage);
    Jahr            int(10) value;
    p_OsterSonntag  date;
  end-pi;

  dcl-ds arrFeiertage qualified;
    Datum date dim(20);
    Name  char(30) dim(20);
  end-ds;

  dcl-s anzahlFeiertage int(10);

  anzahlFeiertage = 0;

  // Fixe Feiertage
  anzahlFeiertage += 1;
  arrFeiertage.Datum(anzahlFeiertage) = %date(%char(Jahr) + '-01-01' : *iso);
  arrFeiertage.Name(anzahlFeiertage)  = 'Neujahr';

  anzahlFeiertage += 1;
  arrFeiertage.Datum(anzahlFeiertage) = %date(%char(Jahr) + '-01-06' : *iso);
  arrFeiertage.Name(anzahlFeiertage)  = 'Heilige Drei Könige';

  anzahlFeiertage += 1;
  arrFeiertage.Datum(anzahlFeiertage) = %date(%char(Jahr) + '-05-01' : *iso);
  arrFeiertage.Name(anzahlFeiertage)  = 'Staatsfeiertag';

  anzahlFeiertage += 1;
  arrFeiertage.Datum(anzahlFeiertage) = %date(%char(Jahr) + '-08-15' : *iso);
  arrFeiertage.Name(anzahlFeiertage)  = 'Maria Himmelfahrt';

  anzahlFeiertage += 1;
  arrFeiertage.Datum(anzahlFeiertage) = %date(%char(Jahr) + '-11-01' : *iso);
  arrFeiertage.Name(anzahlFeiertage)  = 'Allerheiligen';

  anzahlFeiertage += 1;
  arrFeiertage.Datum(anzahlFeiertage) = %date(%char(Jahr) + '-12-08' : *iso);
  arrFeiertage.Name(anzahlFeiertage)  = 'Maria Empfängnis';

  anzahlFeiertage += 1;
  arrFeiertage.Datum(anzahlFeiertage) = %date(%char(Jahr) + '-12-25' : *iso);
  arrFeiertage.Name(anzahlFeiertage)  = 'Christtag';

  anzahlFeiertage += 1;
  arrFeiertage.Datum(anzahlFeiertage) = %date(%char(Jahr) + '-12-26' : *iso);
  arrFeiertage.Name(anzahlFeiertage)  = 'Stefanitag';

  // Bewegliche Feiertage
  anzahlFeiertage += 1;
  arrFeiertage.Datum(anzahlFeiertage) = p_OsterSonntag + %days(1);
  arrFeiertage.Name(anzahlFeiertage)  = 'Ostermontag';

  anzahlFeiertage += 1;
  arrFeiertage.Datum(anzahlFeiertage) = p_OsterSonntag + %days(39);
  arrFeiertage.Name(anzahlFeiertage)  = 'Christi Himmelfahrt';

  anzahlFeiertage += 1;
  arrFeiertage.Datum(anzahlFeiertage) = p_OsterSonntag + %days(50);
  arrFeiertage.Name(anzahlFeiertage)  = 'Pfingstmontag';

  anzahlFeiertage += 1;
  arrFeiertage.Datum(anzahlFeiertage) = p_OsterSonntag + %days(60);
  arrFeiertage.Name(anzahlFeiertage)  = 'Fronleichnam';

  RETURN arrFeiertage;
end-proc;



// MAIN
dcl-proc aufg008;

  dcl-f CALENDAR disk usage(*output) rename(CALENDAR : CALENDARR);
  dcl-ds o_CALENDAR likerec(CALENDARR : *output) inz;

  dcl-s anzahlFeiertage int(10) inz(0);
  dcl-s Datum_i         date inz(d'1900-01-01');
  dcl-s Datum_e         date inz(d'2099-12-31');
  dcl-s LaufIndex       int(10) inz(1);
  dcl-s Jahr            int(10);
  dcl-s JahrAlt         int(10) inz(0);
  dcl-s IsSchaltjahr    ind;
  dcl-s i               int(10);
  dcl-s gefunden        ind;
  dcl-s ftName          char(30);
  dcl-s OsterSonntag    date;

  dcl-ds arrFeiertage qualified;
    Datum date dim(20);
    Name  char(30) dim(20);
  end-ds;


  DOW Datum_i <= Datum_e;

    Jahr = %subdt(Datum_i : *years);

    // Neues Jahr -> Feiertage berechnen
    IF Jahr <> JahrAlt;
      LaufIndex = 1;
      JahrAlt   = Jahr;
      anzahlFeiertage = AlleFeiertage(Jahr : OsterSonntag);
    ENDIF;

    // Schaltjahr prüfen
    IF %rem(Jahr : 400) = 0;
      IsSchaltjahr = *on;
    ELSEIF %rem(Jahr : 100) = 0;
      IsSchaltjahr = *off;
    ELSEIF %rem(Jahr : 4) = 0;
      IsSchaltjahr = *on;
    ELSE;
      IsSchaltjahr = *off;
    ENDIF;

    // Feiertag prüfen
    gefunden = *off;
    ftName   = *blanks;
    FOR i = 1 TO anzahlFeiertage;
      IF Datum_i = arrFeiertage.Datum(i);
        gefunden = *on;
        ftName   = arrFeiertage.Name(i);
        LEAVE;
      ENDIF;
    ENDFOR;


    // Output befüllen
    o_CALENDAR.LAND       = 'AT';
    o_CALENDAR.DATUM      = Datum_i;
    o_CALENDAR.WOCHENTAGZ = WochentagZiffer(Datum_i);
    o_CALENDAR.WOCHENTAG  = WochentagName(WochentagZiffer(Datum_i));
    o_CALENDAR.KW         = Kalenderwoche(Datum_i);
    o_CALENDAR.LAUFTAG    = LaufIndex;

    IF gefunden;
      o_CALENDAR.Feiertag = 'J';
      o_CALENDAR.FTName   = ftName;
    ELSE;
      o_CALENDAR.Feiertag = 'N';
      o_CALENDAR.FTName   = *blanks;
    ENDIF;

    WRITE CALENDARR o_CALENDAR;

    Datum_i   += %days(1);
    LaufIndex += 1;

  ENDDO;

  *inlr = *on;
  RETURN;
end-proc;
