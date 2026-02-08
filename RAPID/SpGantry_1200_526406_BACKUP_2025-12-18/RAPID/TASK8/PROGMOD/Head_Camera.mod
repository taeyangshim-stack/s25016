MODULE Head_Camera
    CONST num CAMERA_DOOR_CLOSE:=0;
    CONST num CAMERA_DOOR_OPEN:=1;

    PROC rCameraBlowOff()
        Reset do11_Cam1Purge;
        Reset do12_Cam2Purge;
        RETURN ;
    ENDPROC
    PROC rCamera1_BlowOff()
        Reset do11_Cam1Purge;
        RETURN ;
    ENDPROC
    PROC rCamera2_BlowOff()
        Reset do12_Cam2Purge;
        RETURN ;
    ENDPROC    
    PROC rCameraBlowOn()
        Set do11_Cam1Purge;
        Set do12_Cam2Purge;
        RETURN ;
    ENDPROC
    PROC rCamera1_BlowOn()
        Set do11_Cam1Purge;
        RETURN ;
    ENDPROC
        PROC rCamera2_BlowOn()
        Set do12_Cam2Purge;
        RETURN ;
    ENDPROC
    PROC rCameraDoorClose()
        Reset do01_Door1A_Open;
        Reset do03_Door1B_Open;
        Reset do05_Door2A_Open;
        Reset do07_Door2B_Open;
        Set do02_Door1A_Close;
        Set do04_Door1B_Close;
        Set do06_Door2A_Close;
        Set do08_Door2B_Close;
        WaitUntil di10_Door1A_Close=1 AND di12_Door1B_Close=1 AND di14_Door2A_Close=1 AND di16_Door2B_Close=1;
        Reset do02_Door1A_Close;
        Reset do04_Door1B_Close;
        Reset do06_Door2A_Close;
        Reset do08_Door2B_Close;
        
        !WaitUntil (Camera_Door=CAMERA_DOOR_CLOSE);
        
        RETURN ;
    ENDPROC

    PROC rCameraDoorOpen()
        Reset do02_Door1A_Close;
        Reset do04_Door1B_Close;
        Reset do06_Door2A_Close;
        Reset do08_Door2B_Close;
        Set do01_Door1A_Open;
        Set do03_Door1B_Open;
        Set do05_Door2A_Open;
        Set do07_Door2B_Open;
        WaitUntil di09_Door1A_Open=1 AND  di11_Door1B_Open=1 AND di13_Door2A_Open=1 AND di15_Door2B_Open=1;
        Reset do01_Door1A_Open;
        Reset do03_Door1B_Open;
        Reset do05_Door2A_Open;
        Reset do07_Door2B_Open;
!        Camera_Door:=CAMERA_DOOR_OPEN;
        !WaitUntil (Camera_Door=CAMERA_DOOR_Open);

        RETURN ;
    ENDPROC

    PROC rCamera1DoorClose()
        Reset do01_Door1A_Open;
        Reset do03_Door1B_Open;
        Set do02_Door1A_Close;
        Set do04_Door1B_Close;
        WaitUntil di10_Door1A_Close=1 AND di12_Door1B_Close=1;
        Reset do02_Door1A_Close;
        Reset do04_Door1B_Close;
!        Camera_Door:=CAMERA_DOOR_CLOSE;
        WaitUntil (Camera_Door=CAMERA_DOOR_CLOSE);

        RETURN ;
    ENDPROC

    PROC rCamera1DoorOpen()
        Reset do02_Door1A_Close;
        Reset do04_Door1B_Close;
        Set do01_Door1A_Open;
        Set do03_Door1B_Open;
        WaitUntil di09_Door1A_Open=1 AND  di11_Door1B_Open=1;
        Reset do01_Door1A_Open;
        Reset do03_Door1B_Open;
!        Camera_Door:=CAMERA_DOOR_OPEN;
        WaitUntil (Camera_Door=CAMERA_DOOR_OPEN);

        RETURN ;
    ENDPROC
    
    PROC rCamera2DoorClose()
        Reset do05_Door2A_Open;
        Reset do07_Door2B_Open;
        Set do06_Door2A_Close;
        Set do08_Door2B_Close;
        WaitUntil di14_Door2A_Close=1 AND di16_Door2B_Close=1;
        Reset do06_Door2A_Close;
        Reset do08_Door2B_Close;
!        Camera_Door:=CAMERA_DOOR_CLOSE;
        WaitUntil (Camera_Door=CAMERA_DOOR_CLOSE);

        RETURN ;
    ENDPROC

    PROC rCamera2DoorOpen()
        Reset do06_Door2A_Close;
        Reset do08_Door2B_Close;
        Set do05_Door2A_Open;
        Set do07_Door2B_Open;
        WaitUntil di13_Door2A_Open=1 AND di15_Door2B_Open=1;
        Reset do05_Door2A_Open;
        Reset do07_Door2B_Open;
!        Camera_Door:=CAMERA_DOOR_OPEN;
        WaitUntil (Camera_Door=CAMERA_DOOR_OPEN);

        RETURN ;
    ENDPROC

ENDMODULE