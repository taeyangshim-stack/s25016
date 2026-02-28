MODULE Gantry_MainModule
! ============================================================
! Gantry_MainModule — PlanAB-Hybrid Stage1 v0.1.0
! ============================================================
! PlanA의 stCommand 프로토콜 + PlanB의 동적 각도 계산 지원
!
! PlanA-Restore와 동일한 TASK7 모듈이나,
! WeldsG_* 변수가 PlanB의 DefineWeldLine() 결과값으로 채워짐
! (TASK1의 BridgeToGantry()가 calcPosStart/End → WeldsG_* 변환 후 전송)
!
! 명령 집합:
!   "Weld"    → WeldsG_Start→End MoveExtJ (갠트리 주도 용접)
!   "MoveJgJ" → jGantry SyncMove (SyncMove 확장 준비)
!   "checkpos"→ 위치 확인
! ============================================================

    ! ----------------------------------------
    ! 공유 데이터 (PERS — TASK1/TASK2와 공유)
    ! ----------------------------------------
    PERS string stCommand := "";
    PERS string stReact{3};
    PERS num idSync := 7;
    PERS speeddata vSync;
    PERS zonedata zSync := [FALSE, 200, 300, 300, 30, 300, 30];

    ! 갠트리 용접 위치 (TASK1의 BridgeToGantry가 설정)
    PERS num WeldsG_StartX := 0;
    PERS num WeldsG_StartY := 0;
    PERS num WeldsG_StartZ := 0;
    PERS num WeldsG_StartR := 0;
    PERS num WeldsG_EndX   := 0;
    PERS num WeldsG_EndY   := 0;
    PERS num WeldsG_EndZ   := 0;
    PERS num WeldsG_EndR   := 0;
    PERS num WeldsG_Speed  := 10;

    ! 갠트리 홈/리미트
    PERS num nHomeGantryX := 9500;
    PERS num nHomeGantryY := 5300;
    PERS num nHomeGantryZ := 2100;
    PERS num nHomeGantryR := 0;
    PERS num nLimitX_Negative := -1000;
    PERS num nLimitX_Positive := 19000;
    PERS num nLimitY_Negative := -100;
    PERS num nLimitY_Positive := 10000;
    PERS num nLimitZ_Negative := -100;
    PERS num nLimitZ_Positive := 2100;
    PERS num nLimitR_Negative := -180;
    PERS num nLimitR_Positive := 180;
    PERS num nRobHeightMin    := 0;

    TASK VAR syncident Wait{100};
    TASK VAR intnum iMoveHome_Gantry;
    PERS bool bMoveHome_Gantry := FALSE;
    PERS num nMoveid := 0;
    TASK VAR syncident SynchronizeJGJon{9999};
    TASK VAR syncident SynchronizeJGJoff{9999};
    PERS jointtarget jGantry;
    CONST jointtarget jNull := [[0,0,0,0,0,0],[0,0,0,0,9E+09,0]];

    TRAP trapMoveHome_Gantry
        IDelete iMoveHome_Gantry;
        TPWrite "[GANTRY-H] trapMoveHome triggered";
        rMoveHome_Gantry;
    ENDTRAP

    FUNC jointtarget fnFloorToGantryJT(num fx, num fy, num fz, num fr)
        VAR jointtarget result;
        result := jNull;
        result.extax.eax_a := Limit(nLimitX_Negative, nLimitX_Positive,
                                    nHomeGantryX + (fx - 9500));
        result.extax.eax_b := Limit(nLimitY_Negative, nLimitY_Positive,
                                    nHomeGantryY - (fy - 5300));
        result.extax.eax_c := Limit(nLimitZ_Negative, nLimitZ_Positive - nRobHeightMin,
                                    nHomeGantryZ - (fz - 2100));
        result.extax.eax_d := Limit(nLimitR_Negative, nLimitR_Positive,
                                    nHomeGantryR - fr);
        result.extax.eax_e := 9E+09;
        result.extax.eax_f := result.extax.eax_a;
        RETURN result;
    ENDFUNC

    FUNC num Limit(num Min, num Max, num Target)
        VAR num result;
        result := Target;
        IF Target < Min result := Min;
        IF Max < Target result := Max;
        RETURN result;
    ENDFUNC

    PROC main()
        rInit;
        WHILE TRUE DO
            WaitUntil stCommand <> "";
            TEST stCommand
            CASE "Weld":
                rWeld;
            CASE "MoveJgJ":
                SyncMoveOn SynchronizeJGJon{nMoveid + 2}, taskGroup123;
                MoveExtJ jGantry \ID:=nMoveid+3, vSync, zSync;
                SyncMoveOff SynchronizeJGJoff{nMoveid + 4};
                stReact{3} := "Ack";
                WaitUntil stCommand = "";
                stReact{3} := "Ready";
            CASE "checkpos":
                stReact{3} := "checkposok";
                WaitUntil stCommand = "";
                stReact{3} := "Ready";
            DEFAULT:
                TPWrite "[GANTRY-H] Unknown command: " + stCommand;
                stReact{3} := "Error";
                WaitUntil stCommand = "";
                stReact{3} := "Ready";
            ENDTEST
        ENDWHILE
    ENDPROC

    PROC rInit()
        AccSet 20, 20;
        stReact{3} := "";
        WaitUntil stCommand = "";
        stReact{3} := "Ready";
        TPWrite "[GANTRY-H] Gantry_MainModule ready (Hybrid Stage1 v0.1.0)";
    ENDPROC

    PROC rWeld()
        VAR jointtarget jStart;
        VAR jointtarget jEnd;
        VAR speeddata vWeld;

        vWeld := [WeldsG_Speed, 500, WeldsG_Speed, 500];

        jStart := fnFloorToGantryJT(WeldsG_StartX, WeldsG_StartY,
                                     WeldsG_StartZ, WeldsG_StartR);
        jEnd   := fnFloorToGantryJT(WeldsG_EndX,   WeldsG_EndY,
                                     WeldsG_EndZ,   WeldsG_EndR);

        TPWrite "[GANTRY-H] rWeld: Start=[" + NumToStr(WeldsG_StartX,0)
            + "," + NumToStr(WeldsG_StartY,0) + "] R=" + NumToStr(WeldsG_StartR,1);
        TPWrite "[GANTRY-H] rWeld: End=[" + NumToStr(WeldsG_EndX,0)
            + "," + NumToStr(WeldsG_EndY,0) + "] R=" + NumToStr(WeldsG_EndR,1);

        WaitRob \ZeroSpeed;
        MoveExtJ jStart, v500, fine;
        TPWrite "[GANTRY-H] At start. Waiting WeldGo...";

        WaitUntil stCommand = "WeldGo" OR stCommand = "";
        IF stCommand = "" THEN
            stReact{3} := "Ready";
            RETURN ;
        ENDIF

        TPWrite "[GANTRY-H] Weld DRIVING (angle=" + NumToStr(WeldsG_StartR,1) + "deg)";
        MoveExtJ jEnd, vWeld, fine;
        WaitRob \inpos;

        TPWrite "[GANTRY-H] Weld COMPLETE";
        stReact{3} := "WeldOk";
        WaitUntil stCommand = "";
        stReact{3} := "Ready";
        AccSet 20, 20;
    ENDPROC

    PROC rMoveHome_Gantry()
        VAR jointtarget jHome;
        StopMove;
        ClearPath;
        StartMove;
        jHome := fnFloorToGantryJT(9500, 5300, 2100, 0);
        MoveExtJ jHome, v500, fine;
        stReact{3} := "Ready";
        TPWrite "[GANTRY-H] Returned to HOME";
    ENDPROC

ENDMODULE
