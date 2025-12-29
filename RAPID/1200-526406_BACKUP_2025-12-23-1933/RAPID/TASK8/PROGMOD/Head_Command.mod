MODULE Head_Command
    PERS tasks taskGroup12{2}:=[["T_ROB1"],["T_ROB2"]];
    PERS tasks taskGroup13{2}:=[["T_ROB1"],["T_Gantry"]];
    PERS tasks taskGroup23{2}:=[["T_ROB2"],["T_Gantry"]];
    PERS tasks taskGroup123{3}:=[["T_ROB1"],["T_ROB2"],["T_Gantry"]];

    ! Sync Data
    TASK VAR syncident Synchronize;
    TASK VAR syncident Wait{100};

    PERS string stCommand:="";
    PERS string stReact{3}:=["Ready","Ready","Ready"];
    PERS num idSync:=7;
    PERS speeddata vSync:=[400,300,400,25];
    PERS zonedata zSync:=[FALSE,200,300,300,30,300,30];

    PERS jointtarget jRob1:=[[40.0002,89.9979,-90.0041,0.000871211,-0.00262464,0.00120365],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    PERS jointtarget jRob2:=[[40.0007,89.9977,-90.0023,0.000492503,-0.000730091,0.000644444],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    PERS robtarget pRob1:=[[7.3369,-26.8105,36.3553],[0.307623,-0.549545,-0.742667,-0.227629],[-1,0,0,1],[-8704.03,-8704.03,294.161,1030.31,9E+09,9E+09]];
    PERS robtarget pRob2:=[[7.3369,-26.8105,36.3553],[0.307623,-0.549545,-0.742667,-0.227629],[-1,0,0,1],[-8704.03,-8704.03,294.161,1030.31,9E+09,9E+09]];
    PERS jointtarget jGantry:=[[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[9838.99,0,700,89.3173,9E+09,9838.99]];

    PROC MoveJgJ(jointgroup jgInput,speeddata vInput,zonedata zInput)
        jRob1:=jgInput.Joint1;
        jRob2:=jgInput.Joint2;
        jGantry:=jgInput.JointG;
        
        WaitUntil(stCommand="") AND (stReact=["Ready","Ready","Ready"]);
        vSync:=vInput;
        zSync:=zInput;
        stCommand:="MoveJgJ";

        WaitUntil stReact=["Ack","Ack","Ack"];
        stCommand:="";
        WaitUntil stReact=["Ready","Ready","Ready"];
        IF nMoveid>10 nMoveid:=1;
        RETURN ;
    ENDPROC

    PROC MovePgJ(pointgroup pgInput,speeddata vInput,zonedata zInput)
        pRob1:=pgInput.Point1;
        pRob2:=pgInput.Point2;
        jGantry:=fnCoordToJoint(fnPoseToExtax(pgInput.PointG));

        WaitUntil(stCommand="") AND (stReact=["Ready","Ready","Ready"]);
        vSync:=vInput;
        zSync:=zInput;
        stCommand:="MovePgJ";

        WaitUntil stReact=["Ack","Ack","Ack"];
        stCommand:="";
        WaitUntil stReact=["Ready","Ready","Ready"];
        IF nMoveid>10 nMoveid:=1;
    ENDPROC

    PROC MovePgL(pointgroup pgInput,speeddata vInput,zonedata zInput)
        pRob1:=pgInput.Point1;
        pRob2:=pgInput.Point2;
        jGantry:=fnCoordToJoint(fnPoseToExtax(pgInput.PointG));

        WaitUntil(stCommand="") AND (stReact=["Ready","Ready","Ready"]);
        vSync:=vInput;
        zSync:=zInput;
        stCommand:="MovePgL";

        WaitUntil stReact=["Ack","Ack","Ack"];
        stCommand:="";
        WaitUntil stReact=["Ready","Ready","Ready"];
        IF nMoveid>10 nMoveid:=1;
        RETURN ;
    ENDPROC

    PROC WireCut(\Switch R1|Switch R2)
        WaitUntil(stCommand="") AND (stReact=["Ready","Ready","Ready"]);
        IF Present(R1)=TRUE stCommand:="WireCutR1";
        IF Present(R2)=TRUE stCommand:="WireCutR2";
        RETURN ;
    ENDPROC
    PROC WireCutShot(\Switch R1|Switch R2)
        WaitUntil(stCommand="") AND (stReact=["Ready","Ready","Ready"]);
        IF Present(R1)=TRUE stCommand:="WireCutShotR1";
        IF Present(R2)=TRUE stCommand:="WireCutShotR2";
        RETURN ;
    ENDPROC       
    PROC WireCutMove(\Switch R1|Switch R2)
        WaitUntil(stCommand="") AND (stReact=["Ready","Ready","Ready"]);
        IF Present(R1)=TRUE stCommand:="WireCutMoveR1";
        IF Present(R2)=TRUE stCommand:="WireCutMoveR2";
        RETURN ;
    ENDPROC      

ENDMODULE