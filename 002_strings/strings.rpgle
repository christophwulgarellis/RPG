**free

dcl-s X            varchar(50);
dcl-s Text2        varchar(50);
dcl-s OutputText   varchar(50);
dcl-s Numberblanks int(20);


//Text1 = 'KurzerText';

Text2 = 'Das ist ein ganz langer langer Text';
//Text(3) = 'Dieses Feld soll Maximal mit Text ausgefüllt sein!';
//Text(4) = '          ';
//Text(5) = '     vor diesem Text stehen 5 Blanks!';


OutputText = %trim(Text2);                              // Länge des Textes (ohne Leerzeichen außen)

X = '                    ';


Numberblanks = %div(%len(OutputText : *Max) - %len(OutputText) : 2);
// 50 Maximalchars - dem getrimten Text (bei Text1 10 Zeichen) = 40 / 2 = 20


OutputText = %subst(X : 1 : Numberblanks) + %trim(OutputText) + %subst(X : 1 : Numberblanks);


DSPLY OutputText;


*inlr = *on;
