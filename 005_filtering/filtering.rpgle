**free

ctl-opt main(Aufg006) dftactgrp(*no) decedit('0,');

dcl-proc Aufg006;
  dcl-pi *n;
    Wert char(30);
  end-pi;

  DSPLY ('1.Original: ' + Wert);
  DSPLY ('2.Output: ' + %char(Konvertierung(Wert)));

  *inlr = *on;
end-proc;


dcl-proc Konvertierung;

  dcl-pi *n packed(30:9);
    p_Wert varchar(30) value;
  end-pi;

  dcl-s Wert      char(30);
  dcl-s DezWert   packed(30:9);
  dcl-s Final     packed(30:9);
  dcl-s Gefiltert varchar(30);
  dcl-s Blank     varchar(50) inz('');
  dcl-s X         int(10);
  dcl-s Kommapos  int(10);
  dcl-s Kommazei  varchar(1) inz(',');
  dcl-s Erlaubt   varchar(10);
  dcl-s Minus     ind inz(*off);
  dcl-s Ziffer    varchar(10);
  dcl-s Zifferbool ind;

  // Auf input Testen //

  p_Wert = %trim(p_Wert);
  IF %len(p_Wert) = 0;
    RETURN 0;
  ENDIF;


  // Auf Minus Testen //
  IF %subst(p_Wert : 1 : 1) = '-' OR %subst(p_Wert : %len(%trim(p_Wert)) : 1) = '-';
    Minus = *on;
  ENDIF;

  Erlaubt = '1234567890,';

  // Nur Erlaubte Zeichen //
  FOR X = 1 TO %len(p_Wert);
    Erlaubt = %subst(p_Wert : X : 1);
    IF %scan(Erlaubt : '1234567890,') > 0;
      Blank += Erlaubt;
    ENDIF;
  ENDFOR;

  Gefiltert = %trim(Blank);
  Gefiltert = %scanrpl('-' : '' : Gefiltert);
  Gefiltert = %trim(Gefiltert);

  // Kommapos berechnen //
  Kommapos = %scan(Kommazei : Gefiltert);

  // Zuviele Kommas entfernen //
  IF Kommapos <> 0 AND Kommapos < %len(Gefiltert);
    Gefiltert = %scanrpl(Kommazei : '' : Gefiltert : Kommapos + 1);
  ENDIF;

  // Vorkommastellen zuschneiden //
  IF Kommapos > 21;
    Gefiltert = %subst(Gefiltert : Kommapos - 21 + 1);
  ENDIF;

  IF Kommapos = 0 AND %len(Gefiltert) > 21;
    Gefiltert = %subst(Gefiltert : %len(Gefiltert) - 21 + 1);
  ENDIF;

  // in Dezimal umwandeln //
  Gefiltert = %trim(Gefiltert);

  IF %len(Gefiltert) = 0;
    Gefiltert = '0';
  ENDIF;

  // Ist Ziffer enthalten? //
  Ziffer = '1234567890';
  IF %scan(Gefiltert : Ziffer) < 0;
    Zifferbool = *off;
  ENDIF;

  IF Zifferbool = *off;
    Gefiltert = '0' + Gefiltert;
  ENDIF;


  Final = %dec(Gefiltert : 30 : 9);

  IF Minus = *on;
    Final *= -1;
  ENDIF;

  RETURN Final;
end-proc;
