MODULE Teaching
    ! ========================================
    ! T_Teaching - Real-time Weld Parameter Monitor
    ! Ported from PlanA TASK10 for UI compatibility
    ! ========================================
    ! Purpose: Calculate and expose current target weld
    !          parameters (voltage, WFS) for upper UI display.
    ! UI reads: nCurrentTargetVoltage, nCurrentTargetWfs
    ! UI writes: nRealTimeVoltage, nRealTimeWfs (real-time adjust)
    ! ========================================

    RECORD targetdata
        robtarget position;
        num cpm;
        num schedule;
        num voltage;
        num wfs;
        num Current;
        num WeaveShape;
        num WeaveType;
        num WeaveLength;
        num WeaveWidth;
        num WeaveDwellLeft;
        num WeaveDwellRight;
        num TrackType;
        num TrackGainY;
        num TrackGainZ;
        num MaxCorr;
        num Bias;
    ENDRECORD

    ! --- UI-Required PERS Variables ---
    pers num nCurrentTargetVoltage{2};
    pers num nCurrentTargetWfs{2};
    PERS targetdata Welds1{40};
    PERS targetdata Welds2{40};
    PERS num nRunningStep{2};
    PERS num nRealTimeVoltage{2};
    PERS num nRealTimeWfs{2};
    PERS bool bArc_On{2};

    PROC main()
        rCurrentTargetUpData;
    ENDPROC

    PROC rCurrentTargetUpData()
        IF (siLn1Current=1 AND siLn1TouchActive=0) OR bArc_On{1}=TRUE THEN
            nCurrentTargetVoltage{1}:=Welds1{nRunningStep{1}}.voltage+nRealTimeVoltage{1};
            nCurrentTargetWfs{1}:=Welds1{nRunningStep{1}}.wfs+nRealTimeWfs{1};
        ELSE
            nCurrentTargetVoltage{1}:=0;
            nCurrentTargetWfs{1}:=0;
        ENDIF
        IF (siLn2Current=1 AND siLn2TouchActive=0) OR bArc_On{2}=TRUE THEN
            nCurrentTargetVoltage{2}:=Welds2{nRunningStep{2}}.voltage+nRealTimeVoltage{2};
            nCurrentTargetWfs{2}:=Welds2{nRunningStep{2}}.wfs+nRealTimeWfs{2};
        ELSE
            nCurrentTargetVoltage{2}:=0;
            nCurrentTargetWfs{2}:=0;
        ENDIF
        IF pi53_SetTeachingPoint=1 reset po53_SetTeachingPoint;
    ENDPROC
ENDMODULE
