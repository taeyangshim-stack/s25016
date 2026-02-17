MODULE CommSock
    PERS bool bEnableLdsX:=FALSE;
    VAR string sIpLdsX;
    VAR num nPortLdsX;
    VAR socketdev ComSocketLdsX;
    PERS socketstatus stateLdsX;
    VAR num nPeekValueLdsX;
    VAR byte byteLdsX{40}:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    VAR rawbytes rawbytesX;
    PERS num nLdsX_Length:=562.69;
    PERS num nLdsX_LastLength;
    PERS num nLdsX_DefinedDiff;
    PERS bool bLdsX_EdgeChk;

    PERS bool bEnableLdsZ:=FALSE;
    VAR string sIpLdsZ;
    VAR num nPortLdsZ;
    VAR socketdev ComSocketLdsZ;
    PERS socketstatus stateLdsZ;
    VAR num nPeekValueLdsZ;
    VAR byte byteLdsZ{40}:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    VAR rawbytes rawbytesZ;
    PERS num nLdsZ_Length:=0;
    PERS num nLdsZ_LastLength;
    PERS num nLdsZ_DefinedDiff;
    PERS bool bLdsZ_EdgeChk;

    PERS bool bEnableRimsCorr:=FALSE;
  
    PROC LDSCheck()
        IF bEnableLdsX THEN
            Set co013_EnableLdsX;

            nPeekValueLdsX:=AInput(cai03_LdsX);
            IF nPeekValueLdsX>500 nLdsX_Length:=nPeekValueLdsX;

            IF Abs(nLdsX_LastLength-nLdsX_Length)>nLdsX_DefinedDiff THEN
                bLdsX_EdgeChk:=TRUE;
            ELSE
                bLdsX_EdgeChk:=FALSE;
            ENDIF
        ELSE
            Reset co013_EnableLdsX;
            nPeekValueLdsX:=0;
            bLdsX_EdgeChk:=FALSE;
        ENDIF

        IF bEnableLdsZ THEN
            Set co014_EnableLdsZ;

            nPeekValueLdsZ:=AInput(cai05_LdsZ);
            IF nPeekValueLdsZ>500 nLdsZ_Length:=nPeekValueLdsZ;

            IF Abs(nLdsZ_LastLength-nLdsZ_Length)>nLdsZ_DefinedDiff THEN
                bLdsZ_EdgeChk:=TRUE;
            ELSE
                bLdsZ_EdgeChk:=FALSE;
            ENDIF
        ELSE
            Reset co014_EnableLdsZ;
            nPeekValueLdsZ:=0;
            bLdsZ_EdgeChk:=FALSE;
        ENDIF
        RETURN ;
    ENDPROC

ENDMODULE