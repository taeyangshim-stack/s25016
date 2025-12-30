MODULE MainModule
	!========================================
	! TASK1 (Robot1) - MainModule
	! Version History
	!========================================
	! v1.0.0 (2025-12-17)
	!   - Initial gantry position sharing system
	!   - Added shared_gantry_pos and related variables
	!   - Created UpdateSharedGantryPosition procedure
	!
	! v1.1.0 (2025-12-18)
	!   - Added wobj0 definition verification
	!   - ShowWobj0Definition procedure with file output
	!   - CompareWorldAndWobj0 procedure
	!   - Output to /HOME/task1_wobj0_definition.txt
	!
	! v1.2.0 (2025-12-18)
	!   - Added Work Object definitions
	!   - WobjFloor: Floor coordinate at [-9500, 5300, 2100] with RX 180° rotation
	!   - wobjRob1Base: GantryRob coordinate with Y-axis 90° rotation
	!
	! v1.2.1 (2025-12-19)
	!   - Fixed "Too intense frequency of Write" error (41617)
	!   - Added WaitTime 0.05 between Write operations
	!   - VerifyTCPOrientation procedure for 4 coordinate systems
	!
	! v1.3.0 (2025-12-23)
	!   - Added TestCoordinateMovement procedure
	!   - Move TCP and verify wobj0 vs Floor coordinate changes
	!   - Output to /HOME/task1_coordinate_test.txt
	!
	! v1.4.0 (2025-12-23)
	!   - Added MoveToMiddlePosition procedure
	!   - Added TestGantryAxisMovement procedure
	!   - Added TestGantryX/Y/Z quick test procedures
	!
	! v1.4.1 (2025-12-23)
	!   - Fixed Reference Error 50366
	!   - Removed MoveToMiddlePosition calls
	!   - Changed to relative movement only
	!
	! v1.4.2 (2025-12-24)
	!   - Added Robot TCP coordinate movement tests
	!   - TestRobot1_X, TestRobot1_Y, TestRobot1_Z procedures
	!
	! v1.4.3 (2025-12-24)
	!   - Combined X/Y/Z tests into single procedure
	!   - TestRobot1_XYZ replaces separate axis tests
	!   - Movement: [30, 20, 10] mm
	!
	! v1.4.4 (2025-12-24)
	!   - Reduced movement to avoid joint limits
	!   - Changed from [300, 200, 100] to [30, 20, 10]
	!   - Prevents 50050 "Position outside reach" error
	!
	! v1.4.5 (2025-12-24)
	!   - Added return to start position
	!   - Increased movement back to [50, 30, 20]
	!   - Save start position and return after test
	!
	! v1.4.6 (2025-12-24)
	!   - Start from home position (all 6 axes = 0°)
	!   - Keep gantry position unchanged
	!   - Return to original joint position after test
	!
	! v1.4.7 (2025-12-24)
	!   - Avoid wrist singularity
	!   - Home position: [-90, 0, 0, 0, 30, 0] (J5 = 30°)
	!
	! v1.5.0 (2025-12-24)
	!   - Added config.txt MODE support
	!   - ReadConfigMode() function reads /HOME/config.txt
	!   - Robot1 always uses wobj0 (MODE independent)
	!   - Display MODE for consistency with Robot2
	!
	! v1.7.28 (2025-12-29)
	!   - Added SetRobot1InitialPosition procedure
	!   - Robot1: [-90,0,0,0,0,0], Gantry: HOME position
	!
	! v1.7.29 (2025-12-29)
	!   - Fixed Z-axis out of range error (50027)
	!   - Changed HOME Z from 2100 to 700 (within physical limit)
	!
	! v1.7.30 (2025-12-29)
	!   - Moved TestGantryFloorCoordinates from TASK2 to TASK1
	!   - Changed HOME to physical origin [0,0,0,0]
	!   - HOME Physical [0,0,0,0] = Floor [9500,5300,2100,0]
	!
	! v1.7.31 (2025-12-30)
	!   - Added UpdateRobot2FloorPositionLocal to TASK1
	!   - Added WobjFloor_Rob2 and robot2_floor_pos
	!   - Support cross-task Robot2 measurement from TASK1
	!
	! v1.7.32 (2025-12-30)
	!   - Fixed Floor->Physical coordinate transformation
	!   - Physical = Floor_offset - HOME_offset
	!   - Y, Z, R use subtraction due to Rx 180° rotation
	!
	! v1.7.33 (2025-12-30)
	!   - Added X1-X2 synchronization in TestGantryFloorCoordinates
	!   - Prevent linked motor error 50246
	!
	! v1.7.34 (2025-12-30)
	!   - SetRobot1InitialPosition: Read position after robot movement
	!   - Changed home_pos := initial_pos -> home_pos := CJointT()
	!
	! v1.7.35 (2025-12-30)
	!   - SetRobot1InitialPosition: 2-step move to prevent error 50246
	!   - Step 1: Synchronize X1-X2 at current position
	!   - Step 2: Move all axes to HOME [0,0,0,0]
	!
	! v1.7.36 (2025-12-30)
	!   - SetRobot1InitialPosition: Re-read position in Step 2
	!   - Added home_pos := CJointT() after Step 1 movement
	!   - Ensures X1-X2 synchronization with actual current position
	!
	! v1.7.37 (2025-12-30)
	!   - SetRobot1InitialPosition: Added debug TPWrite messages
	!   - Display X1, X2 values before/after Step 1 synchronization
	!   - Display current position before Step 2 HOME movement
	!
	! v1.7.38 (2025-12-30)
	!   - Fixed Robot2 Floor measurement in TestGantryFloorCoordinates
	!   - Changed robot2_floor_pos to alias referencing TASK2's variable
	!   - Removed incorrect UpdateRobot2FloorPositionLocal (used wrong WObj)
	!   - Removed WobjFloor_Rob2 from TASK1 (only in TASK2)
	!   - TASK2 now updates robot2_floor_pos automatically via rUpdateR2Position
	!========================================

	TASK PERS seamdata seam1:=[0.5,0.5,[5,0,24,120,0,0,0,0,0],0.5,1,10,0,5,[5,0,24,120,0,0,0,0,0],0,1,[5,0,24,120,0,0,0,0,0],0,0,[0,0,0,0,0,0,0,0,0],0];
	TASK PERS welddata weld1:=[6,0,[5,0,24,120,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
	TASK PERS weavedata weave1_rob1:=[1,0,3,4,0,0,0,0,0,0,0,0,0,0,0];
    PERS tooldata tWeld1:=[TRUE,[[319.938,-6.311,330],[0.92587,0.003729,0.377818,-0.009129]],[3.1,[-71.4,3.8,173.2],[1,0,0,0],0.055,0.049,0.005]];
	TASK PERS trackdata track1_rob1:=[0,FALSE,0,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
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
	TASK PERS jointtarget jTemp_rob1:=[[0,-2.51761,-12.1411,0,15.6587,0],[-500,500,300,15,0,-28.6479]];
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

	! Robot Position Monitoring (v1.5.1 2025-12-25)
	! Robot1 TCP position in Floor coordinate system (for distance measurement)
	! Shared across tasks - use PERS (not TASK PERS) for cross-task access
	PERS robtarget robot1_floor_pos := [[0,0,0],[1,0,0,0],[0,0,0,0],[0,0,0,0,0,0]];
	! Robot2 TCP position in Floor coordinate system (from TASK2)
	! External reference - initialized and updated by TASK2
	PERS robtarget robot2_floor_pos;
	! Robot1 wobj0 snapshot for cross-task comparison
	PERS wobjdata robot1_wobj0_snapshot := [FALSE, TRUE, "", [[0,0,0],[1,0,0,0]], [[0,0,0],[1,0,0,0]]];

	! Work Object Definitions (v1.7.7 2025-12-28)
	! WobjFloor: Floor coordinate system for Robot1
	PERS wobjdata WobjFloor := [FALSE, TRUE, "", [[-9500, 5300, 2100], [0, 1, 0, 0]], [[0, 0, 0], [1, 0, 0, 0]]];

	! wobjRob1Base: Robot1 Base Frame = GantryRob coordinate system (Y-axis 90° rotation)
	! Quaternion [0, 0.707107, 0, 0.707107] = Y-axis 90° rotation
	PERS wobjdata wobjRob1Base := [FALSE, TRUE, "", [[0, 0, 0], [0, 0.707107, 0, 0.707107]], [[0, 0, 0], [1, 0, 0, 0]]];

	PROC main()
		! Test sequence: Initialize robots and run gantry floor coordinate test
		SetRobot1InitialPosition;
		WaitTime 1.0;
		TestGantryFloorCoordinates;
		! Original: rUpdateR1Position;
	ENDPROC
    
    PROC rUpdateR1Position()
        VAR num X;
        VAR num Y;
        VAR num Z;
        VAR num R;
        VAR num X1;
        VAR num Y1;
        VAR num Z1;
        !        jTemp_rob1:=[[0,0,0,0,0,0],[0,0,0,30,0,0]];
        jTemp_rob1 := CJointT(\TaskName:="T_ROB1");

        X:=jTemp_rob1.extax.eax_a;
        Y:=jTemp_rob1.extax.eax_b;
        Z:=jTemp_rob1.extax.eax_c;
        R:=jTemp_rob1.extax.eax_d;

        X1:=X+(488*cos(R));
        !X2:=X-(976*cos(R));
        Y1:=Y+(488*sin(R));
        !Y2:=Y-(976*sin(R));

        nCaledR1Pos:=[X1,Y1,Z];
    ENDPROC
	PROC mainCopy()
		SyncMoveOn Sync1, Alltask;
		MoveL [[2094.90,-367.86,12453.71],[0.0969749,-0.464748,0.371902,-0.79768],[-1,-1,0,1],[12000,470.018,767.656,0.000203368,0,12000]]\ID:=40, v1000, z50, tWeld1;
		ArcLStart [[2094.96,-367.84,12453.68],[0.0969752,-0.464783,0.371888,-0.797666],[-1,-1,0,1],[12000,470.019,767.664,0.000203368,0,12000]]\ID:=10, v1000, seam1, weld1\Weave:=weave1_rob1, fine, tWeld1;
		ArcL [[2094.90,-367.87,12453.71],[0.0969776,-0.464746,0.371904,-0.79768],[-1,-1,0,1],[12000,470.018,767.656,0.000203368,0,12000]]\ID:=20, v1000, seam1, weld1\Weave:=weave1_rob1, z10, tWeld1;
		ArcLEnd [[2095.02,-367.83,11972.6],[0.0969842,-0.464821,0.371896,-0.79764],[-1,-1,0,1],[11519,470.018,767.679,0.000102576,0,11519]]\ID:=30, v1000, seam1, weld1\Weave:=weave1_rob1, fine, tWeld1;
		SyncMoveOff Sync1;
		!MoveL [[2094.90,-367.87,12453.71],[0.0969765,-0.464746,0.371905,-0.79768],[-1,-1,0,1],[12000,470.018,767.656,0.000203368,0,12000]], v1000, z50, tWeld1;
		WaitTime 3;
		!Search_1D pose1, [[2103.66,-574.48,11839.24],[0.196295,0.468915,0.294361,0.809282],[-1,-1,-1,1],[11656.7,1147.82,753.091,-49.1263,0,11656.7]], [[2117.43,-574.48,11839.25],[0.196294,0.468909,0.29436,0.809287],[-1,-1,-1,1],[11656.7,1147.82,753.087,-49.1263,0,11656.7]], v1000, tWeld1;
	ENDPROC
	PROC rFinal_200()
		MoveL [[2047.28,-525.15,12164.96],[0.0970333,-0.465179,0.371637,-0.797546],[-1,-1,-1,1],[11915.7,595.667,723.906,0.000203368,0,11915.7]], v1000, z50, tWeld1;
		WaitSyncTask Sync1, Alltask;
		SyncMoveOn Sync1, Alltask;
		ArcLStart [[2103.49,-543.85,12164.96],[0.114652,-0.524236,0.379809,-0.75351],[-1,-1,-1,1],[11915.7,595.666,723.906,0.000203368,0,11915.7]]\ID:=10, v1000, seam1, weld1\Weave:=weave1_rob1, fine, tWeld1;
		ArcL [[2103.49,-508.95,12164.96],[0.114648,-0.524233,0.379808,-0.753513],[-1,-1,0,1],[11915.7,595.666,723.906,0.000203368,0,11915.7]]\ID:=20, v1000, seam1, weld1\Weave:=weave1_rob1, z10, tWeld1;
		ArcL [[2103.49,-508.95,12064.02],[0.114649,-0.524232,0.379809,-0.753513],[-1,-1,-1,1],[11915.7,595.666,723.906,0.000203368,0,11915.7]]\ID:=30, v1000, seam1, weld1\Weave:=weave1_rob1, z10, tWeld1;
		ArcL [[2102.86,-509.83,11932.99],[0.114649,-0.524234,0.379807,-0.753512],[-1,-1,-1,1],[11784.6,596.544,723.906,0.000203368,0,11784.6]]\ID:=40, v1000, seam1, weld1\Weave:=weave1_rob1, z10, tWeld1;
		ArcL [[2102.86,-510.25,11598.24],[0.114651,-0.524236,0.379808,-0.75351],[-1,-1,-1,1],[11449.9,596.97,723.906,0.000203368,0,11449.9]]\ID:=50, v1000, seam1, weld1\Weave:=weave1_rob1, z10, tWeld1;
		ArcL [[2100.63,-510.26,11501.35],[0.114648,-0.524237,0.37981,-0.753508],[-1,-1,-1,1],[11449.9,596.97,723.906,0.00030416,0,11449.9]]\ID:=70, v1000, seam1, weld1\Weave:=weave1_rob1, z10, tWeld1;
		ArcLEnd [[2100.64,-536.41,11501.35],[0.114652,-0.524234,0.379806,-0.753512],[-1,-1,-1,1],[11449.9,596.97,723.906,0.00030416,0,11449.9]]\ID:=60, v1000, seam1, weld1\Weave:=weave1_rob1, fine, tWeld1;
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
		!ArcLStart [[2103.49,-543.85,12164.96],[0.114652,-0.524236,0.379809,-0.75351],[-1,-1,-1,1],[11915.7,595.666,723.906,0.000203368,0,11915.7]]\ID:=10, v1000, seam1, weld1\Weave:=weave1_rob1, fine, tWeld1;
		!ArcL [[2103.49,-508.95,12164.96],[0.114648,-0.524233,0.379808,-0.753513],[-1,-1,0,1],[11915.7,595.666,723.906,0.000203368,0,11915.7]]\ID:=20, v1000, seam1, weld1\Weave:=weave1_rob1, z10, tWeld1;
		SyncMoveOn sync3, Alltask;
		ArcL [[2103.49,-508.95,12064.02],[0.114649,-0.524232,0.379809,-0.753513],[-1,-1,-1,1],[11915.7,595.666,723.906,0.000203368,0,11915.7]]\ID:=30, v1000, seam1, weld1\Weave:=weave1_rob1, z10, tWeld1;
		ArcL [[2102.86,-509.83,11932.99],[0.114649,-0.524234,0.379807,-0.753512],[-1,-1,-1,1],[11784.6,596.544,723.906,0.000203368,0,11784.6]]\ID:=40, v1000, seam1, weld1\Weave:=weave1_rob1, z10, tWeld1;
		ArcL [[2102.86,-510.25,11598.24],[0.114651,-0.524236,0.379808,-0.75351],[-1,-1,-1,1],[11449.9,596.97,723.906,0.000203368,0,11449.9]]\ID:=50, v1000, seam1, weld1\Weave:=weave1_rob1, z10, tWeld1;
		ArcL [[2100.63,-510.26,11501.35],[0.114648,-0.524237,0.37981,-0.753508],[-1,-1,-1,1],[11449.9,596.97,723.906,0.00030416,0,11449.9]]\ID:=70, v1000, seam1, weld1\Weave:=weave1_rob1, z10, tWeld1;
		ArcLEnd [[2100.64,-536.41,11501.35],[0.114652,-0.524234,0.379806,-0.753512],[-1,-1,-1,1],[11449.9,596.97,723.906,0.00030416,0,11449.9]]\ID:=60, v1000, seam1, weld1\Weave:=weave1_rob1, fine, tWeld1;
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
		ArcLStart [[2107.92,42.66,11799.75],[0.196617,0.468748,0.294994,0.809071],[-1,-1,-1,1],[11633.2,533.996,743.134,-49.2176,0,11633.2]], v1000, seam1, weld1\Weave:=weave1_rob1, fine, tWeld1\Track:=track1_rob1;
		ArcL [[2121.40,-108.42,11808.55],[0.196642,0.46866,0.295016,0.809108],[-1,-1,-1,1],[11633.2,533.997,743.12,-49.2176,0,11633.2]], v1000, seam1, weld1\Weave:=weave1_rob1, z10, tWeld1\Track:=track1_rob1;
		ArcL [[2121.40,-149.65,11815.47],[0.196646,0.46866,0.295015,0.809107],[-1,-1,-1,1],[11633.2,533.997,743.12,-49.2176,0,11633.2]], v1000, seam1, weld1\Weave:=weave1_rob1, z10, tWeld1\Track:=track1_rob1;
		ArcLEnd [[2121.40,-291.89,11809.14],[0.196651,0.468665,0.295018,0.809102],[-1,-1,-1,1],[11633.2,533.997,743.12,-49.2176,0,11633.2]], v1000, seam1, weld1\Weave:=weave1_rob1, fine, tWeld1\Track:=track1_rob1;
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
	! Update Robot1 wobj0 Snapshot
	!========================================
	! Version: v1.6.0
	! Date: 2025-12-25
	! Purpose: Share Robot1 wobj0 data with other tasks
	PROC UpdateRobot1Wobj0Snapshot()
		robot1_wobj0_snapshot := wobj0;
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

	! ========================================
	! Read Config Mode from /HOME/config.txt
	! ========================================
	! Version: v1.5.0
	! Date: 2025-12-24
	! Returns: 0 or 1 (default: 0 if file not found or error)
	FUNC num ReadConfigMode()
		VAR iodev configfile;
		VAR string line;
		VAR num mode_value;
		VAR bool found;
		VAR bool ok;

		mode_value := 0;  ! Default
		found := FALSE;

		! Try to open config.txt
		Open "HOME:/config.txt", configfile \Read;

		! Read lines until MODE= found
		WHILE found = FALSE DO
			line := ReadStr(configfile);

			! Check if line starts with "MODE="
			IF StrFind(line, 1, "MODE=") = 1 THEN
				! Extract number after "MODE=" (StrToVal returns bool, stores result in mode_value)
				ok := StrToVal(StrPart(line, 6, 1), mode_value);
				found := TRUE;
			ENDIF
		ENDWHILE

		Close configfile;
		RETURN mode_value;

	ERROR
		! File not found or read error - return default 0
		IF ERRNO = ERR_FILEOPEN THEN
			TPWrite "config.txt not found - using MODE=0";
		ENDIF
		Close configfile;
		RETURN 0;
	ENDFUNC

	! ========================================
	! Test Coordinate System Movement
	! ========================================
	! Version: v1.5.0
	! Date: 2025-12-24
	! Purpose: Verify coordinate system alignment by moving robot and comparing coordinates
	!   - Move robot in wobj0 coordinate system (Robot1 always uses wobj0)
	!   - Check if Floor coordinate system shows expected movement
	!   - Validates coordinate system direction and position relationship
	! Parameters:
	!   delta_x, delta_y, delta_z: Movement distance in wobj0 coordinates (mm)
	! Output: /HOME/task1_coordinate_test.txt
	PROC TestCoordinateMovement(num delta_x, num delta_y, num delta_z)
		VAR robtarget pos_start_wobj0;
		VAR robtarget pos_start_floor;
		VAR robtarget pos_target;
		VAR robtarget pos_end_wobj0;
		VAR robtarget pos_end_floor;
		VAR num diff_wobj0_x;
		VAR num diff_wobj0_y;
		VAR num diff_wobj0_z;
		VAR num diff_floor_x;
		VAR num diff_floor_y;
		VAR num diff_floor_z;
		VAR iodev logfile;

		! Read starting position in both coordinate systems
		pos_start_wobj0 := CRobT(\Tool:=tool0\WObj:=wobj0);
		pos_start_floor := CRobT(\Tool:=tool0\WObj:=WobjFloor);

		TPWrite "Start wobj0: [" + NumToStr(pos_start_wobj0.trans.x, 1) + "," + NumToStr(pos_start_wobj0.trans.y, 1) + "," + NumToStr(pos_start_wobj0.trans.z, 1) + "]";
		TPWrite "Start Floor: [" + NumToStr(pos_start_floor.trans.x, 1) + "," + NumToStr(pos_start_floor.trans.y, 1) + "," + NumToStr(pos_start_floor.trans.z, 1) + "]";

		! Calculate target position (wobj0 + delta)
		pos_target := pos_start_wobj0;
		pos_target.trans.x := pos_target.trans.x + delta_x;
		pos_target.trans.y := pos_target.trans.y + delta_y;
		pos_target.trans.z := pos_target.trans.z + delta_z;

		TPWrite "Moving wobj0: [" + NumToStr(delta_x, 1) + "," + NumToStr(delta_y, 1) + "," + NumToStr(delta_z, 1) + "]";

		! Move to target position
		MoveL pos_target, v100, fine, tool0\WObj:=wobj0;

		! Read ending position in both coordinate systems
		pos_end_wobj0 := CRobT(\Tool:=tool0\WObj:=wobj0);
		pos_end_floor := CRobT(\Tool:=tool0\WObj:=WobjFloor);

		TPWrite "End wobj0: [" + NumToStr(pos_end_wobj0.trans.x, 1) + "," + NumToStr(pos_end_wobj0.trans.y, 1) + "," + NumToStr(pos_end_wobj0.trans.z, 1) + "]";
		TPWrite "End Floor: [" + NumToStr(pos_end_floor.trans.x, 1) + "," + NumToStr(pos_end_floor.trans.y, 1) + "," + NumToStr(pos_end_floor.trans.z, 1) + "]";

		! Calculate differences
		diff_wobj0_x := pos_end_wobj0.trans.x - pos_start_wobj0.trans.x;
		diff_wobj0_y := pos_end_wobj0.trans.y - pos_start_wobj0.trans.y;
		diff_wobj0_z := pos_end_wobj0.trans.z - pos_start_wobj0.trans.z;

		diff_floor_x := pos_end_floor.trans.x - pos_start_floor.trans.x;
		diff_floor_y := pos_end_floor.trans.y - pos_start_floor.trans.y;
		diff_floor_z := pos_end_floor.trans.z - pos_start_floor.trans.z;

		TPWrite "wobj0 moved: [" + NumToStr(diff_wobj0_x, 1) + "," + NumToStr(diff_wobj0_y, 1) + "," + NumToStr(diff_wobj0_z, 1) + "]";
		TPWrite "Floor moved: [" + NumToStr(diff_floor_x, 1) + "," + NumToStr(diff_floor_y, 1) + "," + NumToStr(diff_floor_z, 1) + "]";

		! Save to file
		Open "HOME:/task1_coordinate_test.txt", logfile \Append;

		Write logfile, "========================================";
		Write logfile, "TASK1 - Coordinate System Movement Test (v1.3.0)";
		Write logfile, "Date: " + CDate() + " " + CTime();
		Write logfile, "========================================";
		WaitTime 0.05;

		Write logfile, "Command: Move wobj0 [" + NumToStr(delta_x, 3) + "," + NumToStr(delta_y, 3) + "," + NumToStr(delta_z, 3) + "]";
		WaitTime 0.05;

		Write logfile, "Start wobj0: [" + NumToStr(pos_start_wobj0.trans.x, 3) + "," + NumToStr(pos_start_wobj0.trans.y, 3) + "," + NumToStr(pos_start_wobj0.trans.z, 3) + "]";
		Write logfile, "Start Floor: [" + NumToStr(pos_start_floor.trans.x, 3) + "," + NumToStr(pos_start_floor.trans.y, 3) + "," + NumToStr(pos_start_floor.trans.z, 3) + "]";
		WaitTime 0.05;

		Write logfile, "End wobj0: [" + NumToStr(pos_end_wobj0.trans.x, 3) + "," + NumToStr(pos_end_wobj0.trans.y, 3) + "," + NumToStr(pos_end_wobj0.trans.z, 3) + "]";
		Write logfile, "End Floor: [" + NumToStr(pos_end_floor.trans.x, 3) + "," + NumToStr(pos_end_floor.trans.y, 3) + "," + NumToStr(pos_end_floor.trans.z, 3) + "]";
		WaitTime 0.05;

		Write logfile, "wobj0 moved: [" + NumToStr(diff_wobj0_x, 3) + "," + NumToStr(diff_wobj0_y, 3) + "," + NumToStr(diff_wobj0_z, 3) + "]";
		Write logfile, "Floor moved: [" + NumToStr(diff_floor_x, 3) + "," + NumToStr(diff_floor_y, 3) + "," + NumToStr(diff_floor_z, 3) + "]";
		WaitTime 0.05;

		Write logfile, "Verification: If wobj0 and Floor have same direction,";
		Write logfile, "  movement should be identical in both coordinate systems.";
		Write logfile, "========================================\0A";

		Close logfile;
		TPWrite "Saved to: /HOME/task1_coordinate_test.txt";

	ERROR
		TPWrite "ERROR in TestCoordinateMovement: " + NumToStr(ERRNO, 0);
		Close logfile;
		TRYNEXT;
	ENDPROC

	! ========================================
	! Move to Safe Middle Position
	! ========================================
	! Version: v1.4.0
	! Date: 2025-12-23
	! Purpose: Move gantry to middle of stroke range for safe testing
	! Middle positions: M1=1.4m, M2=2.65m, M3=0.5m
	PROC MoveToMiddlePosition()
		VAR jointtarget middle_pos;

		TPWrite "Moving to middle position...";

		middle_pos := CJointT();

		! Set gantry axes to middle positions (safe testing position)
		middle_pos.extax.eax_a := 1400;     ! M1DM3 middle: (-9.51+12.31)/2 = 1.4m = 1400mm
		middle_pos.extax.eax_b := 2650;     ! M2DM3 middle: (-0.05+5.35)/2 = 2.65m = 2650mm
		middle_pos.extax.eax_c := 500;      ! M3DM3 middle: (-0.05+1.05)/2 = 0.5m = 500mm

		MoveAbsJ middle_pos, v100, fine, tool0;

		TPWrite "Reached middle position";
	ENDPROC

	! ========================================
	! Test Gantry Axis Movement
	! ========================================
	! Version: v1.4.0
	! Date: 2025-12-23
	! Purpose: Move gantry joint axes and compare wobj0 vs Floor coordinate changes
	! Parameters:
	!   delta_m1 - M1DM3 (X axis) movement in mm
	!   delta_m2 - M2DM3 (Y axis) movement in mm
	!   delta_m3 - M3DM3 (Z axis) movement in mm
	PROC TestGantryAxisMovement(num delta_m1, num delta_m2, num delta_m3)
		VAR jointtarget joints_start;
		VAR jointtarget joints_end;
		VAR robtarget tcp_start_wobj0;
		VAR robtarget tcp_end_wobj0;
		VAR robtarget tcp_start_floor;
		VAR robtarget tcp_end_floor;
		VAR num wobj0_dx;
		VAR num wobj0_dy;
		VAR num wobj0_dz;
		VAR num floor_dx;
		VAR num floor_dy;
		VAR num floor_dz;
		VAR iodev logfile;

		! Read starting positions
		joints_start := CJointT();
		tcp_start_wobj0 := CRobT(\Tool:=tool0\WObj:=wobj0);
		tcp_start_floor := CRobT(\Tool:=tool0\WObj:=WobjFloor);

		TPWrite "Start - Gantry: M1=" + NumToStr(joints_start.extax.eax_a, 1) + " M2=" + NumToStr(joints_start.extax.eax_b, 1) + " M3=" + NumToStr(joints_start.extax.eax_c, 1);

		! Calculate target joint position
		joints_end := joints_start;
		joints_end.extax.eax_a := joints_end.extax.eax_a + delta_m1;
		joints_end.extax.eax_b := joints_end.extax.eax_b + delta_m2;
		joints_end.extax.eax_c := joints_end.extax.eax_c + delta_m3;

		! Move gantry
		MoveAbsJ joints_end, v100, fine, tool0;

		! Read ending positions
		tcp_end_wobj0 := CRobT(\Tool:=tool0\WObj:=wobj0);
		tcp_end_floor := CRobT(\Tool:=tool0\WObj:=WobjFloor);

		TPWrite "End - Gantry: M1=" + NumToStr(joints_end.extax.eax_a, 1) + " M2=" + NumToStr(joints_end.extax.eax_b, 1) + " M3=" + NumToStr(joints_end.extax.eax_c, 1);

		! Calculate TCP changes
		wobj0_dx := tcp_end_wobj0.trans.x - tcp_start_wobj0.trans.x;
		wobj0_dy := tcp_end_wobj0.trans.y - tcp_start_wobj0.trans.y;
		wobj0_dz := tcp_end_wobj0.trans.z - tcp_start_wobj0.trans.z;

		floor_dx := tcp_end_floor.trans.x - tcp_start_floor.trans.x;
		floor_dy := tcp_end_floor.trans.y - tcp_start_floor.trans.y;
		floor_dz := tcp_end_floor.trans.z - tcp_start_floor.trans.z;

		! Save to file
		Open "HOME:/task1_gantry_test.txt", logfile \Append;
		Write logfile, "========================================";
		Write logfile, "TASK1 - Gantry Axis Movement Test (v1.4.0)";
		Write logfile, "Date: " + CDate() + " " + CTime();
		Write logfile, "========================================";
		WaitTime 0.05;
		Write logfile, "Gantry Joint Movement: M1=" + NumToStr(delta_m1, 1) + "mm, M2=" + NumToStr(delta_m2, 1) + "mm, M3=" + NumToStr(delta_m3, 1) + "mm";
		WaitTime 0.05;
		Write logfile, "wobj0 TCP moved: [" + NumToStr(wobj0_dx, 3) + ", " + NumToStr(wobj0_dy, 3) + ", " + NumToStr(wobj0_dz, 3) + "] mm";
		WaitTime 0.05;
		Write logfile, "Floor TCP moved: [" + NumToStr(floor_dx, 3) + ", " + NumToStr(floor_dy, 3) + ", " + NumToStr(floor_dz, 3) + "] mm";
		WaitTime 0.05;
		Write logfile, "========================================";
		Close logfile;

		TPWrite "Saved to: task1_gantry_test.txt";
	ENDPROC

	! ========================================
	! Quick Test - Gantry X Axis Movement
	! ========================================
	! Version: v1.4.1
	! Date: 2025-12-23
	! Purpose: Test M1DM3 (Gantry X) +1000mm movement from current position
	PROC TestGantryX()
		TPWrite "TASK1 - Gantry X Axis Test";
		TPWrite "Testing M1DM3 (X axis) +1000mm";
		TestGantryAxisMovement 1000, 0, 0;
		TPWrite "Test complete!";
	ENDPROC

	! ========================================
	! Quick Test - Gantry Y Axis Movement
	! ========================================
	PROC TestGantryY()
		TPWrite "TASK1 - Gantry Y Axis Test";
		TPWrite "Testing M2DM3 (Y axis) +500mm";
		TestGantryAxisMovement 0, 500, 0;
		TPWrite "Test complete!";
	ENDPROC

	! ========================================
	! Quick Test - Gantry Z Axis Movement
	! ========================================
	PROC TestGantryZ()
		TPWrite "TASK1 - Gantry Z Axis Test";
		TPWrite "Testing M3DM3 (Z axis) +200mm";
		TestGantryAxisMovement 0, 0, 200;
		TPWrite "Test complete!";
	ENDPROC

	! ========================================
	! Robot1 TCP Coordinate Test - XYZ Combined with Return
	! ========================================
	! Version: v1.5.0
	! Date: 2025-12-24
	! Purpose: Move Robot1 TCP in wobj0 [X+50, Y+30, Z+20] from home position and return
	! Expected Result (MODE independent - Robot1 always uses wobj0):
	!   Robot1 wobj0 = World coordinate system
	!   Floor = World + offset [-9500, 5300, 2100] + RX 180deg rotation
	!   RX 180deg inverts Y and Z axes
	!   Therefore: wobj0 [+50, +30, +20] -> Floor [+50, -30, -20]
	! Changes from v1.4.7:
	!   - Added config.txt MODE display (Robot1 behavior unchanged)
	!   - Robot1 always uses wobj0 regardless of MODE
	PROC TestRobot1_XYZ()
		VAR jointtarget original_pos;
		VAR jointtarget home_pos;
		VAR num config_mode;

		TPWrite "TASK1 - Robot1 Coordinate Test (v1.5.0)";

		! Read config mode (for display only - Robot1 always uses wobj0)
		config_mode := ReadConfigMode();
		TPWrite "Config MODE=" + NumToStr(config_mode, 0) + " (Robot1 always uses wobj0)";

		! Save original joint position
		original_pos := CJointT();
		TPWrite "Original joint position saved";

		! Create home position (Robot1: [-90,0,0,0,30,0], keep gantry position)
		home_pos := original_pos;
		home_pos.robax.rax_1 := -90;
		home_pos.robax.rax_2 := 0;
		home_pos.robax.rax_3 := 0;
		home_pos.robax.rax_4 := 0;
		home_pos.robax.rax_5 := 30;
		home_pos.robax.rax_6 := 0;

		! Move to home position
		TPWrite "Moving to home position [-90,0,0,0,30,0]...";
		MoveAbsJ home_pos, v100, fine, tool0;
		TPWrite "At home position";

		! Perform coordinate test
		TPWrite "Moving wobj0: [+50, +30, +20]";
		TestCoordinateMovement 50, 30, 20;

		! Return to original joint position
		TPWrite "Returning to original position...";
		MoveAbsJ original_pos, v100, fine, tool0;
		TPWrite "Returned to original position";

		TPWrite "Test complete! Check txt file";
	ENDPROC

	! ========================================
	! Update Robot1 Floor Position
	! ========================================
	! Version: v1.5.1
	! Date: 2025-12-25
	! Purpose: Update Robot1 TCP position in Floor coordinate system
	! Used for distance measurement between robots
	PROC UpdateRobot1FloorPosition()
		robot1_floor_pos := CRobT(\Tool:=tool0\WObj:=WobjFloor);
	ENDPROC

	! ========================================
	! Set Robot1 Initial Position for Gantry Test
	! ========================================
	! Version: v1.7.42
	! Date: 2025-12-30
	! Purpose: Move Robot1 to initial test position
	! Position: Robot1 [-90,0,0,0,0,0], Gantry HOME=[0,0,0,0] (Physical origin)
	! HOME Physical: [0,0,0,0] = Floor [9500,5300,2100,0]
	! Note: Safe from any starting position - synchronizes X1-X2 first
	PROC SetRobot1InitialPosition()
		VAR jointtarget initial_pos;
		VAR jointtarget sync_pos;
		VAR jointtarget home_pos;

		! Step 0: Synchronize X1-X2 at current position (progressive approach)
		! Progressive sync prevents linked motor error when X1-X2 distance is large
		VAR num x1_target;
		VAR num x2_current;
		VAR num distance;

		TPWrite "Step 0: Synchronizing gantry X1-X2 at current position...";
		sync_pos := CJointT();
		TPWrite "Current gantry: X1=" + NumToStr(sync_pos.extax.eax_a,0) + ", X2=" + NumToStr(sync_pos.extax.eax_f,0);

		x1_target := sync_pos.extax.eax_a;
		x2_current := sync_pos.extax.eax_f;
		distance := x1_target - x2_current;

		! If distance > 100mm, use progressive approach (25%, 50%, 75%, 100%)
		IF Abs(distance) > 100 THEN
			TPWrite "Large X1-X2 difference (" + NumToStr(Abs(distance),0) + "mm) - progressive sync";
			sync_pos.extax.eax_f := x2_current + distance * 0.25;
			MoveAbsJ sync_pos, v10, fine, tool0;
			sync_pos.extax.eax_f := x2_current + distance * 0.50;
			MoveAbsJ sync_pos, v10, fine, tool0;
			sync_pos.extax.eax_f := x2_current + distance * 0.75;
			MoveAbsJ sync_pos, v10, fine, tool0;
		ENDIF

		! Final synchronization
		sync_pos.extax.eax_f := x1_target;  ! X2 = X1
		MoveAbsJ sync_pos, v10, fine, tool0;
		TPWrite "Gantry X1-X2 synchronized";

		! Step 1: Move Robot1 joints to initial position
		TPWrite "Step 1: Moving Robot1 to initial position...";
		initial_pos := CJointT();
		! Keep synchronized gantry position
		initial_pos.extax.eax_f := initial_pos.extax.eax_a;
		! Robot1 joint angles: [-90, 0, 0, 0, 0, 0]
		initial_pos.robax.rax_1 := -90;
		initial_pos.robax.rax_2 := 0;
		initial_pos.robax.rax_3 := 0;
		initial_pos.robax.rax_4 := 0;
		initial_pos.robax.rax_5 := 0;
		initial_pos.robax.rax_6 := 0;
		MoveAbsJ initial_pos, v100, fine, tool0;
		TPWrite "Robot1 joints at initial position";

		! Step 2: Move gantry to HOME position (physical origin)
		TPWrite "Step 2: Moving gantry to HOME [0,0,0,0]...";
		home_pos := CJointT();  ! Read current position
		home_pos.extax.eax_a := 0;      ! X1 = Physical origin
		home_pos.extax.eax_b := 0;      ! Y = Physical origin
		home_pos.extax.eax_c := 0;      ! Z = Physical origin
		home_pos.extax.eax_d := 0;      ! R = Physical origin
		! eax_e: keep from CJointT() (not used)
		home_pos.extax.eax_f := 0;      ! X2 = X1 (Master-Follower sync!)
		MoveAbsJ home_pos, v100, fine, tool0;
		TPWrite "Gantry at HOME position [0,0,0,0]";
		TPWrite "Robot1 ready: [-90,0,0,0,0,0], Gantry HOME";
	ENDPROC

	! ========================================
	! Test Robot1 Base Height
	! ========================================
	! Version: v1.7.14
	! Date: 2025-12-28
	! Purpose: Check tool0 TCP height from base at specific joint angles
	! Output: TP display + /HOME/robot1_base_height.txt
	PROC TestRobot1BaseHeight()
		VAR jointtarget test_pos;
		VAR robtarget tcp_wobj0;
		VAR robtarget tcp_floor;
		VAR iodev logfile;

		TPWrite "========================================";
		TPWrite "Robot1 Base Height Test (v1.7.14)";

		! Get current gantry position
		test_pos := CJointT();

		! Set robot joints to [-90, 0, 0, 0, 0, 0]
		test_pos.robax.rax_1 := -90;
		test_pos.robax.rax_2 := 0;
		test_pos.robax.rax_3 := 0;
		test_pos.robax.rax_4 := 0;
		test_pos.robax.rax_5 := 0;
		test_pos.robax.rax_6 := 0;

		! Move to test position
		TPWrite "Moving to test position [-90,0,0,0,0,0]...";
		MoveAbsJ test_pos, v100, fine, tool0;
		WaitTime 0.5;

		! Read TCP position in wobj0
		tcp_wobj0 := CRobT(\Tool:=tool0\WObj:=wobj0);

		! Read TCP position in Floor coordinate
		tcp_floor := CRobT(\Tool:=tool0\WObj:=WobjFloor);

		! Display on TP
		TPWrite "Robot1 wobj0:";
		TPWrite "  X = " + NumToStr(tcp_wobj0.trans.x, 2);
		TPWrite "  Y = " + NumToStr(tcp_wobj0.trans.y, 2);
		TPWrite "  Z = " + NumToStr(tcp_wobj0.trans.z, 2);

		TPWrite "Robot1 Floor:";
		TPWrite "  X = " + NumToStr(tcp_floor.trans.x, 2);
		TPWrite "  Y = " + NumToStr(tcp_floor.trans.y, 2);
		TPWrite "  Z = " + NumToStr(tcp_floor.trans.z, 2);

		TPWrite "========================================";

		! Save to log file
		Open "HOME:/robot1_base_height.txt", logfile \Write;

		Write logfile, "========================================";
		Write logfile, "Robot1 Base Height Test (v1.7.14)";
		Write logfile, "========================================";
		Write logfile, "Date: " + CDate();
		Write logfile, "Time: " + CTime();
		Write logfile, "";
		Write logfile, "Joint Angles: [-90, 0, 0, 0, 0, 0]";
		Write logfile, "";
		Write logfile, "Robot1 wobj0 (tool0):";
		Write logfile, "  X = " + NumToStr(tcp_wobj0.trans.x, 2) + " mm";
		Write logfile, "  Y = " + NumToStr(tcp_wobj0.trans.y, 2) + " mm";
		Write logfile, "  Z = " + NumToStr(tcp_wobj0.trans.z, 2) + " mm";
		Write logfile, "";
		Write logfile, "Robot1 Floor (tool0):";
		Write logfile, "  X = " + NumToStr(tcp_floor.trans.x, 2) + " mm";
		Write logfile, "  Y = " + NumToStr(tcp_floor.trans.y, 2) + " mm";
		Write logfile, "  Z = " + NumToStr(tcp_floor.trans.z, 2) + " mm";
		Write logfile, "========================================\0A";

		Close logfile;
		TPWrite "Saved to: /HOME/robot1_base_height.txt";

	ERROR
		TPWrite "ERROR in TestRobot1BaseHeight: " + NumToStr(ERRNO, 0);
		Close logfile;
		TRYNEXT;
	ENDPROC

	! ========================================
	! Test Gantry Movement Effect on Floor Coordinates
	! ========================================
	! Version: v1.7.33
	! Date: 2025-12-30
	! Purpose: Test if Floor coordinates change when gantry moves
	! Reads gantry movement from config.txt (Floor absolute coordinates)
	! Initial position: Robot1 [-90,0,0,0,0,0], Robot2 [+90,0,0,0,0,0]
	! Gantry HOME Physical: [0, 0, 0, 0], Floor: [9500, 5300, 2100, 0]
	! Coordinate transformation: Physical = Floor - HOME_offset
	!   eax_a = Floor_X - 9500, eax_b = 5300 - Floor_Y
	!   eax_c = 2100 - Floor_Z, eax_d = 0 - Floor_R
	! Note: X1-X2 synchronization added to prevent linked motor error
	! Output: /HOME/gantry_floor_test.txt
	PROC TestGantryFloorCoordinates()
		VAR jointtarget rob1_current;
		VAR jointtarget rob2_current;
		VAR jointtarget home_pos;
		VAR jointtarget moved_pos;
		VAR robtarget rob1_floor_before;
		VAR robtarget rob2_floor_before;
		VAR robtarget rob1_floor_after;
		VAR robtarget rob2_floor_after;
		VAR iodev logfile;
		VAR iodev configfile;
		VAR string line;
		VAR string value_str;
		VAR bool found_value;
		VAR bool found_x;
		VAR bool found_y;
		VAR bool found_z;
		VAR bool found_r;
		VAR num gantry_x_offset;
		VAR num gantry_y_offset;
		VAR num gantry_z_offset;
		VAR num gantry_r_offset;

		TPWrite "========================================";
		TPWrite "Gantry Floor Test (v1.7.30)";

		! Initialize variables
		gantry_x_offset := 0;
		gantry_y_offset := 0;
		gantry_z_offset := 0;
		gantry_r_offset := 0;

		! Check if both robots are at initial position
		TPWrite "Checking robot positions...";
		rob1_current := CJointT();
		rob2_current := CJointT(\TaskName:="T_ROB2");

		IF Abs(rob1_current.robax.rax_1 + 90) > 5 THEN
			TPWrite "WARNING: Robot1 NOT at initial position!";
			TPWrite "Current Robot1 J1: " + NumToStr(rob1_current.robax.rax_1, 1);
			TPWrite "Expected: -90 degrees";
			TPWrite "Please run SetRobot1InitialPosition first";
			STOP;
		ENDIF

		IF Abs(rob2_current.robax.rax_1 - 90) > 5 THEN
			TPWrite "WARNING: Robot2 NOT at initial position!";
			TPWrite "Current Robot2 J1: " + NumToStr(rob2_current.robax.rax_1, 1);
			TPWrite "Expected: +90 degrees";
			TPWrite "Please run TASK2->SetRobot2InitialPosition first";
			STOP;
		ENDIF
		TPWrite "Both robots at initial positions OK";

		! Read gantry offsets from config.txt
		TPWrite "Reading config.txt...";
		Open "HOME:/config.txt", configfile \Read;

		! Read GANTRY_X
		found_x := FALSE;
		WHILE found_x = FALSE DO
			line := ReadStr(configfile \RemoveCR);
			IF StrFind(line, 1, "GANTRY_X=") = 1 THEN
				IF StrLen(line) >= 10 THEN
					value_str := StrPart(line, 10, StrLen(line) - 9);
					found_value := StrToVal(value_str, gantry_x_offset);
					found_x := TRUE;
					TPWrite "GANTRY_X=" + NumToStr(gantry_x_offset, 0);
				ENDIF
			ENDIF
		ENDWHILE

		! Read GANTRY_Y
		found_y := FALSE;
		WHILE found_y = FALSE DO
			line := ReadStr(configfile \RemoveCR);
			IF StrFind(line, 1, "GANTRY_Y=") = 1 THEN
				IF StrLen(line) >= 10 THEN
					value_str := StrPart(line, 10, StrLen(line) - 9);
					found_value := StrToVal(value_str, gantry_y_offset);
					found_y := TRUE;
					TPWrite "GANTRY_Y=" + NumToStr(gantry_y_offset, 0);
				ENDIF
			ENDIF
		ENDWHILE

		! Read GANTRY_Z
		found_z := FALSE;
		WHILE found_z = FALSE DO
			line := ReadStr(configfile \RemoveCR);
			IF StrFind(line, 1, "GANTRY_Z=") = 1 THEN
				IF StrLen(line) >= 10 THEN
					value_str := StrPart(line, 10, StrLen(line) - 9);
					found_value := StrToVal(value_str, gantry_z_offset);
					found_z := TRUE;
					TPWrite "GANTRY_Z=" + NumToStr(gantry_z_offset, 0);
				ENDIF
			ENDIF
		ENDWHILE

		! Read GANTRY_R
		found_r := FALSE;
		WHILE found_r = FALSE DO
			line := ReadStr(configfile \RemoveCR);
			IF StrFind(line, 1, "GANTRY_R=") = 1 THEN
				IF StrLen(line) >= 10 THEN
					value_str := StrPart(line, 10, StrLen(line) - 9);
					found_value := StrToVal(value_str, gantry_r_offset);
					found_r := TRUE;
					TPWrite "GANTRY_R=" + NumToStr(gantry_r_offset, 1);
				ENDIF
			ENDIF
		ENDWHILE

		Close configfile;
		TPWrite "Config reading complete!";

		! Move to HOME position [0, 0, 0, 0]
		TPWrite "Moving gantry to HOME [0,0,0,0]...";
		home_pos := CJointT();
		! Synchronize X2 with X1 first (prevent linked motor error)
		home_pos.extax.eax_f := home_pos.extax.eax_a;
		home_pos.extax.eax_a := 0;      ! X1 = Physical origin
		home_pos.extax.eax_b := 0;      ! Y = Physical origin
		home_pos.extax.eax_c := 0;      ! Z = Physical origin
		home_pos.extax.eax_d := 0;      ! R = Physical origin
		home_pos.extax.eax_f := 0;      ! X2 = X1 (Master-Follower sync!)
		MoveAbsJ home_pos, v100, fine, tool0;
		WaitTime 1.0;

		! Measure BEFORE gantry movement
		TPWrite "Measuring BEFORE gantry move...";
		UpdateRobot1FloorPosition;
		! Note: robot2_floor_pos is updated by TASK2's UpdateRobot2FloorPosition
		rob1_floor_before := robot1_floor_pos;
		rob2_floor_before := robot2_floor_pos;

		! Move gantry with Floor->Physical coordinate transformation
		TPWrite "Moving gantry with offsets...";
		moved_pos := home_pos;
		moved_pos.extax.eax_a := gantry_x_offset - 9500;   ! Physical X = Floor_X - 9500
		moved_pos.extax.eax_b := 5300 - gantry_y_offset;   ! Physical Y = 5300 - Floor_Y
		moved_pos.extax.eax_c := 2100 - gantry_z_offset;   ! Physical Z = 2100 - Floor_Z
		moved_pos.extax.eax_d := 0 - gantry_r_offset;      ! Physical R = 0 - Floor_R
		moved_pos.extax.eax_f := gantry_x_offset - 9500;   ! X2 = X1 (synchronized!)
		MoveAbsJ moved_pos, v100, fine, tool0;
		WaitTime 1.0;

		! Measure AFTER gantry movement
		TPWrite "Measuring AFTER gantry move...";
		UpdateRobot1FloorPosition;
		! Note: robot2_floor_pos is updated by TASK2's UpdateRobot2FloorPosition
		rob1_floor_after := robot1_floor_pos;
		rob2_floor_after := robot2_floor_pos;

		! Return to HOME position
		TPWrite "Returning to HOME...";
		MoveAbsJ home_pos, v100, fine, tool0;

		! Save results
		TPWrite "Saving results...";
		Open "HOME:/gantry_floor_test.txt", logfile \Write;

		Write logfile, "========================================";
		Write logfile, "Gantry Floor Coordinate Test (v1.7.33)";
		Write logfile, "========================================";
		Write logfile, "Date: " + CDate();
		Write logfile, "Time: " + CTime();
		Write logfile, "";
		Write logfile, "Gantry HOME:";
		Write logfile, "  Physical (wobj0): [0, 0, 0, 0]";
		Write logfile, "  Floor: [9500, 5300, 2100, 0]";
		Write logfile, "";
		Write logfile, "Coordinate Transformation (Floor -> Physical):";
		Write logfile, "  Physical X = Floor_X - 9500";
		Write logfile, "  Physical Y = 5300 - Floor_Y";
		Write logfile, "  Physical Z = 2100 - Floor_Z";
		Write logfile, "  Physical R = 0 - Floor_R";
		Write logfile, "";
		Write logfile, "Initial Position:";
		Write logfile, "  Robot1: [-90,0,0,0,0,0]";
		Write logfile, "  Robot2: [+90,0,0,0,0,0]";
		Write logfile, "  Gantry Physical: [0,0,0,0]";
		Write logfile, "  Gantry Floor: [9500,5300,2100,0]";
		Write logfile, "";
		Write logfile, "Gantry Movement (Floor coordinates):";
		Write logfile, "  X = " + NumToStr(gantry_x_offset, 2) + " mm";
		Write logfile, "  Y = " + NumToStr(gantry_y_offset, 2) + " mm";
		Write logfile, "  Z = " + NumToStr(gantry_z_offset, 2) + " mm";
		Write logfile, "  R = " + NumToStr(gantry_r_offset, 2) + " deg";
		Write logfile, "";
		Write logfile, "BEFORE Gantry Movement:";
		Write logfile, "------------------------";
		Write logfile, "Robot1 Floor (tool0):";
		Write logfile, "  X = " + NumToStr(rob1_floor_before.trans.x, 2) + " mm";
		Write logfile, "  Y = " + NumToStr(rob1_floor_before.trans.y, 2) + " mm";
		Write logfile, "  Z = " + NumToStr(rob1_floor_before.trans.z, 2) + " mm";
		Write logfile, "";
		Write logfile, "Robot2 Floor (tool0):";
		Write logfile, "  X = " + NumToStr(rob2_floor_before.trans.x, 2) + " mm";
		Write logfile, "  Y = " + NumToStr(rob2_floor_before.trans.y, 2) + " mm";
		Write logfile, "  Z = " + NumToStr(rob2_floor_before.trans.z, 2) + " mm";
		Write logfile, "";
		Write logfile, "AFTER Gantry Movement:";
		Write logfile, "----------------------";
		Write logfile, "Robot1 Floor (tool0):";
		Write logfile, "  X = " + NumToStr(rob1_floor_after.trans.x, 2) + " mm";
		Write logfile, "  Y = " + NumToStr(rob1_floor_after.trans.y, 2) + " mm";
		Write logfile, "  Z = " + NumToStr(rob1_floor_after.trans.z, 2) + " mm";
		Write logfile, "";
		Write logfile, "Robot2 Floor (tool0):";
		Write logfile, "  X = " + NumToStr(rob2_floor_after.trans.x, 2) + " mm";
		Write logfile, "  Y = " + NumToStr(rob2_floor_after.trans.y, 2) + " mm";
		Write logfile, "  Z = " + NumToStr(rob2_floor_after.trans.z, 2) + " mm";
		Write logfile, "";
		Write logfile, "DIFFERENCE:";
		Write logfile, "-----------";
		Write logfile, "Robot1 Floor Delta:";
		Write logfile, "  dX = " + NumToStr(rob1_floor_after.trans.x - rob1_floor_before.trans.x, 2) + " mm";
		Write logfile, "  dY = " + NumToStr(rob1_floor_after.trans.y - rob1_floor_before.trans.y, 2) + " mm";
		Write logfile, "  dZ = " + NumToStr(rob1_floor_after.trans.z - rob1_floor_before.trans.z, 2) + " mm";
		Write logfile, "";
		Write logfile, "Robot2 Floor Delta:";
		Write logfile, "  dX = " + NumToStr(rob2_floor_after.trans.x - rob2_floor_before.trans.x, 2) + " mm";
		Write logfile, "  dY = " + NumToStr(rob2_floor_after.trans.y - rob2_floor_before.trans.y, 2) + " mm";
		Write logfile, "  dZ = " + NumToStr(rob2_floor_after.trans.z - rob2_floor_before.trans.z, 2) + " mm";
		Write logfile, "========================================\0A";

		Close logfile;
		TPWrite "Saved to: /HOME/gantry_floor_test.txt";
		TPWrite "Test complete!";
		TPWrite "========================================";

	ERROR
		IF ERRNO = ERR_FILEOPEN THEN
			TPWrite "ERROR: Cannot open config.txt or log file";
		ELSE
			TPWrite "ERROR in TestGantryFloorCoordinates: " + NumToStr(ERRNO, 0);
		ENDIF
		Close configfile;
		Close logfile;
		STOP;
	ENDPROC

ENDMODULE
