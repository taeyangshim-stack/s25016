MODULE Head_Function

    FUNC num CalcAngleFromPos(pos posPoint)
        VAR num nlengthToPoint;
        VAR num result;

        nlengthToPoint:=Sqrt(Pow(posPoint.x,2)+Pow(posPoint.y,2));

        IF (0<=posPoint.y) THEN
            result:=ACos(posPoint.x/nlengthToPoint);
        ELSE
            result:=360-ACos(posPoint.x/nlengthToPoint);
        ENDIF

        RETURN result;
    ENDFUNC

    FUNC robtarget CalcCurrentTcp(\switch R1|switch R2)
        VAR robtarget pTemp;
        VAR jointtarget jExt;
        VAR robtarget result:=[[0,0,0],[1,0,0,0],[0,0,0,0],[0,0,0,0,0,0]];

        jExt:=fnJointToCoord(CJointT(\taskname:="T_Gantry"));

        IF Present(R1)=TRUE pTemp:=CRobT(\taskname:="T_ROB1"\Tool:=tWeld1\WObj:=wobjRotCtr1);
        IF Present(R2)=TRUE pTemp:=CRobT(\taskname:="T_ROB2"\Tool:=tWeld2\WObj:=wobjRotCtr2);

        result.trans.x:=jExt.extax.eax_a+(pTemp.trans.x*Cos(jExt.extax.eax_d))-(pTemp.trans.y*Sin(jExt.extax.eax_d));
        result.trans.y:=jExt.extax.eax_b+(pTemp.trans.x*Sin(jExt.extax.eax_d))+(pTemp.trans.y*Cos(jExt.extax.eax_d));
        result.trans.z:=jExt.extax.eax_c-(-1*pTemp.trans.z);

        RETURN result;
    ENDFUNC

    FUNC pos CalcNormalVector(pos startPos,pos endPos)
        VAR pos result;
        VAR pos diffVector;
        VAR num length;

        diffVector:=endPos-startPos;
        nLengthWeldLine:=VectMagn(diffVector);
        IF diffVector.X=0 THEN
            diffVector.X:=0.1 ;
        ENDIF
                IF diffVector.Y=0 THEN
            diffVector.Y:=0.1 ;
        ENDIF
                IF diffVector.Z=0 THEN
            diffVector.Z:=0.1 ;
        ENDIF
        
        
        result.X:=diffVector.X/nLengthWeldLine;
        result.Y:=diffVector.Y/nLengthWeldLine;
        result.Z:=diffVector.Z/nLengthWeldLine;

        RETURN result;
    ENDFUNC

    FUNC pos CalcPosOnLine(pos Start,pos End,num Point)
        VAR pos result;
        VAR num nLineLength;

        nLineLength:=VectMagn(End-Start);
        result:=Start+((End-Start)*(Point/nLineLength));

        RETURN result;
    ENDFUNC

    FUNC jointtarget fnCoordToJoint(jointtarget joint)
        VAR jointtarget result;

        !!! [x1,y,z,r,9E+09,x2] -> [eax_a,eax_b,eax_c,eax_d,eax_e,eax_f] !!!
        result:=joint;

        result.extax.eax_a:=Limit(nLimitX_Negative,nLimitX_Positive,nHomeGantryX+joint.extax.eax_a);
        result.extax.eax_b:=Limit(nLimitY_Negative,nLimitY_Positive,nHomeGantryY-joint.extax.eax_b);
        result.extax.eax_c:=Limit(nLimitZ_Negative,nLimitZ_Positive-nRobHeightMin,nHomeGantryZ-joint.extax.eax_c);
        result.extax.eax_d:=Limit(nLimitR_Negative,nLimitR_Positive,nHomeGantryR-joint.extax.eax_d);
        result.extax.eax_e:=9E+09;
        result.extax.eax_f:=result.extax.eax_a;

        RETURN result;
    ENDFUNC

    FUNC jointtarget fnJointToCoord(jointtarget JointT)
        VAR jointtarget result;

        !!! [eax_a,eax_b,eax_c,eax_d,eax_e,eax_f] -> [x1,y,z,r,9E+09,x2] !!!
        result:=JointT;

        result.extax.eax_a:=(-nHomeGantryX+JointT.extax.eax_a);
        result.extax.eax_b:=(nHomeGantryY-JointT.extax.eax_b);
        result.extax.eax_c:=(nHomeGantryZ-JointT.extax.eax_c);
        result.extax.eax_d:=(nHomeGantryR-JointT.extax.eax_d);
        result.extax.eax_e:=9E+09;
        result.extax.eax_f:=result.extax.eax_a;

        RETURN result;
    ENDFUNC

    FUNC jointtarget fnPoseToExtax(robtarget RobT)
        VAR jointtarget result;

        !!! [x,y,z],[q1,q2,q3,q4] -> [eax_a,eax_b,eax_c,eax_d,eax_e,eax_f] !!!
        result:=jNull;

        result.extax.eax_a:=RobT.trans.x;
        result.extax.eax_b:=RobT.trans.y;
        result.extax.eax_c:=RobT.trans.z;
        result.extax.eax_d:=EulerZYX(\Z,RobT.rot);
        result.extax.eax_e:=9E+09;
        result.extax.eax_f:=result.extax.eax_a;

        RETURN result;
    ENDFUNC

    FUNC robtarget fnExtaxToPose(jointtarget JointT)
        VAR robtarget result;

        !!! [eax_a,eax_b,eax_c,eax_d,eax_e,eax_f] -> [x,y,z],[q1,q2,q3,q4] !!!
        result:=pNull;

        result.trans.x:=JointT.extax.eax_a;
        result.trans.y:=JointT.extax.eax_b;
        result.trans.z:=JointT.extax.eax_c;
        result.rot:=OrientZYX(JointT.extax.eax_d,0,0);

        RETURN result;
    ENDFUNC

    FUNC num DefineWeldPosOnBreakPoints(torchmotion lastMotion,INOUT robtarget pBreakTargetArray{*})
        RETURN 0;
    ENDFUNC

    FUNC num Limit(num Min,num Max,num Target)
        VAR num result;

        result:=Target;
        IF Target<Min result:=Min;
        IF Max<Target result:=Max;

        RETURN result;
    ENDFUNC

    FUNC jointgroup MergeJgWith(\jointtarget Rob1\jointtarget Rob2\jointtarget Gantry)
        VAR jointgroup result;
        nMoveid:=nMoveid+5;
        result.Joint1:=CJointT(\TaskName:="T_ROB1");
        result.Joint2:=CJointT(\TaskName:="T_ROB2");
        result.JointG:=CJointT(\TaskName:="T_Gantry");

        IF Present(Rob1)=TRUE result.Joint1:=Rob1;
        IF Present(Rob2)=TRUE result.Joint2:=Rob2;
        IF Present(Gantry)=TRUE result.JointG:=Gantry;

        RETURN result;
    ENDFUNC

    FUNC pointgroup MergePgWith(\robtarget Rob1\robtarget Rob2\robtarget Gantry)
        VAR pointgroup result;
        nMoveid:=nMoveid+5;
        result.point1:=CRobT(\TaskName:="T_ROB1"\tool:=tWeld1);
        result.point2:=CRobT(\TaskName:="T_ROB2"\tool:=tWeld2);
        result.PointG:=fnExtaxToPose(CJointT(\TaskName:="T_Gantry"));

        IF Present(Rob1)=TRUE result.point1:=Rob1;
        IF Present(Rob2)=TRUE result.point2:=Rob2;
        IF Present(Gantry)=TRUE result.PointG:=Gantry;
        RETURN result;
    ENDFUNC

    FUNC num NormalizeAngle(num angle,num limit)
        WHILE limit<=angle DO
            angle:=angle-(limit*2);
        ENDWHILE

        WHILE angle<-limit DO
            angle:=angle+(limit*2);
        ENDWHILE

        RETURN angle;
    ENDFUNC

    FUNC jointtarget ExtOffs(jointtarget joint,num x,num y,num z,\num r)
        VAR jointtarget result;

        result.robax:=joint.robax;

        result.extax.eax_a:=joint.extax.eax_a+x;
        result.extax.eax_b:=joint.extax.eax_b+y;
        result.extax.eax_c:=joint.extax.eax_c+z;
        result.extax.eax_d:=joint.extax.eax_d;
        IF Present(r)=TRUE result.extax.eax_d:=joint.extax.eax_d+r;
        result.extax.eax_e:=9E+09;
        result.extax.eax_f:=result.extax.eax_a;

        RETURN result;
    ENDFUNC

    FUNC robtarget CalcTouchTcp(robtarget T_ROB,jointtarget Gantry)
        VAR robtarget pRob;
        VAR num nGantryX;
        VAR num nGantryY;
        VAR num nGantryZ;
        VAR num nRobotX;
        VAR num nRobotY;
        VAR num gantryAngle;
        VAR robtarget result:=[[0,0,0],[1,0,0,0],[0,0,0,0],[0,0,0,0,0,0]];

        nGantryX:=Gantry.extax.eax_a;
        nGantryY:=Gantry.extax.eax_b;
        nGantryZ:=Gantry.extax.eax_c;
        gantryAngle:=Gantry.extax.eax_d;

        pRob:=T_ROB;

        nRobotX:=(pRob.trans.x*Cos(gantryAngle))-(pRob.trans.y*Sin(gantryAngle));
        nRobotY:=(pRob.trans.x*Sin(gantryAngle))+(pRob.trans.y*Cos(gantryAngle));

        result:=pRob;
        result.trans.x:=nGantryX+nRobotX;
        result.trans.y:=nGantryY+nRobotY;
        result.trans.z:=nGantryZ-((-1)*pRob.trans.z);

        RETURN result;
    ENDFUNC
ENDMODULE