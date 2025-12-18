MODULE Static
    PROC main()
        updateCurrentPosition;
    ENDPROC
    
    PROC updateCurrentPosition()
        VAR jointtarget jointTemp;
        jointTemp:=CJointT(\TaskName:="T_Rob1");
        SetAO cgo05_AxisX_Current,round(jointTemp.extax.eax_a)+9500;
        !
!        VAR jointtarget jct1;
!        VAR jointtarget jct2;
!        VAR robtarget pct1;
!        VAR robtarget pct2;

!        MonitorPosition.monExt:=ConvertJointToExtCoord(CJointT(\TaskName:="T_Gantry"));
!        jct1:=CJointT(\TaskName:="T_ROB1");
!        jct2:=CJointT(\TaskName:="T_ROB2");
!        pct1:=CalcCurrentTcp(\R1);
!        pct2:=CalcCurrentTcp(\R2);

!        MonitorPosition.monJoint1:=jct1.robax;
!        MonitorPosition.monJoint2:=jct2.robax;

!        MonitorPosition.monPose1.trans:=pct1.trans;
!        MonitorPosition.monPose1.rot:=pct1.rot;

!        MonitorPosition.monPose2.trans:=pct2.trans;
!        MonitorPosition.monPose2.rot:=pct2.rot;

!        SetAO cgo05_AxisX_Current,Round(MonitorPosition.monExt.eax_a);
!        RETURN ;
    ENDPROC
    
!    FUNC extjoint ConvertJointToExtCoord(jointtarget joint)
!        VAR extjoint result;

!        result:=joint.extax;

!        result.eax_a:=Round((-nHomeGantryX+joint.extax.eax_a)\Dec:=2);
!        result.eax_b:=Round((nHomeGantryY-joint.extax.eax_b)\Dec:=2);
!        result.eax_c:=Round((nHomeGantryZ-joint.extax.eax_c)\Dec:=2);
!        result.eax_d:=Round((nHomeGantryR-joint.extax.eax_d)\Dec:=2);
!        result.eax_e:=9E+09;
!        result.eax_f:=result.eax_a;

!        RETURN result;
!    ENDFUNC
ENDMODULE