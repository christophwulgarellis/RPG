**free

ctl-opt main(main) dftactgrp(*no) decedit('0,');


dcl-f CSVFILE  disk usage(*input) rename(CSVFILE : CSVFILER);
dcl-f OBSTPF   disk usage(*output : *update : *delete) keyed;

dcl-ds I_CSVFILE likerec(CSVFILER : *input) inz;
dcl-ds I_OBSTPF  likerec(Obstpf : *input) inz;
dcl-ds O_OBSTPF  likerec(Obstpf : *output) inz;


dcl-s Zeile  varchar(1000);
dcl-s Semico char(1) inz(';');


dcl-s Part1  varchar(50);
dcl-s Part2  varchar(50);
dcl-s Part3  varchar(50);
dcl-s Part4  varchar(50);

dcl-s pos1   int(10);
dcl-s pos2   int(10);
dcl-s pos3   int(10);
dcl-s pos4   int(10);

// dcl-s X int(10);


dcl-proc Main;
  dcl-pi *n;
  end-pi;

  // Erste Zeile überspringen //
  READ CSVFILE I_CSVFILE;
  READ CSVFILE I_CSVFILE;

  DOW NOT %eof(CSVFILE);

    // in Prozedur einfügen
    // Parsen(Zeile : semico : Set.Part1 : Set.Part2 : Set.Part3 : Set.Part4);
    Zeile = %trim(Zeile);

    pos1  = %scan(Semico : Zeile);
    part1 = %subst(Zeile : 1 : pos1 - 1);

    pos2  = %scan(Semico : Zeile : pos1 + 1);
    part2 = %subst(Zeile : pos1 + 1 : pos2 - pos1 - 1);

    pos3  = %scan(Semico : Zeile : pos2 + 1);
    part3 = %subst(Zeile : pos2 + 1 : pos3 - pos2 - 1);

    part4 = %subst(Zeile : pos3 + 1);


    // Set.Part1 = 'ARTNR: '           + I_CSVFILE.ARTINR;
    // Set.Part2 = 'ARTIKELBEZ: '      + I_CSVFILE.ARTIBEZ;
    // Set.Part3 = 'KILOPREIS: '       + I_CSVFILE.KPREISY;
    // Set.Part4 = 'QUALITAETSKLASSE: '+ I_CSVFILE.QUALIKLASS;


    O_OBSTPF.ARTNR   = Part1;
    O_OBSTPF.ARTBEZ  = Part2;
    O_OBSTPF.KPREIS  = %dec(Part3);
    O_OBSTPF.QUALKLS = %dec(Part4);

    WRITE Obstpf O_OBSTPF;

    READ CSVFILE I_CSVFILE;

  ENDDO;


  *inlr = *on;
end-proc;



// Prozedur erstellen fürs Parsen
// dcl-proc Parsen;
//   dcl-pi *n;
//   end-pi;
