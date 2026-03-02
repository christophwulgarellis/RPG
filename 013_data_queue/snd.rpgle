**free

ctl-opt                      dftactgrp(*no) actgrp(*caller) bnddir('AUFGABEN');

/Copy QPTTSRC,DTAQ

dcl-f Person                 disk usage(*input) rename(Person : PersonR);

dcl-ds i_Person              likerec(PersonR : *input) inz;
dcl-ds DtaqINFO              likeds(z_RDQD0100);
dcl-ds DtaqCfg               likeds(z_DtaqNamLib);
dcl-s DAValue                char(20) dtaara('KURS30/DQNAMLIB');


IN DAValue;
DtaqCfg.DtaqName = %subst(DAValue : 1 : 10);
DtaqCfg.DtaqLib  = %subst(DAValue : 11 : 10);

DSPLY ('Name=[' + %trim(DtaqCfg.DtaqName) +
        '] Lib=[' + %trim(DtaqCfg.DtaqLib ) + ']');

ClrDtaq(DtaqCfg.DtaqName : DtaqCfg.DtaqLib);

READ PERSON i_Person;

DOW NOT %eof(Person);

  MONITOR;
    SndToDtaq(
    DtaqCfg.DtaqName :
     %subst(i_Person : 1 : %size(i_Person)) :
    DtaqCfg.DtaqLib
    );

  ON-ERROR;

    DSPLY 'Sending Failed!';
    LEAVE;
  ENDMON;

  READ PERSON i_Person;

ENDDO;

*inlr = *on;




// STRSQL zum überprüfen:

// SELECT CURRENT_MESSAGES FROM QSYS2.DATA_QUEUE_INFO
// WHERE DATA_QUEUE_LIBRARY = 'KURS18' AND DATA_QUEUE_NAME =
// 'DTAQ1'



// DDS erstellen damit die DTAQ1 angezeigt wird
// am besten in ein array und dann ins subfile
// nur den bildschirm schreiben aber nicht lesen
// DTAQ -> ARR -> SFL -> DTAQCMD
