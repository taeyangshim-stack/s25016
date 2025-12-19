MODULE MainModule
	TASK PERS seamdata seam1:=[0.5,0.5,[5,0,24,120,0,0,0,0,0],0.5,1,10,0,5,[5,0,24,120,0,0,0,0,0],0,1,[5,0,24,120,0,0,0,0,0],0,0,[0,0,0,0,0,0,0,0,0],0];
	TASK PERS welddata weld1:=[6,0,[5,0,24,120,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
	TASK PERS weavedata weave1:=[1,0,3,4,0,0,0,0,0,0,0,0,0,0,0];
    PERS tooldata tWeld1:=[TRUE,[[319.938,-6.311,330],[0.92587,0.003729,0.377818,-0.009129]],[3.1,[-71.4,3.8,173.2],[1,0,0,0],0.055,0.049,0.005]];
	TASK PERS trackdata track1:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
	PERS tasks Alltask{2}:=[["T_ROB1"],["T_ROB2"]];
    VAR syncident Sync1;
	PERS pose pose1:=[[0.775146,-0.00012207,-0.0380859],[1,0,0,0]];
	CONST robtarget pWire_Cut:=[[-66.37,0.19,11509.72],[0.415893,-0.575537,-0.42594,0.560683],[-1,-2,1,0],[11500,-4.91429E-05,-0.000147837,1.78433E-06,0,11500]];
	CONST robtarget pWire_Cut10:=[[-66.37,50.10,11509.72],[0.415891,-0.57554,-0.425936,0.560684],[-1,-2,1,0],[11500,-4.91429E-05,-1.11791E-06,-0.000149404,0,11500]];
	CONST robtarget pWire_Cut20:=[[-66.37,50.10,11509.71],[0.415891,-0.575539,-0.425939,0.560683],[-1,-2,1,0],[11500,-4.91429E-05,-1.11791E-06,1.78433E-06,0,11500]];
	CONST robtarget pWire_Cut30:=[[8.64,50.10,11509.71],[0.41589,-0.57554,-0.425938,0.560683],[-1,-2,1,0],[11500,-4.91429E-05,-1.11791E-06,1.78433E-06,0,11500]];
	CONST robtarget pWire_Cut40:=[[8.64,50.10,11509.72],[0.415893,-0.575537,-0.42594,0.560682],[-1,-2,1,0],[11500,-4.91429E-05,-1.11791E-06,1.78433E-06,0,11500]];
	CONST robtarget pWire_Cut50:=[[210.11,-22.74,11790.90],[0.274551,-0.626527,-0.316515,0.657195],[-1,-1,0,0],[11500,0.00274822,0.00777501,1.78433E-06,0,11500]];
	CONST robtarget pWire_Cut60:=[[569.16,494.31,12363.00],[0.00912714,-0.377804,0.00372676,0.925833],[-1,-1,0,1],[11500,-0.000557755,-0.00132159,1.78433E-06,0,11500]];
	CONST robtarget pWire_Cut70:=[[569.16,494.31,12363.00],[0.00912865,-0.377805,0.00372737,0.925833],[-1,0,-1,1],[11500,0.000459469,-0.000881434,1.78433E-06,0,11500]];
	VAR syncident sync2;
	VAR syncident sync3;
    CONST robtarget Target_70:=[[1161.172779454,144.559329246,-14.871009752],[0.061622373,-0.061632152,0.704422634,-0.704409621],[0,-1,0,0],[50.497416407,99.641412497,66.590927541,0,0,2.893288836]];
    CONST robtarget Target_80:=[[1161.172382635,144.558432538,-14.87045264],[0.061622111,-0.06163207,0.704422579,-0.704409706],[0,-1,0,0],[129.957869649,168.339699507,103.588841856,0,0,7.446037445]];
	TASK PERS jointtarget jTemp:=[[0,-2.51761,-12.1411,0,15.6587,0],[-500,500,300,15,0,-28.6479]];
	PERS pos nCaledR1Pos:=[-28.6282,626.304,300];

	! Shared Variables for Gantry Position (v1.0.0 2025-12-17)
	TASK PERS jointtarget shared_gantry_pos := [[0,0,0,0,0,0],[0,0,0,0,0,0]];
	TASK PERS num shared_gantry_x := 0;
	TASK PERS num shared_gantry_y := 0;
	TASK PERS num shared_gantry_z := 0;
	TASK PERS num shared_gantry_r := 0;
	TASK PERS num shared_gantry_x2 := 0;
	TASK PERS num shared_update_counter := 0;
	TASK PERS num shared_test_value := 12345;

	! Work Object Definitions (v1.2.0 2025-12-18)
	! WobjFloor: Floor coordinate system at [-9500, 5300, 2100] from World
	PERS wobjdata WobjFloor := [FALSE, TRUE, "", [[-9500, 5300, 2100], [0, 1, 0, 0]], [[0, 0, 0], [1, 0, 0, 0]]];

	! wobjRob1Base: Robot1 Base Frame = GantryRob coordinate system (Y-axis 90° rotation)
	! Quaternion [0, 0.707107, 0, 0.707107] = Y-axis 90° rotation
	PERS wobjdata wobjRob1Base := [FALSE, TRUE, "", [[0, 0, 0], [0, 0.707107, 0, 0.707107]], [[0, 0, 0], [1, 0, 0, 0]]];

	PROC main()
		rUpdateR1Position;
	ENDPROC
    
    PROC rUpdateR1Position()
        VAR num X;
        VAR num Y;
        VAR num Z;
        VAR num R;
        VAR num X1;
        VAR num Y1;
        VAR num Z1;
        !        jTemp:=[[0,0,0,0,0,0],[0,0,0,30,0,0]];
        jTemp := CJointT(\TaskName:="T_ROB1");

        X:=jtemp.extax.eax_a;
        Y:=jtemp.extax.eax_b;
        Z:=jtemp.extax.eax_c;
        R:=jtemp.extax.eax_d;

        X1:=X+(488*cos(R));
        !X2:=X-(976*cos(R));
        Y1:=Y+(488*sin(R));
        !Y2:=Y-(976*sin(R));

        nCaledR1Pos:=[X1,Y1,Z];
    ENDPROC
	PROC mainCopy()
		SyncMoveOn Sync1, Alltask;
		MoveL [[2094.90,-367.86,12453.71],[0.0969749,-0.464748,0.371902,-0.79768],[-1,-1,0,1],[12000,470.018,767.656,0.000203368,0,12000]]\ID:=40, v1000, z50, tWeld1;
		ArcLStart [[2094.96,-367.84,12453.68],[0.0969752,-0.464783,0.371888,-0.797666],[-1,-1,0,1],[12000,470.019,767.664,0.000203368,0,12000]]\ID:=10, v1000, seam1, weld1\Weave:=weave1, fine, tWeld1;
		ArcL [[2094.90,-367.87,12453.71],[0.0969776,-0.464746,0.371904,-0.79768],[-1,-1,0,1],[12000,470.018,767.656,0.000203368,0,12000]]\ID:=20, v1000, seam1, weld1\Weave:=weave1, z10, tWeld1;
		ArcLEnd [[2095.02,-367.83,11972.6],[0.0969842,-0.464821,0.371896,-0.79764],[-1,-1,0,1],[11519,470.018,767.679,0.000102576,0,11519]]\ID:=30, v1000, seam1, weld1\Weave:=weave1, fine, tWeld1;
		SyncMoveOff Sync1;
		!MoveL [[2094.90,-367.87,12453.71],[0.0969765,-0.464746,0.371905,-0.79768],[-1,-1,0,1],[12000,470.018,767.656,0.000203368,0,12000]], v1000, z50, tWeld1;
		WaitTime 3;
		!Search_1D pose1, [[2103.66,-574.48,11839.24],[0.196295,0.468915,0.294361,0.809282],[-1,-1,-1,1],[11656.7,1147.82,753.091,-49.1263,0,11656.7]], [[2117.43,-574.48,11839.25],[0.196294,0.468909,0.29436,0.809287],[-1,-1,-1,1],[11656.7,1147.82,753.087,-49.1263,0,11656.7]], v1000, tWeld1;
	ENDPROC
	PROC rFinal_200()
		MoveL [[2047.28,-525.15,12164.96],[0.0970333,-0.465179,0.371637,-0.797546],[-1,-1,-1,1],[11915.7,595.667,723.906,0.000203368,0,11915.7]], v1000, z50, tWeld1;
		WaitSyncTask Sync1, Alltask;
		SyncMoveOn Sync1, Alltask;
		ArcLStart [[2103.49,-543.85,12164.96],[0.114652,-0.524236,0.379809,-0.75351],[-1,-1,-1,1],[11915.7,595.666,723.906,0.000203368,0,11915.7]]\ID:=10, v1000, seam1, weld1\Weave:=weave1, fine, tWeld1;
		ArcL [[2103.49,-508.95,12164.96],[0.114648,-0.524233,0.379808,-0.753513],[-1,-1,0,1],[11915.7,595.666,723.906,0.000203368,0,11915.7]]\ID:=20, v1000, seam1, weld1\Weave:=weave1, z10, tWeld1;
		ArcL [[2103.49,-508.95,12064.02],[0.114649,-0.524232,0.379809,-0.753513],[-1,-1,-1,1],[11915.7,595.666,723.906,0.000203368,0,11915.7]]\ID:=30, v1000, seam1, weld1\Weave:=weave1, z10, tWeld1;
		ArcL [[2102.86,-509.83,11932.99],[0.114649,-0.524234,0.379807,-0.753512],[-1,-1,-1,1],[11784.6,596.544,723.906,0.000203368,0,11784.6]]\ID:=40, v1000, seam1, weld1\Weave:=weave1, z10, tWeld1;
		ArcL [[2102.86,-510.25,11598.24],[0.114651,-0.524236,0.379808,-0.75351],[-1,-1,-1,1],[11449.9,596.97,723.906,0.000203368,0,11449.9]]\ID:=50, v1000, seam1, weld1\Weave:=weave1, z10, tWeld1;
		ArcL [[2100.63,-510.26,11501.35],[0.114648,-0.524237,0.37981,-0.753508],[-1,-1,-1,1],[11449.9,596.97,723.906,0.00030416,0,11449.9]]\ID:=70, v1000, seam1, weld1\Weave:=weave1, z10, tWeld1;
		ArcLEnd [[2100.64,-536.41,11501.35],[0.114652,-0.524234,0.379806,-0.753512],[-1,-1,-1,1],[11449.9,596.97,723.906,0.00030416,0,11449.9]]\ID:=60, v1000, seam1, weld1\Weave:=weave1, fine, tWeld1;
		SyncMoveOff Sync1;
		MoveL [[2038.80,-475.20,11501.35],[0.114651,-0.524235,0.379811,-0.753509],[-1,-1,-1,1],[11449.9,596.969,723.906,0.00030416,0,11449.9]], v1000, z50, tWeld1;
		WaitTime 3;
	ENDPROC
	PROC rFinal_200_244()
		MoveL [[2047.28,-525.15,12164.96],[0.0970333,-0.465179,0.371637,-0.797546],[-1,-1,-1,1],[11915.7,595.667,723.906,0.000203368,0,11915.7]], v1000, z50, tWeld1;
		WaitSyncTask Sync1, Alltask;
		ArcLStart [[2103.54,-543.83,12164.95],[0.114657,-0.524252,0.379793,-0.753506],[-1,-1,-1,1],[11915.7,595.668,723.913,0.00030416,0,11915.7]], v1000, seam1, weld1, fine, tWeld1;
		ArcL [[2103.54,-543.83,12059.63],[0.114655,-0.52425,0.379791,-0.753508],[-1,-1,-1,1],[11915.7,595.668,723.914,0.000203368,0,11915.7]], v1000, seam1, weld1, z10, tWeld1;
		WaitSyncTask sync2, Alltask;
		ArcL [[2103.55,-508.91,12063.99],[0.114677,-0.52426,0.379798,-0.753495],[-1,-1,-1,1],[11915.7,595.669,723.912,0.000203368,0,11915.7]], v1000, seam1, weld1, z10, tWeld1;
		!WaitTime 2;
		!ArcLStart [[2103.49,-543.85,12164.96],[0.114652,-0.524236,0.379809,-0.75351],[-1,-1,-1,1],[11915.7,595.666,723.906,0.000203368,0,11915.7]]\ID:=10, v1000, seam1, weld1\Weave:=weave1, fine, tWeld1;
		!ArcL [[2103.49,-508.95,12164.96],[0.114648,-0.524233,0.379808,-0.753513],[-1,-1,0,1],[11915.7,595.666,723.906,0.000203368,0,11915.7]]\ID:=20, v1000, seam1, weld1\Weave:=weave1, z10, tWeld1;
		SyncMoveOn sync3, Alltask;
		ArcL [[2103.49,-508.95,12064.02],[0.114649,-0.524232,0.379809,-0.753513],[-1,-1,-1,1],[11915.7,595.666,723.906,0.000203368,0,11915.7]]\ID:=30, v1000, seam1, weld1\Weave:=weave1, z10, tWeld1;
		ArcL [[2102.86,-509.83,11932.99],[0.114649,-0.524234,0.379807,-0.753512],[-1,-1,-1,1],[11784.6,596.544,723.906,0.000203368,0,11784.6]]\ID:=40, v1000, seam1, weld1\Weave:=weave1, z10, tWeld1;
		ArcL [[2102.86,-510.25,11598.24],[0.114651,-0.524236,0.379808,-0.75351],[-1,-1,-1,1],[11449.9,596.97,723.906,0.000203368,0,11449.9]]\ID:=50, v1000, seam1, weld1\Weave:=weave1, z10, tWeld1;
		ArcL [[2100.63,-510.26,11501.35],[0.114648,-0.524237,0.37981,-0.753508],[-1,-1,-1,1],[11449.9,596.97,723.906,0.00030416,0,11449.9]]\ID:=70, v1000, seam1, weld1\Weave:=weave1, z10, tWeld1;
		ArcLEnd [[2100.64,-536.41,11501.35],[0.114652,-0.524234,0.379806,-0.753512],[-1,-1,-1,1],[11449.9,596.97,723.906,0.00030416,0,11449.9]]\ID:=60, v1000, seam1, weld1\Weave:=weave1, fine, tWeld1;
		SyncMoveOff sync3;
		MoveL [[2038.80,-475.20,11501.35],[0.114651,-0.524235,0.379811,-0.753509],[-1,-1,-1,1],[11449.9,596.969,723.906,0.00030416,0,11449.9]], v1000, z50, tWeld1;
		WaitTime 3;
		!Search_1D pose1, [[2103.66,-574.48,11839.24],[0.196295,0.468915,0.294361,0.809282],[-1,-1,-1,1],[11656.7,1147.82,753.091,-49.1263,0,11656.7]], [[2117.43,-574.48,11839.25],[0.196294,0.468909,0.29436,0.809287],[-1,-1,-1,1],[11656.7,1147.82,753.087,-49.1263,0,11656.7]], v1000, tWeld1;
	ENDPROC
	PROC Routine1()
		MoveAbsJ [[-90,0,0,0,0,0],[11500,0,0,0,0,11500]]\NoEOffs, v1000, z50, tWeld1;
	ENDPROC
	PROC Routine2()
		MoveL [[2068.74,53.25,11799.20],[0.196641,0.468668,0.295017,0.809103],[-1,-1,-1,1],[11633.2,533.997,743.121,-49.2176,0,11633.2]], v1000, z50, tWeld1;
		ArcLStart [[2107.92,42.66,11799.75],[0.196617,0.468748,0.294994,0.809071],[-1,-1,-1,1],[11633.2,533.996,743.134,-49.2176,0,11633.2]], v1000, seam1, weld1\Weave:=weave1, fine, tWeld1\Track:=track1;
		ArcL [[2121.40,-108.42,11808.55],[0.196642,0.46866,0.295016,0.809108],[-1,-1,-1,1],[11633.2,533.997,743.12,-49.2176,0,11633.2]], v1000, seam1, weld1\Weave:=weave1, z10, tWeld1\Track:=track1;
		ArcL [[2121.40,-149.65,11815.47],[0.196646,0.46866,0.295015,0.809107],[-1,-1,-1,1],[11633.2,533.997,743.12,-49.2176,0,11633.2]], v1000, seam1, weld1\Weave:=weave1, z10, tWeld1\Track:=track1;
		ArcLEnd [[2121.40,-291.89,11809.14],[0.196651,0.468665,0.295018,0.809102],[-1,-1,-1,1],[11633.2,533.997,743.12,-49.2176,0,11633.2]], v1000, seam1, weld1\Weave:=weave1, fine, tWeld1\Track:=track1;
		MoveL [[2078.83,-291.89,11809.14],[0.196639,0.468664,0.295016,0.809106],[-1,-1,-1,1],[11633.2,533.997,743.12,-49.2176,0,11633.2]], v1000, z50, tWeld1;
	ENDPROC
	PROC Routine3()
		MoveJ pWire_Cut60, v1000, z50, tWeld1;
		MoveJ pWire_Cut50, v1000, z50, tWeld1;
		MoveJ pWire_Cut30, v1000, z50, tWeld1;
		MoveJ pWire_Cut10, v1000, z50, tWeld1;
		MoveL pWire_Cut, v1000, z50, tWeld1;
		WaitTime 1;
		MoveL pWire_Cut20, v1000, z50, tWeld1;
		MoveL pWire_Cut40, v1000, z50, tWeld1;
		MoveJ pWire_Cut70, v1000, z50, tWeld1;
	ENDPROC
	PROC Routine4()
		MoveL [[2042.32,-66.65,11540.79],[0.097731,-0.470113,0.37174,-0.794514],[-1,-1,0,1],[11152.8,171.336,712.533,1.78433E-06,0,11152.8]], v1000, z50, tWeld1;
		ArcLStart [[2078.19,-66.65,11540.79],[0.0977313,-0.470112,0.371741,-0.794514],[-1,-1,0,1],[11152.8,171.336,748.408,1.78433E-06,0,11152.8]], v1000, seam1, weld1, fine, tWeld1;
	ENDPROC
	PROC Routine5()
		MoveAbsJ [[-90,0,0,0,0,0],[0,0,0,0,0,0]]\NoEOffs, v1000, z50, tWeld1;
	ENDPROC
    PROC Path_10()
        MoveL Target_70,v1000,z100,tool0\WObj:=wobj0;
        MoveL Target_80,v1000,z100,tool0\WObj:=wobj0;
    ENDPROC

	!========================================
	! Update Gantry Position
	!========================================
	PROC UpdateSharedGantryPosition()
		VAR jointtarget current_pos;

		current_pos := CJointT();
		shared_gantry_pos := current_pos;
		shared_gantry_x := current_pos.extax.eax_a;
		shared_gantry_y := current_pos.extax.eax_b;
		shared_gantry_z := current_pos.extax.eax_c;
		shared_gantry_r := current_pos.extax.eax_d;
		shared_gantry_x2 := current_pos.extax.eax_f;
		shared_update_counter := shared_update_counter + 1;

	ERROR
		TPWrite "ERROR in UpdateSharedGantryPosition: " + NumToStr(ERRNO, 0);
	ENDPROC

	PROC ContinuousUpdateGantryPosition()
		TPWrite "Starting continuous gantry position update...";

		WHILE TRUE DO
			UpdateSharedGantryPosition;
			WaitTime 0.1;
		ENDWHILE

	ERROR
		TPWrite "ERROR in ContinuousUpdateGantryPosition: " + NumToStr(ERRNO, 0);
	ENDPROC

	PROC TestPrintSharedGantryPosition()
		TPWrite "========================================";
		TPWrite "TASK1 - Shared Gantry Position";
		TPWrite "========================================";

		UpdateSharedGantryPosition;

		TPWrite "Gantry External Axes:";
		TPWrite "  X1 = " + NumToStr(shared_gantry_x, 4) + " m";
		TPWrite "  Y  = " + NumToStr(shared_gantry_y, 4) + " m";
		TPWrite "  Z  = " + NumToStr(shared_gantry_z, 4) + " m";
		TPWrite "  R  = " + NumToStr(shared_gantry_r, 4) + " rad";
		TPWrite "  X2 = " + NumToStr(shared_gantry_x2, 4) + " m";
		TPWrite "Update Counter: " + NumToStr(shared_update_counter, 0);
		TPWrite "========================================";

	ERROR
		TPWrite "ERROR in TestPrintSharedGantryPosition: " + NumToStr(ERRNO, 0);
	ENDPROC

	!========================================
	! Check wobj0 Definition
	!========================================
	! Version: v1.1.0
	! Date: 2025-12-18
	! Changes: Added file output to /HOME/task1_wobj0_definition.txt

	PROC ShowWobj0Definition()
		VAR string str_robhold;
		VAR string str_ufprog;
		VAR iodev logfile;

		TPWrite "========================================";
		TPWrite "TASK1 - wobj0 Definition (v1.1.0)";
		TPWrite "========================================";

		IF wobj0.robhold = TRUE THEN
			str_robhold := "TRUE";
		ELSE
			str_robhold := "FALSE";
		ENDIF

		IF wobj0.ufprog = TRUE THEN
			str_ufprog := "TRUE";
		ELSE
			str_ufprog := "FALSE";
		ENDIF

		TPWrite "wobj0.robhold: " + str_robhold;
		TPWrite "wobj0.ufprog: " + str_ufprog;
		TPWrite "";
		TPWrite "User Frame (uframe):";
		TPWrite "  X = " + NumToStr(wobj0.uframe.trans.x, 2) + " mm";
		TPWrite "  Y = " + NumToStr(wobj0.uframe.trans.y, 2) + " mm";
		TPWrite "  Z = " + NumToStr(wobj0.uframe.trans.z, 2) + " mm";
		TPWrite "  q1 = " + NumToStr(wobj0.uframe.rot.q1, 4);
		TPWrite "  q2 = " + NumToStr(wobj0.uframe.rot.q2, 4);
		TPWrite "  q3 = " + NumToStr(wobj0.uframe.rot.q3, 4);
		TPWrite "  q4 = " + NumToStr(wobj0.uframe.rot.q4, 4);
		TPWrite "";
		TPWrite "Object Frame (oframe):";
		TPWrite "  X = " + NumToStr(wobj0.oframe.trans.x, 2) + " mm";
		TPWrite "  Y = " + NumToStr(wobj0.oframe.trans.y, 2) + " mm";
		TPWrite "  Z = " + NumToStr(wobj0.oframe.trans.z, 2) + " mm";
		TPWrite "========================================";

		! Save to file
		Open "/HOME/", logfile \Write;
		Open "task1_wobj0_definition.txt", logfile \Append;

		Write logfile, "========================================";
		Write logfile, "TASK1 - wobj0 Definition (v1.1.0)";
		Write logfile, "========================================";
		Write logfile, "Date: " + CDate();
		Write logfile, "Time: " + CTime();
		Write logfile, "";
		Write logfile, "wobj0.robhold: " + str_robhold;
		Write logfile, "wobj0.ufprog: " + str_ufprog;
		Write logfile, "";
		Write logfile, "User Frame (uframe):";
		Write logfile, "  X = " + NumToStr(wobj0.uframe.trans.x, 2) + " mm";
		Write logfile, "  Y = " + NumToStr(wobj0.uframe.trans.y, 2) + " mm";
		Write logfile, "  Z = " + NumToStr(wobj0.uframe.trans.z, 2) + " mm";
		Write logfile, "  q1 = " + NumToStr(wobj0.uframe.rot.q1, 4);
		Write logfile, "  q2 = " + NumToStr(wobj0.uframe.rot.q2, 4);
		Write logfile, "  q3 = " + NumToStr(wobj0.uframe.rot.q3, 4);
		Write logfile, "  q4 = " + NumToStr(wobj0.uframe.rot.q4, 4);
		Write logfile, "";
		Write logfile, "Object Frame (oframe):";
		Write logfile, "  X = " + NumToStr(wobj0.oframe.trans.x, 2) + " mm";
		Write logfile, "  Y = " + NumToStr(wobj0.oframe.trans.y, 2) + " mm";
		Write logfile, "  Z = " + NumToStr(wobj0.oframe.trans.z, 2) + " mm";
		Write logfile, "========================================\0A";

		Close logfile;
		TPWrite "Saved to: /HOME/task1_wobj0_definition.txt";

	ERROR
		TPWrite "ERROR in ShowWobj0Definition: " + NumToStr(ERRNO, 0);
		Close logfile;
		TRYNEXT;
	ENDPROC

	! Version: v1.1.0
	! Date: 2025-12-18
	! Changes: Added file output to /HOME/task1_world_vs_wobj0.txt

	PROC CompareWorldAndWobj0()
		VAR robtarget pos_world;
		VAR robtarget pos_wobj0;
		VAR iodev logfile;

		TPWrite "========================================";
		TPWrite "TASK1 - Compare World vs wobj0 (v1.1.0)";
		TPWrite "========================================";

		pos_world := CRobT(\Tool:=tool0);
		pos_wobj0 := CRobT(\Tool:=tool0\WObj:=wobj0);

		TPWrite "World Coordinates:";
		TPWrite "  X = " + NumToStr(pos_world.trans.x, 2) + " mm";
		TPWrite "  Y = " + NumToStr(pos_world.trans.y, 2) + " mm";
		TPWrite "  Z = " + NumToStr(pos_world.trans.z, 2) + " mm";
		TPWrite "";
		TPWrite "wobj0 Coordinates:";
		TPWrite "  X = " + NumToStr(pos_wobj0.trans.x, 2) + " mm";
		TPWrite "  Y = " + NumToStr(pos_wobj0.trans.y, 2) + " mm";
		TPWrite "  Z = " + NumToStr(pos_wobj0.trans.z, 2) + " mm";
		TPWrite "";
		TPWrite "Difference (World - wobj0):";
		TPWrite "  dX = " + NumToStr(pos_world.trans.x - pos_wobj0.trans.x, 2) + " mm";
		TPWrite "  dY = " + NumToStr(pos_world.trans.y - pos_wobj0.trans.y, 2) + " mm";
		TPWrite "  dZ = " + NumToStr(pos_world.trans.z - pos_wobj0.trans.z, 2) + " mm";
		TPWrite "========================================";

		! Save to file
		Open "/HOME/", logfile \Write;
		Open "task1_world_vs_wobj0.txt", logfile \Append;

		Write logfile, "========================================";
		Write logfile, "TASK1 - Compare World vs wobj0 (v1.1.0)";
		Write logfile, "========================================";
		Write logfile, "Date: " + CDate();
		Write logfile, "Time: " + CTime();
		Write logfile, "";
		Write logfile, "World Coordinates:";
		Write logfile, "  X = " + NumToStr(pos_world.trans.x, 2) + " mm";
		Write logfile, "  Y = " + NumToStr(pos_world.trans.y, 2) + " mm";
		Write logfile, "  Z = " + NumToStr(pos_world.trans.z, 2) + " mm";
		Write logfile, "";
		Write logfile, "wobj0 Coordinates:";
		Write logfile, "  X = " + NumToStr(pos_wobj0.trans.x, 2) + " mm";
		Write logfile, "  Y = " + NumToStr(pos_wobj0.trans.y, 2) + " mm";
		Write logfile, "  Z = " + NumToStr(pos_wobj0.trans.z, 2) + " mm";
		Write logfile, "";
		Write logfile, "Difference (World - wobj0):";
		Write logfile, "  dX = " + NumToStr(pos_world.trans.x - pos_wobj0.trans.x, 2) + " mm";
		Write logfile, "  dY = " + NumToStr(pos_world.trans.y - pos_wobj0.trans.y, 2) + " mm";
		Write logfile, "  dZ = " + NumToStr(pos_world.trans.z - pos_wobj0.trans.z, 2) + " mm";
		Write logfile, "========================================\0A";

		Close logfile;
		TPWrite "Saved to: /HOME/task1_world_vs_wobj0.txt";

	ERROR
		TPWrite "ERROR in CompareWorldAndWobj0: " + NumToStr(ERRNO, 0);
		Close logfile;
		TRYNEXT;
	ENDPROC

	! ========================================
	! Verify TCP Orientation in All Coordinate Systems
	! ========================================
	! Version: v1.2.1
	! Date: 2025-12-19
	! Changes: Fixed "Too intense frequency of Write" error by adding WaitTime
	! Purpose: Compare TCP position and orientation in 4 coordinate systems:
	!   1. World - Global coordinate system
	!   2. wobj0 - Default work object (= World in current config)
	!   3. WobjFloor - Floor coordinate system at [-9500, 5300, 2100]
	!   4. wobjRob1Base - Robot1 Base Frame (GantryRob with Y-axis 90° rotation)
	! Output: FlexPendant display + /HOME/task1_tcp_orientation.txt
	PROC VerifyTCPOrientation()
		VAR robtarget tcp_world;
		VAR robtarget tcp_wobj0;
		VAR robtarget tcp_floor;
		VAR robtarget tcp_rob_base;
		VAR iodev logfile;

		! Read TCP in all coordinate systems
		tcp_world := CRobT(\Tool:=tool0);
		tcp_wobj0 := CRobT(\Tool:=tool0\WObj:=wobj0);
		tcp_floor := CRobT(\Tool:=tool0\WObj:=WobjFloor);
		tcp_rob_base := CRobT(\Tool:=tool0\WObj:=wobjRob1Base);

		! Display on FlexPendant (reduced output)
		TPWrite "TASK1 - TCP Orientation (v1.2.1)";
		TPWrite "World: [" + NumToStr(tcp_world.trans.x, 1) + "," + NumToStr(tcp_world.trans.y, 1) + "," + NumToStr(tcp_world.trans.z, 1) + "]";
		TPWrite "Floor: [" + NumToStr(tcp_floor.trans.x, 1) + "," + NumToStr(tcp_floor.trans.y, 1) + "," + NumToStr(tcp_floor.trans.z, 1) + "]";
		TPWrite "Rob1Base: [" + NumToStr(tcp_rob_base.trans.x, 1) + "," + NumToStr(tcp_rob_base.trans.y, 1) + "," + NumToStr(tcp_rob_base.trans.z, 1) + "]";

		! Save to file (with WaitTime to prevent "Too intense frequency" error)
		Open "HOME:/task1_tcp_orientation.txt", logfile \Append;

		Write logfile, "========================================";
		Write logfile, "TASK1 - TCP Orientation Verification (v1.2.1)";
		Write logfile, "Date: " + CDate() + " " + CTime();
		Write logfile, "========================================";
		WaitTime 0.05;

		Write logfile, "1. World: Pos=[" + NumToStr(tcp_world.trans.x, 3) + "," + NumToStr(tcp_world.trans.y, 3) + "," + NumToStr(tcp_world.trans.z, 3) + "]";
		Write logfile, "   Rot=[" + NumToStr(tcp_world.rot.q1, 6) + "," + NumToStr(tcp_world.rot.q2, 6) + "," + NumToStr(tcp_world.rot.q3, 6) + "," + NumToStr(tcp_world.rot.q4, 6) + "]";
		WaitTime 0.05;

		Write logfile, "2. wobj0: Pos=[" + NumToStr(tcp_wobj0.trans.x, 3) + "," + NumToStr(tcp_wobj0.trans.y, 3) + "," + NumToStr(tcp_wobj0.trans.z, 3) + "]";
		Write logfile, "   Rot=[" + NumToStr(tcp_wobj0.rot.q1, 6) + "," + NumToStr(tcp_wobj0.rot.q2, 6) + "," + NumToStr(tcp_wobj0.rot.q3, 6) + "," + NumToStr(tcp_wobj0.rot.q4, 6) + "]";
		WaitTime 0.05;

		Write logfile, "3. Floor: Pos=[" + NumToStr(tcp_floor.trans.x, 3) + "," + NumToStr(tcp_floor.trans.y, 3) + "," + NumToStr(tcp_floor.trans.z, 3) + "]";
		Write logfile, "   Rot=[" + NumToStr(tcp_floor.rot.q1, 6) + "," + NumToStr(tcp_floor.rot.q2, 6) + "," + NumToStr(tcp_floor.rot.q3, 6) + "," + NumToStr(tcp_floor.rot.q4, 6) + "]";
		WaitTime 0.05;

		Write logfile, "4. Rob1Base: Pos=[" + NumToStr(tcp_rob_base.trans.x, 3) + "," + NumToStr(tcp_rob_base.trans.y, 3) + "," + NumToStr(tcp_rob_base.trans.z, 3) + "]";
		Write logfile, "   Rot=[" + NumToStr(tcp_rob_base.rot.q1, 6) + "," + NumToStr(tcp_rob_base.rot.q2, 6) + "," + NumToStr(tcp_rob_base.rot.q3, 6) + "," + NumToStr(tcp_rob_base.rot.q4, 6) + "]";
		WaitTime 0.05;

		Write logfile, "========================================\0A";

		Close logfile;
		TPWrite "Saved to: /HOME/task1_tcp_orientation.txt";

	ERROR
		TPWrite "ERROR in VerifyTCPOrientation: " + NumToStr(ERRNO, 0);
		Close logfile;
		TRYNEXT;
	ENDPROC

ENDMODULE