MODULE T_Gantry_TeachingData   
    !!!!!...LdsCheck..............................
     PERS jointtarget jLDS_Start_TartgetX:=[[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[7220,5300,610.53,1.78433E-06,9E+09,7220]];
     PERS jointtarget jLDS_end_TartgetX:=[[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[7140,5300,610.53,1.78433E-06,9E+09,7140]];
     PERS jointtarget jLDS_Start_TartgetZ:=[[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[7068.27,5300,435,1.78433E-06,9E+09,7068.27]];
     PERS jointtarget jLDS_end_TartgetZ:=[[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[7068.27,5300,515,1.78433E-06,9E+09,7068.27]];
    !!!!!...Trob_1 NozzleClean..............................
    PERS jointtarget jNozzleClean_R1:=[[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[8353.13,150,0,-90,9E+09,8353.13]];
    !!!!!...Trob_2 NozzleClean..............................
    PERS jointtarget jNozzleClean_R2:=[[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09],[8353.13,0,0,90,9E+09,8353.13]];

    PROC rMoveToNozzleClean()
        VAR jointtarget jTempGantry;
        VAR speeddata vTempSpeed:=[25,25,25,25];
        jTempGantry:=CJointT();
        jNozzleClean_R1.extax.eax_a:=jTempGantry.extax.eax_a;
        jNozzleClean_R1.extax.eax_f:=jNozzleClean_R1.extax.eax_a;
        !!!!! T_Rob_1 NozzleClean Pos
        MoveExtJ jNozzleClean_R1\UseEOffs,vTempSpeed,z0;
        stop;
        jTempGantry:=CJointT();
        jNozzleClean_R2.extax.eax_a:=jTempGantry.extax.eax_a;
        jNozzleClean_R2.extax.eax_f:=jNozzleClean_R2.extax.eax_a;
        !!!!! T_Rob_2 NozzleClean Pos
        MoveExtJ jNozzleClean_R2\UseEOffs,vTempSpeed,z0;
        stop;
    ENDPROC       
ENDMODULE