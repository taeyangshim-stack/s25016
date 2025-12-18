MODULE PREPARECALIB
  !***********************************************************
  !
  ! Module: PREPARECALIB
  !
  ! Description
  !   Purpose of program module:
  !
  !   1) Prepare conveyor work areas
  !   CNV1, CNV2, etc for calibration.
  !
  !   2) Prepare indexed work areas for work object definition
  !
  ! Copyright (c) ABB Robotics Products AB 2018.  
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
  VAR signaldo doCntToEncStr;
  VAR signaldo doNewObjStrobe;
  VAR signaldo doRemAllPObj;
  VAR signaldo doDropWObj;
  VAR signaldo doPosInJobQ;
  VAR signaldo doSoftSync;
  VAR signalao aoPosition;

  !========================== main ===========================
  PROC main()
    TPErase;
    CalibType:=0;
    WorkObject:=wobj0;
    CnvName:="";
    NonCnvWobjName:="";
    TPWrite "Prepare a work area for calibration.";
    TPReadFK CalibType,"Select work area type","","","Lin CNV","Circ CNV","Stationary";
    IF CnvName<>"" OR CalibType=3 OR CalibType=4 THEN
      TPReadFK CnvNum,"Choose conveyor work area","CNV1","CNV2","CNV3","CNV4","MORE";
      IF CnvNum=5 THEN
        TPReadFK CnvNum,"Choose conveyor work area","CNV5","CNV6","","","";
        CnvNum:=CnvNum+4;
      ENDIF
      CnvName:="CNV"+ValToStr(CnvNum);
      GetDataVal "c"+ValToStr(CnvNum)+"RemAllPObj",doRemAllPObj;
      GetDataVal "c"+ValToStr(CnvNum)+"DropWObj",doDropWObj;
      GetDataVal "c"+ValToStr(CnvNum)+"PosInJobQ",doPosInJobQ;
      GetDataVal "c"+ValToStr(CnvNum)+"SoftSync",doSoftSync;
      GetDataVal "c"+ValToStr(CnvNum)+"CntToEncStr",doCntToEncStr;
      GetDataVal "c"+ValToStr(CnvNum)+"NewObjStrobe",doNewObjStrobe;
      GetDataVal "c"+ValToStr(CnvNum)+"Position",aoPosition;
      SetDataSearch "mecunit"\Object:=CnvName;
      IF GetNextSym(CnvMecString,block) THEN
        GetDataVal CnvMecString\block:=block,CnvMecUnit;
      ELSE
        ErrWrite "Selected conveyor work area is not installed",CnvName;
        Stop;
      ENDIF
      WorkObject.ufmec:=CnvName;
      WorkObject.ufprog:=FALSE;
      TPWrite "Deleting objects from CNV"+ValToStr(CnvNum);
      NewObjReported:=FALSE;
      IDelete NewObj;
      SetDO doNewObjStrobe,0;
      SetDO doCntToEncStr,0;
      SetDO doRemAllPObj,0;
      SetDO doDropWObj,0;
      WaitTime 0.5;
      PulseDO doRemAllPObj;
      WaitTime 0.5;
      PulseDO doDropWObj;
      WaitTime 0.5;
      SetDO doPosInJobQ,1;
      ActUnit CnvMecUnit;
      TPWrite "Activating CNV"+ValToStr(CnvNum);
      WaitTime 0.5;
      ppaDropWobj WorkObject;
      WaitTime 0.5;
      !
      CONNECT NewObj WITH ObjTrap;
      ISignalDO doCntToEncStr,1,NewObj;
      PulseDO doNewObjStrobe;
      WaitUntil NewObjReported=TRUE;
      SetSysData Gripper;
      SetSysData WorkObject;
      TPWrite "CNV"+ValToStr(CnvNum)+" is prepared for calibration";
    ELSEIF NonCnvWobjName<>"" OR CalibType=5 THEN
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
      TPWrite "Define current work object";
      TPWrite " ";
      TPWrite "Continue rapid execution when ready";
      TPWrite "to save the work object definition";
      WaitTime 2;
      Stop;
      TPWrite " ";
      TPReadFK ConfirmSave,"Do you want to save this work object definition ?","","","","Yes","No";
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
    IF CalibType=4 THEN
      CalcCircularBase;
    ENDIF
    Stop;
  ENDPROC

  !======================== ObjTrap =========================
  TRAP ObjTrap
    TPWrite "Resetting position for CNV"+ValToStr(CnvNum);
    TPWrite "Position = "\num:=AOutput(aoPosition);
    WaitTime 0.2;
    NewObjReported:=TRUE;
    RETURN ;
  ENDTRAP

  !==========================================================================
  !=================== CIRCULAR CONVEYOR ====================================
  !==========================================================================

  PROC CalcCircularBase()
    CONST string RotationSelection{2}:=["Clockwise","Counter clockwise"];
    VAR btnres Rotation;
    VAR robtarget pp1;
    VAR robtarget PP2;
    VAR robtarget PP3;
    VAR robtarget resultpos;
    VAR robtarget tmprt;
    VAR num angleoffset;
    VAR num camdistance;
    VAR num x1;
    VAR num x2;
    VAR num y1;
    VAR num y2;
    VAR num cnvrot;

    !================================
    ! Set Reference Baseframe
    !================================
    Rotation:=UIMessageBox(\Header:="Select rotation"\Message:="Select which direction the circular conveyor rotates"\BtnArray:=RotationSelection);
    IF Rotation=1 THEN
      resultpos.rot.q1:=0;
      resultpos.rot.q2:=1;
      resultpos.rot.q3:=0;
      resultpos.rot.q4:=0;
      TPWrite "Clockwise rotation";
    ELSE
      resultpos.rot.q1:=1;
      resultpos.rot.q2:=0;
      resultpos.rot.q3:=0;
      resultpos.rot.q4:=0;
      TPWrite "Counter clockwise rotation";
    ENDIF
    !================================
    ! place calib paper
    !================================
    TPWrite "---------------------------------------";
    TPWrite "Put calibration grid in zero pos.";
    TPWrite "THEN";
    !================================
    ! jog to camera
    !================================
    TPWrite "Jog the calibration grid to the camera.";
    TPWrite "";
    TPWrite "Then press the play button";
    Stop;
    !================================
    !   read cnv angle and calculate bf orient
    !================================
    angleoffset:=ReadCnvAngle(CnvNum);
    ! do needed conversion to angle.
    angleoffset:=Round(angleoffset*180/3.141592\Dec:=2);
    resultpos:=RelTool(resultpos,0,0,0\Rz:=angleoffset);
    TPWrite "Baseframe rotation relative to robot:";
    TPWrite "anglex :="\num:=EulerZYX(\X,resultpos.rot);
    TPWrite "angley :="\num:=EulerZYX(\Y,resultpos.rot);
    TPWrite "anglez :="\num:=EulerZYX(\Z,resultpos.rot);
    TPWrite "-------------------------------------";
    !================================
    ! jog to first robot pos
    !================================
    TPWrite "";
    TPWrite "jog to pos 1";
    TPWrite "Then press play the button";
    Stop;
    pp1:=CRobT(\Tool:=Gripper\WObj:=wobj0);
    !================================
    ! jog to second robot pos
    !================================
    TPWrite "jog to pos 2";
    TPWrite "Then press play the button";
    Stop;
    PP2:=CRobT(\Tool:=Gripper\WObj:=wobj0);
    !================================
    ! jog to third robot pos
    !================================
    TPWrite "jog to pos 3";
    TPWrite "Then press play the button";
    Stop;
    PP3:=CRobT(\Tool:=Gripper\WObj:=wobj0);

    !================================
    !   calculate bf pos
    !================================
    PP2.trans.z:=pp1.trans.z;
    PP3.trans.z:=pp1.trans.z;
    tmprt:=cirCntrPM(pp1,PP2,PP3);
    resultpos.trans:=tmprt.trans;
    !================================
    ! update baseframe
    !================================
    WriteCnvBF CnvNum,resultpos;
    !================================
    ! Calculate and display camera origo offset from center of table.
    !================================
    x1:=pp1.trans.x;
    y1:=pp1.trans.y;
    x2:=resultpos.trans.x;
    y2:=resultpos.trans.y;
    camdistance:=Sqrt(((x2-x1)*(x2-x1))+((y2-y1)*(y2-y1)));
    TPWrite "---------------------------------------";
    TPWrite "CAMERA OFFSET FROM CENTER="\num:=camdistance;
    !================================
    ! Write sensor offset
    !================================
    WriteCfgData "/PROC/CONVEYOR/CNV"+ValToStr(CnvNum),"sensor_offset",camdistance;
    TPWrite "---------------------------------------";
    TPWrite "Calibration ready";
    TPWrite "Restart the system";
  ENDPROC

  FUNC robtarget cirCntrPM(
    robtarget p1,
    robtarget p2,
    robtarget p3)

    VAR pos p12;
    VAR pos p13;
    VAR pos p23;
    VAR pos k2;
    VAR pos pn12;
    VAR pos pn13;
    VAR num a;
    VAR num b;
    VAR num ai;
    VAR num bi;
    VAR num c;
    VAR num d;
    VAR num s;
    VAR num r;
    VAR num kl;
    VAR robtarget p0;

    p12:=p2.trans-p1.trans;
    p13:=p3.trans-p1.trans;
    p23:=p3.trans-p2.trans;
    a:=VectMagn(p12);
    b:=VectMagn(p13);
    c:=VectMagn(p23);
    s:=(a+b+c)/2;
    ai:=1/a;
    bi:=1/b;
    r:=0.25*a*b*c/Sqrt(s*(s-a)*(s-b)*(s-c));
    IF a>b THEN
      p23:=p13;
      p13:=p12;
      p12:=p23;
      a:=b;
    ENDIF
    pn12:=p12*ai;
    pn13:=p13*bi;
    k2:=pn12*pn13*pn12;
    kl:=1/VectMagn(k2);
    k2:=kl*k2;
    d:=Sqrt(r*r-a*a/4);
    p0:=p1;
    p0.trans:=p1.trans+0.5*p12+d*k2;
    RETURN p0;
  ENDFUNC

  PROC WriteCnvBF(num cnvIndex,robtarget bfpose)
    VAR string tmpStr;

    tmpStr:="/MOC/SINGLE/CNV"+ValToStr(cnvIndex);
    WriteCfgData tmpStr,"base_frame_orient_u0",bfpose.rot.q1;
    WriteCfgData tmpStr,"base_frame_orient_u1",bfpose.rot.q2;
    WriteCfgData tmpStr,"base_frame_orient_u2",bfpose.rot.q3;
    WriteCfgData tmpStr,"base_frame_orient_u3",bfpose.rot.q4;
    TPWrite "----------------------------";
    TPWrite "anglex :="\num:=EulerZYX(\X,bfpose.rot);
    TPWrite "angley :="\num:=EulerZYX(\Y,bfpose.rot);
    TPWrite "anglez :="\num:=EulerZYX(\Z,bfpose.rot);
    TPWrite "";
    TPWrite "q1="\num:=bfpose.rot.q1;
    TPWrite "q2="\num:=bfpose.rot.q2;
    TPWrite "q3="\num:=bfpose.rot.q3;
    TPWrite "q4="\num:=bfpose.rot.q4;

    WriteCfgData tmpStr,"base_frame_pos_x",bfpose.trans.x/1000;
    WriteCfgData tmpStr,"base_frame_pos_y",bfpose.trans.y/1000;
    WriteCfgData tmpStr,"base_frame_pos_z",bfpose.trans.z/1000;
  ENDPROC

  FUNC pose ReadCnvBF(num cnvIndex)
    VAR pose CnvPose;
    VAR pose CnvPoseInv;
    VAR string tmpStr;
    VAR num NumPos;
    VAR num baseFrameAngle;

    tmpStr:="/MOC/SINGLE/CNV"+ValToStr(cnvIndex);
    ReadCfgData tmpStr,"base_frame_orient_u0",CnvPose.rot.q1;
    ReadCfgData tmpStr,"base_frame_orient_u1",CnvPose.rot.q2;
    ReadCfgData tmpStr,"base_frame_orient_u2",CnvPose.rot.q3;
    ReadCfgData tmpStr,"base_frame_orient_u3",CnvPose.rot.q4;
    baseFrameAngle:=EulerZYX(\Z,CnvPose.rot);
    ReadCfgData tmpStr,"base_frame_pos_x",CnvPose.trans.x;
    ReadCfgData tmpStr,"base_frame_pos_y",CnvPose.trans.y;
    ReadCfgData tmpStr,"base_frame_pos_z",CnvPose.trans.z;
    CnvPose.trans.x:=CnvPose.trans.x*1000;
    CnvPose.trans.y:=CnvPose.trans.y*1000;
    CnvPose.trans.z:=CnvPose.trans.z*1000;
    ! CnvPoseInv:=PoseInv(CnvPose);
    RETURN CnvPose;
  ENDFUNC

  FUNC num ReadCnvAngle(num cnvIndex)
    VAR num CnvPos;
    VAR string EncoderSystem:="";
    VAR string tmpStr;
    CONST string Cnv1PosSigName:="c1Position";
    CONST string Cnv2PosSigName:="c2Position";
    CONST string Cnv3PosSigName:="c3Position";
    CONST string Cnv4PosSigName:="c4Position";
    CONST string Cnv5PosSigName:="c5Position";
    CONST string Cnv6PosSigName:="c6Position";
    VAR signalao aoCnv1Position;
    VAR signalao aoCnv2Position;
    VAR signalao aoCnv3Position;
    VAR signalao aoCnv4Position;
    VAR signalao aoCnv5Position;
    VAR signalao aoCnv6Position;
    VAR signalai aiCnv1Position;
    VAR signalai aiCnv2Position;
    VAR signalai aiCnv3Position;
    VAR signalai aiCnv4Position;
    VAR signalai aiCnv5Position;
    VAR signalai aiCnv6Position;

    ReadCfgData "/PROC/CONVEYOR/CNV1","sensor_type",tmpStr;
    EncoderSystem:=tmpStr;
    TEST cnvIndex
    CASE 1:
      IF EncoderSystem="ICI" THEN
        AliasIO Cnv1PosSigName,aoCnv1Position;
      ELSE
        AliasIO Cnv1PosSigName,aiCnv1Position;
      ENDIF
      CnvPos:=aoCnv1Position;
    CASE 2:
      IF EncoderSystem="ICI" THEN
        AliasIO Cnv2PosSigName,aoCnv2Position;
      ELSE
        AliasIO Cnv2PosSigName,aiCnv2Position;
      ENDIF
      CnvPos:=aoCnv2Position;
    CASE 3:
      IF EncoderSystem="ICI" THEN
        AliasIO Cnv3PosSigName,aoCnv3Position;
      ELSE
        AliasIO Cnv3PosSigName,aiCnv3Position;
      ENDIF
      CnvPos:=aoCnv3Position;
    CASE 4:
      IF EncoderSystem="ICI" THEN
        AliasIO Cnv4PosSigName,aoCnv4Position;
      ELSE
        AliasIO Cnv4PosSigName,aiCnv4Position;
      ENDIF
      CnvPos:=aoCnv4Position;
    CASE 5:
      IF EncoderSystem="ICI" THEN
        AliasIO Cnv5PosSigName,aoCnv5Position;
      ELSE
        AliasIO Cnv5PosSigName,aiCnv5Position;
      ENDIF
      CnvPos:=aoCnv5Position;
    CASE 6:
      IF EncoderSystem="ICI" THEN
        AliasIO Cnv6PosSigName,aoCnv6Position;
      ELSE
        AliasIO Cnv6PosSigName,aiCnv6Position;
      ENDIF
      CnvPos:=aoCnv6Position;
    ENDTEST
    RETURN CnvPos;
  ENDFUNC
ENDMODULE
