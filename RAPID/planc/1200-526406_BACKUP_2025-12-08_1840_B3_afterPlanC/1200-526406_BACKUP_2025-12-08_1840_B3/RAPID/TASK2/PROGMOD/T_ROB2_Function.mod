MODULE T_ROB2_Function
    FUNC num TouchLimit(num Standard,num comparison)
        VAR num result;
        IF Standard<=comparison result:=Standard;
        IF Standard>comparison result:=comparison-1;
        RETURN result;
    ENDFUNC
        FUNC robtarget fCalcWeldingpos(robtarget CurrentPos,robtarget Start,robtarget End)
        VAR robtarget result;
        VAR robtarget pCalcTemp;
        VAR num nCount_X;
        VAR num nCount_Y;
        VAR num nCount_Z;
        VAR num nCalcCount;

        nCalcCount:=round(VectMagn(End.trans-Start.trans)/0.5);   
        pCalcTemp.trans:=(End.trans-Start.trans)/nCalcCount;
        
        tool_rx_end:=[EulerZYX(\z,End.rot),EulerZYX(\y,End.rot),EulerZYX(\x,End.rot)];
        tool_rx_start:=[EulerZYX(\z,Start.rot),EulerZYX(\y,Start.rot),EulerZYX(\x,Start.rot)];
        tool_rx_delta:=[(tool_rx_end{1}-tool_rx_start{1})/nCalcCount,(tool_rx_end{2}-tool_rx_start{2})/nCalcCount,(tool_rx_end{3}-tool_rx_start{3})/nCalcCount]; 
        
        result.trans:=CurrentPos.trans+pCalcTemp.trans;   
        result.rot:=(OrientZYX(EulerZYX(\z,CurrentPos.rot)+tool_rx_delta{1},EulerZYX(\y,CurrentPos.rot)+tool_rx_delta{2},EulerZYX(\x,CurrentPos.rot)));
        result.extax:=[9e9,9e9,9e9,9e9,9e9,9e9];
        RETURN result;
    ENDFUNC
	PROC Routine1Copy()
		ArcLStart [[452.82,-154.95,21.09],[0.0555197,-0.888341,-0.106824,-0.443122],[0,-1,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]], v1000, tsm2, wd1\Weave:=weave1, fine, tWeld2\WObj:=wobjWeldLine2\Track:=track1;
		ArcLEnd [[452.96,-321.85,21.32],[0.0555083,-0.888324,-0.106767,-0.443171],[0,-1,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]], v1000, tsm2, wd1\Weave:=weave1, fine, tWeld2\WObj:=wobjWeldLine2\Track:=track1;
	ENDPROC
ENDMODULE