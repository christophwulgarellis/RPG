**free

ctl-opt                      dftactgrp(*no) actgrp(*caller) bnddir('AUFGABEN');

/Copy QPTTSRC,DTAQ

dcl-f Person                 disk usage(*input) rename(Person : PersonR);

dcl-ds r_Person              likerec(PersonR : *input) inz;
dcl-ds DtaqCfg               likeds(z_DtaqNamLib);
dcl-s dataLen                int(10);
dcl-s DAValue                char(20) dtaara('KURS30/DQNAMLIB');


IN DAValue;
DtaqCfg.DtaqName = %subst(DAValue : 1 : 10);
DtaqCfg.DtaqLib  = %subst(DAValue : 11 : 10);

DSPLY ('Name=[' + %trim(DtaqCfg.DtaqName) +
        '] Lib=[' + %trim(DtaqCfg.DtaqLib) + ']');


DOW *on;

  MONITOR;
    CLEAR r_Person;

    dataLen = RcvDtaq(
            DtaqCfg.DtaqName :
            0 :
            r_Person         :
            DtaqCfg.DtaqLib
            );

    IF dataLen = 0;
      LEAVE;
    ENDIF;

    SND-MSG ('Empfangene Länge: ' + %char(dataLen));

  ON-ERROR;
    DSPLY 'Receiving Failed!';
  LEAVE;

  ENDMON;
ENDDO;

*inlr = *on;




// SQL zum Testen:

//SELECT CURRENT_MESSAGES FROM QSYS2.DATA_QUEUE_INFO
// WHERE DATA_QUEUE_LIBRARY = 'KURS18' AND DATA_QUEUE_NAME =
// 'DTAQ1'


// -1 waittime means its "sleeping" - in Wrkactjob often seen as DEQW (Dequeue Wait)
// 0 is good for testing - just show me what is in DTAQ

// A Data Queue is a lightweight messaging mechanism between jobs on the same IBM i system.
