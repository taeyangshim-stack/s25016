MODULE Gantry_CheckPrecision
    PERS num nInspectCount:=144;
    PERS num nInspectXX:=-10000;
    PERS num nInspectYY:=0;
    PERS num nInspectZZ:=0;
    
    PERS jointtarget jposTemp:=[[0,90,-35,0,0,0],[-10000,-10000,6000,1300,9E+09,9E+09]];
    PERS jointtarget jposTemp10:=[[0,90,-35,0,0,0],[-7450.79,-7450.79,1000,0,9E+09,9E+09]];
    PERS jointtarget jposTemp20:=[[0.000766619,89.9933,-35.0031,0.000519124,-0.00112396,0.00322118],[-9758.88,-9758.88,5185.75,1456.82,9E+09,9E+09]];
    PERS jointtarget jposTemp30:=[[0,0,0,0,0,0],[0,0,6000,0,9E+09,9E+09]];
    PERS jointtarget jposTemp40:=[[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]];
    PERS jointtarget jposTemp50:=[[0,-29.03,-22.5409,0.0536556,-38.3559,3.66529],[825.987,825.988,3565.98,1078.18,9E+09,9E+09]];
    PERS jointtarget jposTemp60:=[[0,0,0,0,0,0],[-10200,-10200,0,0,9E+09,9E+09]];

    LOCAL PERS robtarget pInspectTcpModify:=[[924.52,499.35,150],[4.06921E-06,-0.940215,-3.21431E-05,-0.340582],[0,-1,0,1],[500,500,5500,762.637,9E+09,9E+09]];

    PROC rInspectWithSmr2()
        VAR jointtarget Jtemp;
        VAR num nInspectPatternZpos;       
        VAR num nInspectPatternZneg;

        AccSet 25,25;
        VelSet 100,300;

        jTemp:=[[0,0,0,0,0,0],[nInspectXX,nInspectXX,nInspectYY,nInspectZZ,9E+9,9E+09]];
        MoveExtJ jTemp,V1000,fine;

        FOR nInspectPatternZpos FROM 1 TO 2 DO

            nInspectZZ:=nInspectZZ+700;
            jTemp.extax:=[nInspectXX,nInspectXX,nInspectYY,nInspectZZ,9E+9,9E+09];
            MoveExtJ jTemp,V1000,fine;
        ENDFOR

        IF nInspectYY>5999 THEN
            nInspectXX:=(nInspectXX+1000);
            nInspectYY:=0;
            nInspectZZ:=0;
            jTemp.extax:=[nInspectXX,nInspectXX,nInspectYY,nInspectZZ,9E+9,9E+09];
            MoveExtJ jTemp,V1000,fine;
            RETURN ;
        ENDIF

        nInspectYY:=nInspectYY+1000;
        jTemp.extax:=[nInspectXX,nInspectXX,nInspectYY,nInspectZZ,9E+9,9E+09];
        MoveExtJ jTemp,V1000,fine;

        FOR nInspectPatternZneg FROM 1 TO 2 DO

            nInspectZZ:=nInspectZZ-700;
            jTemp.extax:=[nInspectXX,nInspectXX,nInspectYY,nInspectZZ,9E+9,9E+09];
            MoveExtJ jTemp,V1000,fine;
        ENDFOR

        nInspectYY:=nInspectYY+1000;
        jTemp.extax:=[nInspectXX,nInspectXX,nInspectYY,nInspectZZ,9E+9,9E+09];
        MoveExtJ jTemp,V1000,fine;
        RETURN ;
    ENDPROC

    PROC rInspectWithSmr()
        VAR jointtarget jTemp;
        VAR num nInspectPatternX;
        VAR num nInspectPatternYZ;
        VAR num nInspectR;
        VAR num nInspectX;
        VAR num nInspectY;
        VAR num nInspectZ;

        AccSet 25,25;
        VelSet 100,600;
        jTemp:=[[0,0,0,0,0,0],[0,0,0,0,9E+09,0]];
        nInspectPatternX:=nInspectCount DIV 18;
        nInspectPatternYZ:=(nInspectCount MOD 18)+1;

        TEST nInspectPatternYZ
        CASE 1:
            nInspectX:=0;
            nInspectY:=0;
            nInspectZ:=0;

        CASE 2:
            nInspectX:=0;
            nInspectY:=0;
            nInspectZ:=500;

        CASE 3:
            nInspectX:=0;
            nInspectY:=0;
            nInspectZ:=1000;

        CASE 4:
            nInspectX:=0;
            nInspectY:=1100;
            nInspectZ:=1000;

        CASE 5:
            nInspectX:=0;
            nInspectY:=1100;
            nInspectZ:=500;

        CASE 6:
            nInspectX:=0;
            nInspectY:=1100;
            nInspectZ:=0;

        CASE 7:
            nInspectX:=0;
            nInspectY:=2200;
            nInspectZ:=0;

        CASE 8:
            nInspectX:=0;
            nInspectY:=2200;
            nInspectZ:=500;

        CASE 9:
            nInspectX:=0;
            nInspectY:=2200;
            nInspectZ:=1000;

        CASE 10:
            nInspectX:=0;
            nInspectY:=3300;
            nInspectZ:=1000;

        CASE 11:
            nInspectX:=0;
            nInspectY:=3300;
            nInspectZ:=500;

        CASE 12:
            nInspectX:=0;
            nInspectY:=3300;
            nInspectZ:=0;

        CASE 13:
            nInspectX:=0;
            nInspectY:=4400;
            nInspectZ:=0;

        CASE 14:
            nInspectX:=0;
            nInspectY:=4400;
            nInspectZ:=500;

        CASE 15:
            nInspectX:=0;
            nInspectY:=4400;
            nInspectZ:=1000;

        CASE 16:
            nInspectX:=0;
            nInspectY:=5500;
            nInspectZ:=1000;

        CASE 17:
            nInspectX:=0;
            nInspectY:=5500;
            nInspectZ:=500;

        CASE 18:
            nInspectX:=0;
            nInspectY:=5500;
            nInspectZ:=0;

        CASE 19:
            nInspectX:=0;
            nInspectY:=6000;
            nInspectZ:=0;

        CASE 20:
            nInspectX:=0;
            nInspectY:=6000;
            nInspectZ:=500;

        CASE 21:
            nInspectX:=0;
            nInspectY:=6000;
            nInspectZ:=1000;

        ENDTEST

        nInspectX:=(nInspectPatternX*1000)-000;
        
        nInspectR:=0;
        jTemp.extax:=[nInspectX,nInspectY,nInspectZ,nInspectR,9E+09,nInspectX];
        MoveExtJ jTemp,V1000,fine;
        STOP;
        
        nInspectR:=-45;
        jTemp.extax:=[nInspectX,nInspectY,nInspectZ,nInspectR,9E+09,nInspectX];
        MoveExtJ jTemp,V1000,fine;
        STOP;
        
        nInspectR:=-90;
        jTemp.extax:=[nInspectX,nInspectY,nInspectZ,nInspectR,9E+09,nInspectX];
        MoveExtJ jTemp,V1000,fine;
        STOP;
        
        nInspectR:=0;
        jTemp.extax:=[nInspectX,nInspectY,nInspectZ,nInspectR,9E+09,nInspectX];
        MoveExtJ jTemp,V1000,fine;
        STOP;
        
        nInspectR:=45;
        jTemp.extax:=[nInspectX,nInspectY,nInspectZ,nInspectR,9E+09,nInspectX];
        MoveExtJ jTemp,V1000,fine;
        STOP;
        
        nInspectR:=90;
        jTemp.extax:=[nInspectX,nInspectY,nInspectZ,nInspectR,9E+09,nInspectX];
        MoveExtJ jTemp,V1000,fine;
        STOP;

        nInspectCount:=nInspectCount+1;
        MoveExtJ jTemp,V1000,fine;
        Stop;

    ENDPROC
    
        PROC rInspectWithSmr3()
        VAR jointtarget jTemp;
        VAR num nInspectPatternX;
        VAR num nInspectPatternYZ;
        VAR num nInspectR;
        VAR num nInspectX;
        VAR num nInspectY;
        VAR num nInspectZ;

        AccSet 25,25;
        VelSet 100,600;
        jTemp:=[[0,0,0,0,0,0],[0,0,0,0,9E+09,0]];
        nInspectPatternX:=nInspectCount DIV 9;
        nInspectPatternYZ:=(nInspectCount MOD 9)+1;

        TEST nInspectPatternYZ
        CASE 1:
            nInspectX:=0;
            nInspectY:=300;
            nInspectZ:=0;

        CASE 2:
            nInspectX:=0;
            nInspectY:=300;
            nInspectZ:=500;

        CASE 3:
            nInspectX:=0;
            nInspectY:=300;
            nInspectZ:=1000;

        CASE 4:
            nInspectX:=0;
            nInspectY:=2650;
            nInspectZ:=1000;

        CASE 5:
            nInspectX:=0;
            nInspectY:=2650;
            nInspectZ:=500;

        CASE 6:
            nInspectX:=0;
            nInspectY:=2650;
            nInspectZ:=0;

        CASE 7:
            nInspectX:=0;
            nInspectY:=5300;
            nInspectZ:=0;

        CASE 8:
            nInspectX:=0;
            nInspectY:=5300;
            nInspectZ:=500;

        CASE 9:
            nInspectX:=0;
            nInspectY:=5300;
            nInspectZ:=1000;

        ENDTEST

        nInspectX:=(nInspectPatternX*1000)-3000;
        nInspectCount:=nInspectCount+1;
        nInspectR:=90;
        jTemp.extax:=[nInspectX,nInspectY,nInspectZ,nInspectR,9E+09,nInspectX];
        MoveExtJ jTemp,V1000,fine;
        Stop;

    ENDPROC
    
        PROC rInspectWithSmrX()
        VAR jointtarget jTemp;
        VAR num nInspectR;
        VAR num nInspectX;
        VAR num nInspectY;
        VAR num nInspectZ;

        AccSet 25,25;
        VelSet 100,600;
        jTemp:=[[0,0,0,0,0,0],[0,0,0,0,9E+09,0]];

        nInspectY:=200;
        nInspectZ:=300;
        nInspectR:=90;
        nInspectX:=(nInspectCount*500)-3000;
        jTemp.extax:=[nInspectX,nInspectY,nInspectZ,nInspectR,9E+09,nInspectX];
        
        MoveExtJ jTemp,V1000,fine;
        Stop;
        nInspectCount:=nInspectCount+1;
        

    ENDPROC


    PROC rCheckPrecisionGantryMove()
        AccSet 25,25;
        VelSet 100,300;
        MoveExtJ [[0,0,0,0,0,0],[-10400,-10400,6000,0,9E+09,9E+09]],v1000,z50;
        MoveExtJ [[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]],v1000,z50;
        MoveExtJ [[0,0,0,0,0,0],[-1000,-1000,0,0,9E+09,9E+09]],v1000,fine;
        MoveExtJ [[0,0,0,0,0,0],[1000,1000,0,0,9E+09,9E+09]],v1000,fine;
        MoveExtJ [[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]],v1000,fine;
        Stop;
        RETURN ;
        MoveExtJ [[0,0,0,0,0,0],[-8650,-8650,0,0,9E+09,9E+09]],v1000,fine;
        MoveExtJ [[0,0,0,0,0,0],[-8850,-8850,0,0,9E+09,9E+09]],v1000,fine;
        MoveExtJ [[0,0,0,0,0,0],[200,200,0,0,9E+09,9E+09]],v1000,fine;
        MoveExtJ [[0,0,0,0,0,0],[0,0,0,0,9E+09,9E+09]],v1000,fine;
        MoveExtJ [[0,0,0,0,0,0],[-10000,-10000,0,0,9E+09,9E+09]],v1000,fine;
        MoveExtJ [[0,0,0,0,0,0],[-10000,-10000,0,0,9E+09,9E+09]],v1000,fine;
        RETURN;
        MoveExtJ [[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[12273.7,539.427,248.892,0,9E+09,12273.7]],v1000,fine;
    ENDPROC

    PROC rCheckPrecisionGantryX()
        AccSet 20,20;
        VelSet 100,400;
        re111:
        MoveExtJ jposTemp,v1000,fine;
        MoveExtJ jposTemp10,v1000,fine;
        !jpostemp.extax.eax_a := jpostemp.extax.eax_a-500;
        !jpostemp.extax.eax_b := jposTemp.extax.eax_a;
        GOTO re111;
        RETURN ;
        !MoveExtJ [[0,90,-35,0,0,0],[-10000,-10000,5000,650,9E+09,9E+09]], v1000, z50;
        MoveExtJ jposTemp50,v1000,fine;
        !MoveExtJ jposTemp60, TargetSpeed, fine;
    ENDPROC

    PROC rCheckPrecisionGantryY()
        AccSet 20,20;
        VelSet 100,400;
        MoveExtJ [[0,0,0,0,0,0],[-10200,-10200,6000,0,9E+09,9E+09]],v1000,z50;
        Stop;
        MoveExtJ jposTemp,v1000,fine;
        Stop;
        MoveExtJ jposTemp30,v1000,fine;
        Stop;
        MoveExtJ jposTemp40,v1000,fine;
        Stop;
        !jpostemp.extax.eax_c := jposTemp.extax.eax_c+500;
        RETURN ;
    ENDPROC

    PROC rCheckPrecisionGantryZ()
        AccSet 25,25;
        VelSet 100,300;
        MoveExtJ jposTemp,v1000,z50;
        jpostemp.extax.eax_d:=jposTemp.extax.eax_d+100;
        RETURN ;
    ENDPROC

        PROC rNoNameMove()
        AccSet 25,25;
        VelSet 100,400;
        MoveExtJ [[0,0,0,0,0,0],[0,0,0,90,9E+09,0]], v1000, z50;
        MoveExtJ [[0,0,0,0,0,0],[12000,5300,0,90,0,12000]],v300,fine;
        MoveExtJ [[0,0,0,0,0,0],[3000,5300,0,90,0,3000]],v300,fine;
        MoveExtJ [[0,0,0,0,0,0],[12000,5300,0,90,0,12000]],v300,fine;
        MoveExtJ [[12.6874,0,0,0,0,0],[6300,5300,0,90,9E+09,6300]],v300,fine;
        RETURN ;
        !WaitTime 0.5;
        !Stop;
        MoveExtJ [[0,0,-45,0,-20,-150],[0,0,3000,0,9E+09,9E+09]],v500,fine;
        !WaitTime 0.5;
        !Stop;
        !MoveExtJ [[-90,-60,60,0,65,30],[0,0,5500,1500,9E+09,9E+09]], v500, fine;
        !Stop;
        RETURN ;
        ! 0,6000,0
        MoveExtJ [[-90,-60,60,0,65,30],[0,0,6000,500,9E+09,9E+09]],v500,fine;
        ! 5000,6000,0
        MoveExtJ [[-90,-60,60,0,65,30],[0,0,6000,0,9E+09,9E+09]],v500,fine;
        MoveExtJ [[90,60,-60,0,65,30],[0,0,3700,800,9E+09,9E+09]],v500,fine;
        MoveExtJ [[-90,60,-60,0,65,30],[0,0,3700,800,9E+09,9E+09]],v500,fine;
        ! 0,0,0
        MoveExtJ [[-89.9964,-59.9988,59.9923,6.55496E-05,64.991,29.9985],[0,0,0,0,9E+09,9E+09]],v300,fine;
        ! 5000,0,0
        MoveExtJ [[-89.9964,-59.9988,59.9923,6.55496E-05,64.991,29.9985],[5000,0,0,0,9E+09,9E+09]],v300,fine;
        ! 5000,0,1500
        MoveExtJ [[-90,-60,60,0,65,30],[5000,0,0,1500,9E+09,9E+09]],v300,fine;
        !0,0,1500
        MoveExtJ [[-90,-60,60,0,65,30],[0,0,0,1000,9E+09,9E+09]],v300,fine;
        !0,6000,1500
        MoveExtJ [[-90,-60,60,0,65,30],[5000,5000,0,750,9E+09,9E+09]],v300,fine;
        ! 5000,6000,1500
        MoveExtJ [[-90,0,-90,0,65,30],[0,0,6000,0,9E+09,9E+09]],v300,fine;
        MoveExtJ [[90,0,-90,0,0,0],[3000,3000,5000,459,9E+09,9E+09]],v300,fine;
        ! 90 -90 test
        MoveExtJ [[90,0,-90,0,0,0],[3000,3000,5000,460,9E+09,9E+09]],v300,fine;
        MoveExtJ [[-90,0,-90,0,0,0],[3000,3000,5000,460,9E+09,9E+09]],v300,fine;
        !
        !WaitTime 0.5;
        !Stop;
        MoveExtJ [[0,0,-45,0,-30,30],[0,0,6000,800,9E+09,9E+09]],v300,fine;
        MoveExtJ [[0.00146041,89.9993,-30.0005,-7.3477E-05,35.0006,30],[1500,1500,5500,1000,0,9E+09]],v300,fine;
        ! jeon test
        MoveExtJ [[-90,-10.75,9.52,0,1.1,-50],[1500,1500,5500,1000,0,9E+09]],v300,fine;
        Stop;
        ! ahn test
        MoveExtJ [[-90,0,-90,0,0,30],[1200,1200,4000,0,0,9E+09]],v300,fine;
        Stop;
    ENDPROC
    
	PROC rMoveSpecificPoint()
		<SMT>
	ENDPROC


ENDMODULE