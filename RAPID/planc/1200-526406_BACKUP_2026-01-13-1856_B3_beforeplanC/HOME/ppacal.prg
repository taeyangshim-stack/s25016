%%%
  VERSION:1
  LANGUAGE:ENGLISH
%%%

MODULE PPACAL
  !***********************************************************
  !
  ! Module: PPACAL
  !
  ! Description
  !   Purpose of program module:
  !
  !   1) Prepare DSQC377 encoder board units
  !   CNV1, CNV2, etc for conveyor calibration.
  !
  !   2) Prepare indexed work areas for work object definition
  !
  ! Copyright (c) ABB Robotics Products AB 2000.  
  ! All rights reserved
  !
  !***********************************************************
  TASK PERS wobjdata WorkObject:=[FALSE,TRUE,"",[[0,0,0],[1,0,0,0]],[[0,0,0],[1,0,0,0]]];
  VAR mecunit CnvMecUnit;
  VAR string CnvMecString:="";
  VAR datapos block;
  VAR num CnvNum:=0;
  VAR num IndNum:=0;
  VAR num CalibType:=0;
  VAR num ConfirmSave:=0;
  VAR intnum NewObj;
  VAR bool NewObjReported:=FALSE;
  VAR signaldo doRemAllPObj;
  VAR signaldo doDropWObj;
  VAR signaldo doPosInJobQ;
  VAR signaldi diNewObjStrobe;
  VAR signaldo doSoftSyncSig;
  VAR signalgi giCntFromEnc;
  VAR signalgo goCntToEnc;
  VAR signaldo doForceJob;
  VAR signaldo doCntToEncStr;

  !========================== main ===========================
  PROC main()
    TPErase;
    CalibType:=0;
    WorkObject:=wobj0;
    CnvName:="";
    NonCnvWobjName:="";
    TPWrite "WHICH KIND OF CALIBRATION DO YOU WANT TO DO?";
    TPReadFK CalibType,"CONVEYOR OR FIXED/INDEXED","","","","Cnv","Ind";
    IF CnvName<>"" OR CalibType=4 THEN
      TPWrite "Vision to robot calibration.";
      TPWrite "DSQC377 version.";
      TPReadFK CnvNum,"Choose conveyor","CNV1","CNV2","CNV3","CNV4","MORE";
      IF CnvNum=5 THEN
        TPReadFK CnvNum,"Choose conveyor","CNV5","CNV6","","","";
        CnvNum:=CnvNum+4;
      ENDIF
      CnvName:="CNV"+ValToStr(CnvNum);
      GetDataVal "c"+ValToStr(CnvNum)+"RemAllPObj",doRemAllPObj;
      GetDataVal "c"+ValToStr(CnvNum)+"DropWObj",doDropWObj;
      GetDataVal "c"+ValToStr(CnvNum)+"PosInJobQ",doPosInJobQ;
      GetDataVal "c"+ValToStr(CnvNum)+"NewObjStrobe",diNewObjStrobe;
      GetDataVal "c"+ValToStr(CnvNum)+"SoftSyncSig",doSoftSyncSig;
      GetDataVal "c"+ValToStr(CnvNum)+"CntFromEnc",giCntFromEnc;
      GetDataVal "c"+ValToStr(CnvNum)+"CntToEnc",goCntToEnc;
      GetDataVal "c"+ValToStr(CnvNum)+"ForceJob",doForceJob;
      GetDataVal "c"+ValToStr(CnvNum)+"CntToEncStr",doCntToEncStr;
      SetDataSearch "mecunit"\Object:=CnvName;
      IF GetNextSym(CnvMecString,block) THEN
        GetDataVal CnvMecString\Block:=block,CnvMecUnit;
      ELSE
        ErrWrite "UNKNOWN CONVEYOR",CnvName\RL2:="is an unknown conveyor name. Look in"\RL3:="the MOC configuration file for"\RL4:="valid conveyor names.";
        Stop;
      ENDIF
      WorkObject.ufmec:=CnvName;
      WorkObject.ufprog:=FALSE;
      TPWrite "DELETING OBJECTS FROM CNV"+ValToStr(CnvNum);
      NewObjReported:=FALSE;
      IDelete NewObj;
      SetDO doRemAllPObj,0;
      SetDO doDropWObj,0;
      WaitTime 0.5;
      PulseDO doRemAllPObj;
      WaitTime 0.5;
      PulseDO doDropWObj;
      WaitTime 0.5;
      SetDO doPosInJobQ,1;
      ActUnit CnvMecUnit;
      WaitTime 0.5;
      ppaDropWObj WorkObject;
      WaitTime 0.5;
      !
      TPWrite "WAITING FOR TRAP ON CNV"+ValToStr(CnvNum);
      CONNECT NewObj WITH ObjTrap;
      ISignalDI diNewObjStrobe,1,NewObj;
      PulseDO doSoftSyncSig;
      WaitUntil NewObjReported=TRUE;
      SetSysData Gripper;
      SetSysData WorkObject;
      TPWrite "CNV"+ValToStr(CnvNum)+" READY FOR CALIB";
      WaitTime 3;
    ELSEIF NonCnvWobjName<>"" OR CalibType=5 THEN
      TPWrite "Vision to robot calibration.";
      TPReadFK IndNum,"Choose WorkObject","IdxWobj1","IdxWobj2","IdxWobj3","IdxWobj4","MORE";
      IF IndNum=5 THEN
        TPReadFK IndNum,"Choose WorkObject","IdxWobj5","IdxWobj6","IdxWobj7","IdxWobj8","MORE";
        IndNum:=IndNum+4;
        IF IndNum=9 THEN
          TPReadFK IndNum,"Choose WorkObject","IdxWobj9","IdxWobj10","IdxWobj11","IdxWobj12","MORE";
          IndNum:=IndNum+8;
          IF IndNum=13 THEN
            TPReadFK IndNum,"Choose WorkObject","IdxWobj13","IdxWobj14","IdxWobj15","IdxWobj16","MORE";
            IndNum:=IndNum+12;
            IF IndNum=17 THEN
              TPReadFK IndNum,"Choose WorkObject","IdxWobj17","IdxWobj18","IdxWobj19","IdxWobj20","MORE";
              IndNum:=IndNum+16;
              IF IndNum=21 THEN
                TPReadFK IndNum,"Choose WorkObject","IdxWobj21","IdxWobj22","IdxWobj23","IdxWobj24","IdxWobj25";
                IndNum:=IndNum+20;
              ENDIF
            ENDIF
          ENDIF
        ENDIF
      ENDIF
      NonCnvWobjName:="IdxWobj"+ValToStr(IndNum);
      SetSysData Gripper;
      SetSysData WorkObject;
      TPWrite "DEFINE CURRENT WORKOBJECT";
      TPWrite " ";
      TPWrite "CONTINUE RAPID EXECUTION WHEN READY";
      TPWrite "TO SAVE THE NEW WORKOBJECT DEFINITION";
      WaitTime 2;
      Stop;
      TPWrite " ";
      TPReadFK ConfirmSave,"DO YOU WANT TO SAVE THIS WOBJ DEF?","","","","Yes","No";
      IF ConfirmSave=4 THEN
        FOR i FROM 1 TO MaxNoSources DO
          IF NonCnvWOData{i}.NonCnvWobjName=NonCnvWobjName THEN
            NonCnvWOData{i}.Used:=TRUE;
            NonCnvWOData{i}.Wobj:=WorkObject;
          ENDIF
        ENDFOR
        Save "ppaUser"\FilePath:=diskhome\File:="ppaUser.sys";
      ENDIF
    ENDIF
  ENDPROC

  !======================== ObjTrap =========================
  TRAP ObjTrap
    TPWrite "RESETTING POSITION FOR CNV"+ValToStr(CnvNum);
    WaitTime 0.2;
    SetGO goCntToEnc,GInputDnum(giCntFromEnc);
    WaitTime 0.2;
    PulseDO doForceJob;
    PulseDO doCntToEncStr;
    NewObjReported:=TRUE;
    RETURN;
  ENDTRAP
ENDMODULE

