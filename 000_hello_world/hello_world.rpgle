**free

dcl-s Name              char(30);
dcl-s Beispielname      varchar(30);
dcl-s Beispielbetrag    packed(4:2);
dcl-s Integerbeispiel   int(5);
dcl-s Randomflag        ind;
dcl-s Beispielsdatum    date;
dcl-s Beispielszeit     time;
dcl-s Zone              zoned(2);
dcl-s Unsigned          uns(5);
dcl-s Timestampbeispiel timestamp;


Name              = 'Christoph';
Beispielname      = 'Chris92';
Beispielbetrag    = 33,10;
Integerbeispiel   = 20;
Randomflag        = *on;
Beispielsdatum    = d'2025-09-18';
Beispielszeit     = t'14.11.00';
Timestampbeispiel = z'2025-09-18-14.11.00';
Zone              = 20;
Unsigned          = 10;


DSPLY Name;
DSPLY %char(Beispielname);
DSPLY %char(Integerbeispiel);
DSPLY %char(Beispielbetrag);
DSPLY %char(Randomflag);
DSPLY %char(Beispielsdatum);
DSPLY %char(Beispielszeit);
DSPLY %char(Zone);
DSPLY %char(Unsigned);
DSPLY %char(Timestampbeispiel);


*inlr = *on;
