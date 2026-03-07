MODULE T_ROB1_Function
	TASK PERS welddata weld1:=[10,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
	TASK PERS seamdata seam1:=[2,1,[0,0,24,120,0,0,0,0,0],1,1,10,0,5,[0,0,24,120,0,0,0,0,0],0,1,[5,0,24,120,0,0,0,0,0],0,0,[0,0,0,0,0,0,0,0,0],0];
	TASK PERS welddata weld2:=[10,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
	TASK PERS welddata weld3:=[10,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
	VAR num nCount:=0;
	VAR num nWeld_data:=0;
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

        nCalcCount:= round(VectMagn(End.trans-Start.trans)/0.5);      
        pCalcTemp.trans:=(End.trans-Start.trans)/nCalcCount;

        tool_rx_end:=[EulerZYX(\z,End.rot),EulerZYX(\y,End.rot),EulerZYX(\x,End.rot)];
        tool_rx_start:=[EulerZYX(\z,Start.rot),EulerZYX(\y,Start.rot),EulerZYX(\x,Start.rot)];
        tool_rx_delta:=[(tool_rx_end{1}-tool_rx_start{1})/nCalcCount,(tool_rx_end{2}-tool_rx_start{2})/nCalcCount,(tool_rx_end{3}-tool_rx_start{3})/nCalcCount];

        result.trans:=CurrentPos.trans+pCalcTemp.trans;
        result.rot:=(OrientZYX(EulerZYX(\z,CurrentPos.rot)+tool_rx_delta{1},EulerZYX(\y,CurrentPos.rot)+tool_rx_delta{2},EulerZYX(\x,CurrentPos.rot)));
        result.extax:=[9e9,9e9,9e9,9e9,9e9,9e9];
        RETURN result;
    ENDFUNC
ENDMODULE