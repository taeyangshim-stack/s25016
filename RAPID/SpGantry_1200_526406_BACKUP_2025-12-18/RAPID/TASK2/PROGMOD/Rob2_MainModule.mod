MODULE Rob2_MainModule
	!========================================
	! TASK2 (Robot2) - Rob2_MainModule
	! Version History
	!========================================
	! v1.0.0 (2025-12-17)
	!   - Initial gantry position sharing system
	!   - Added shared_gantry_pos and related variables
	!   - Created UpdateSharedGantryPosition procedure
	!
	! v1.1.0 (2025-12-18)
	!   - Added wobj0 definition verification
	!   - Verified Robot2's wobj0 is READ-ONLY (equals World)
	!   - Documented wobj0 vs WobjFloor relationship
	!
	! v1.2.0 (2025-12-18)
	!   - Added WobjFloor coordinate system
	!   - Frame: [-9500, 5300, 2100] with quaternion [0, 1, 0, 0]
	!   - Quaternion [0,1,0,0] = 180° rotation around X-axis (Y,Z inverted)
	!   - Added comprehensive coordinate system documentation
	!
	! v1.3.0 (2025-12-18)
	!   - Added coordinate verification procedures
	!   - TestRobot2_TCP: TCP position verification in wobj0 and WobjFloor
	!   - TestRobot2_XYZ: X/Y/Z axis movement tests
	!   - TestCoordinateMovement: Core movement and logging procedure
	!   - WritePosToFile: File logging with overwrite mode
	!
	! v1.4.0 (2025-12-18)
	!   - Added World coordinate comparison
	!   - CompareRobot2Coordinates: Compare wobj0, WobjFloor, World
	!   - Verified relationship: wobj0 = World (for Robot2)
	!   - Verified WobjFloor transforms coordinates correctly
	!
	! v1.4.1 (2025-12-23)
	!   - Removed MoveToMiddlePosition calls to prevent Reference Error
	!   - Simplified procedure calls in TestRobot2_TCP
	!
	! v1.4.2 (2025-12-24)
	!   - Added Robot2 TCP coordinate movement tests
	!   - TestCoordinateMovement: Move and log TCP positions
	!
	! v1.4.3 (2025-12-24)
	!   - Combined X/Y/Z tests into single TestRobot2_XYZ procedure
	!   - Streamlined coordinate testing workflow
	!
	! v1.4.4 (2025-12-24)
	!   - Reduced movement distance to avoid joint limits
	!   - Changed test distances: 50mm X, 30mm Y, 20mm Z
	!
	! v1.4.5 (2025-12-24)
	!   - Increased movement back to 50/30/20 mm
	!   - Added return to start position after test
	!
	! v1.4.6 (2025-12-24)
	!   - Added home position test capability
	!   - Save original joint position with CJointT()
	!   - Move to home position [0,0,0,0,0,0] before test
	!   - Return to original position after test
	!
	! v1.4.7 (2025-12-24)
	!   - Fixed singularity error in home position
	!   - Changed Robot2 home position to [+90,0,0,0,30,0]
	!   - J1=+90° for Robot2 mounting orientation
	!   - J5=30° to avoid wrist singularity (not 0°)
	!
	! v1.5.0 (2025-12-24) - DUAL COORDINATE SYSTEM
	!   - Added config.txt MODE support for dual coordinate systems
	!   - ReadConfigMode() function reads /HOME/config.txt
	!   - MODE=0 (Default - User's system):
	!     * Robot2 uses WobjFloor as base coordinate
	!     * wobj0 [+50,+30,+20] -> Floor [+50,+30,+20] (NO Y,Z inversion)
	!   - MODE=1 (Claude's system):
	!     * Robot2 uses wobj0 as base coordinate
	!     * wobj0 [+50,+30,+20] -> Floor [+50,-30,-20] (Y,Z inverted)
	!   - Modified TestCoordinateMovement to accept wobjdata parameter
	!   - TestRobot2_XYZ now switches coordinate system based on MODE
	!========================================
    RECORD targetdata
        robtarget position;
        num cpm;
        num schedule;
        num voltage;
        num wfs;
        num Current;
        num WeaveShape;
        num WeaveType;
        num WeaveLength;
        num WeaveWidth;
        num WeaveDwellLeft;
        num WeaveDwellRight;
        num TrackType;
        num TrackGainY;
        num TrackGainZ;
    ENDRECORD

    RECORD monRobs
        extjoint monExt;
        robjoint monJoint1;
        robjoint monJoint2;
        pose monPose1;
        pose monPose2;
    ENDRECORD

    RECORD torchmotion
        num No;
        num LengthOffset;
        num BreadthOffset;
        num HeightOffset;
        num WorkingAngle;
        num TravelAngle;
        num WeldingSpeed;
        num Schedule;
        num Voltage;
        num FeedingSpeed;
        num Current;
        num WeaveShape;
        num WeaveType;
        num WeaveLength;
        num WeaveWidth;
        num WeaveDwellLeft;
        num WeaveDwellRight;
        num TrackType;
        num TrackGainY;
        num TrackGainZ;
    ENDRECORD

    RECORD corrorder
        num X_StartOffset;
        num X_Depth;
        num X_ReturnLength;
        num Y_StartOffset;
        num Y_Depth;
        num Y_ReturnLength;
        num Z_StartOffset;
        num Z_Depth;
        num Z_ReturnLength;
        num RY_Torch;
    ENDRECORD

    RECORD edgedata
        pos EdgePos;
        num Height;
        num Breadth;
        num HoleSize;
        num Thickness;
        num AngleHeight;
        num AngleWidth;
    ENDRECORD

    PERS tasks taskGroup12{2};
    PERS tasks taskGroup13{2};
    PERS tasks taskGroup23{2};
    PERS tasks taskGroup123{3};
    PERS pos nCaledR2Pos;
    TASK PERS jointtarget jTemp:=[[0,-2.51761,-12.1411,0,15.6587,0],[-500,500,300,15,0,-28.6479]];
    PERS wobjdata wobjtest:=[FALSE,TRUE,"GantryRob",[[-971.372,373.696,300],[1,0,0,0]],[[0,0,0],[1,0,0,0]]];

    ! Sync Data
    TASK VAR syncident SynchronizeJGJon{9999};
    TASK VAR syncident SynchronizePGJon{9999};
    TASK VAR syncident SynchronizePGLon{9999};
    TASK VAR syncident SynchronizeJGJoff{9999};
    TASK VAR syncident SynchronizePGJoff{9999};
    TASK VAR syncident SynchronizePGLoff{9999};
    TASK VAR syncident Wait{100};

    PERS string stCommand;
    PERS string stReact{3};
    PERS num idSync;
    PERS speeddata vSync;
    PERS zonedata zSync;

    PERS wobjdata wobjWeldLine2;
    PERS wobjdata wobjRotCtr2;

    ! Work Object Definitions (v1.7.3 2025-12-28)
    ! WobjFloor: Floor coordinate system from TASK1 (external reference)
    PERS wobjdata WobjFloor;

    ! WobjFloor_Rob2: Floor coordinate system for Robot2 (v1.7.4)
    ! Robot2 is also upside-down mounted, 488mm offset from Robot1 in +Y direction
    ! Robot2 needs SAME 180deg rotation as Robot1 to align wobj0 -> Floor
    ! Y offset: 5300 - 488 = 4812 (to align with same physical Floor coordinate)
    ! Z offset: Same as Robot1 (2100) because both robots at same height on R-axis
    PERS wobjdata WobjFloor_Rob2 := [FALSE, TRUE, "", [[-9500, 4812, 2100], [0, 1, 0, 0]], [[0, 0, 0], [1, 0, 0, 0]]];

    ! wobjRob2Base: Robot2 Base Frame orientation from MOC.cfg
    ! Quaternion [-4.32964E-17, 0.707107, 0.707107, 4.32964E-17] = 45° rotation
    PERS wobjdata wobjRob2Base := [FALSE, TRUE, "", [[0, 0, 0], [-0.0000000000000000432964, 0.707107, 0.707107, 0.0000000000000000432964]], [[0, 0, 0], [1, 0, 0, 0]]];

    ! Robot Position Monitoring (v1.5.1 2025-12-25)
    ! Robot1 TCP position from TASK1 (external reference)
    PERS robtarget robot1_floor_pos;
    ! Robot1 wobj0 snapshot from TASK1 (external reference)
    PERS wobjdata robot1_wobj0_snapshot := [FALSE, TRUE, "", [[0,0,0],[1,0,0,0]], [[0,0,0],[1,0,0,0]]];

    ! Robot2 TCP position in Floor coordinate system (for distance measurement)
    ! Shared across tasks - use PERS (not TASK PERS) for cross-task access
    PERS robtarget robot2_floor_pos := [[0,0,0],[1,0,0,0],[0,0,0,0],[0,0,0,0,0,0]];

    PERS num nMotionTotalStep{2};
    PERS num nMotionStepCount{2};
    PERS num nMotionStartStepLast{2};
    PERS num nMotionEndStepLast{2};
    PERS num nRunningStep{2};
    PERS num nWeldSequence;

    PERS jointtarget jRob2;
    PERS robtarget pRob2;
    PERS bool bRqMoveG_PosHold;

    PERS robtarget pctWeldPosR1;
    PERS robtarget pctWeldPosR2;

    PERS targetdata Welds2{40};
    TASK PERS speeddata vWeld{40}:=[[10,200,200,200],[10,200,200,200],[10,200,200,200],[10,200,200,200],[9.16667,200,200,200],[9.16667,200,200,200],[8.33333,200,200,200],[7.5,200,200,200],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[10,200,200,200]];
    PERS seamdata smDefault_2;


    PERS speeddata vTargetSpeed;
    PERS zonedata zTargetZone;

    TASK PERS welddata wdTrap:=[10,0,[5,0,38,240,0,400,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd1:=[10,0,[5,0,39.5,260,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd2:=[10,0,[5,0,39.5,260,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd3:=[10,0,[5,0,39.5,260,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd4:=[10,0,[5,0,39.5,260,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd5:=[9.16667,0,[5,0,39.5,255,0,420,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd6:=[9.16667,0,[5,0,39.5,255,0,420,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd7:=[8.33333,0,[5,0,39.5,255,0,420,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd8:=[7.5,0,[5,0,36,225,0,375,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd9:=[7.5,0,[5,0,36,225,0,375,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd10:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd11:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd12:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd13:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd14:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd15:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd16:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd17:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd18:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd19:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd20:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd21:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd22:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd23:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd24:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd25:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd26:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd27:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd28:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd29:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd30:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd31:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd32:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd33:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd34:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd35:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd36:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd37:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd38:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd39:=[0,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata wd40:=[10,0,[5,0,39.5,260,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];

    TASK PERS welddata Holdwd1:=[0.01,0,[5,0,39.5,260,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata Holdwd2:=[0.01,0,[5,0,39.5,260,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata Holdwd3:=[0.01,0,[5,0,39.5,260,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata Holdwd4:=[0.01,0,[5,0,39.5,260,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata Holdwd5:=[0.01,0,[5,0,39.5,255,0,420,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata Holdwd6:=[0.01,0,[5,0,39.5,255,0,420,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata Holdwd7:=[0.01,0,[5,0,39.5,255,0,420,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata Holdwd8:=[0.01,0,[5,0,36,225,0,375,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata Holdwd9:=[0.01,0,[5,0,36,225,0,375,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS welddata Holdwd10:=[0.01,0,[5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0]];

    !!! weave data !!!
    TASK PERS weavedata weaveTrap:=[1,2,3,3,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave1:=[1,2,2,3,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave2:=[1,2,2,3,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave3:=[1,2,2,3,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave4:=[1,2,2,3,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave5:=[1,2,2,3.5,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave6:=[1,2,2,3.5,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave7:=[1,2,2,3.5,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave8:=[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave9:=[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave10:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave11:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave12:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave13:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave14:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave15:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave16:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave17:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave18:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave19:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave20:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave21:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave22:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave23:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave24:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave25:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave26:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave27:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave28:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave29:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave30:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave31:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave32:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave33:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave34:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave35:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave36:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave37:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave38:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave39:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS weavedata weave40:=[1,2,2,3,0,0,0,0,0,0,0,0,0,0,0];

    !!! Track Data !!!
    TASK PERS trackdata trackTrap:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track0:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track1:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track2:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track3:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track4:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track5:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track6:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track7:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track8:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track9:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track10:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track11:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track12:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track13:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track14:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track15:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track16:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track17:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track18:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track19:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track20:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track21:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track22:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track23:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track24:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track25:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track26:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track27:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track28:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track29:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track30:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track31:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track32:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track33:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track34:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track35:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track36:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track37:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track38:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track39:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
    TASK PERS trackdata track40:=[0,FALSE,50,[0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];

    TASK VAR intnum inumMoveG_PosHold;

    PERS bool bGanTry_Last_pos;
    PERS bool bTouch_last_R1_Comp;
    PERS bool bTouch_last_R2_Comp;
    PERS bool bGanTry_First_pos;
    PERS bool bTouch_First_R1_Comp;
    PERS bool bTouch_First_R2_Comp;
    PERS num nMacro010{2}:=[4,4];
    PERS num nMacro001{2}:=[4,4];
    PERS bool bEndSearchComplete;
    PERS edgedata edgeStart{2}:=[[[18363.5,4423.9,4.92933],50,50,0,12,0,0],[[18363.9,4411.91,4.65171],50,50,0,12,0,0]];
    PERS edgedata edgeEnd{2}:=[[[19008.1,4446.95,5.66316],50,50,0,12,0,0],[[19008.5,4434.96,5.38554],50,50,0,12,0,0]];
    PERS corrorder corrStart{10}:=[[20,30,10,25,40,10,15,30,10,2],[20,30,10,25,40,10,15,30,10,0],[-15,-30,-10,25,40,10,15,30,10,2],[0,0,0,25,40,10,15,30,10,0],[0,0,0,25,40,20,15,30,20,0],[-15,-30,-10,25,40,10,15,30,10,0],[999,0,0,0,0,0,0,0,0,0],[999,0,0,0,0,0,0,0,0,0],[999,0,0,25,40,10,15,30,30,10],[999,0,0,0,0,0,0,0,0,0]];
    PERS corrorder corrEnd{10}:=[[20,30,10,25,40,10,15,30,10,2],[20,30,10,25,40,10,15,30,10,0],[-15,-30,-10,25,40,10,15,30,10,2],[0,0,0,25,40,10,15,30,10,0],[0,0,0,25,40,20,15,40,20,0],[-15,-30,-10,25,40,10,15,30,10,0],[999,0,0,25,40,10,15,30,10,0],[999,0,0,0,0,0,0,0,0,0],[0,0,0,25,40,10,15,30,10,0],[0,0,0,0,0,0,0,0,0,0]];
    PERS pos pCorredStartPos{2};
    PERS pos pCorredEndPos{2};

    PERS num nCorrX_Store_Start{2};
    PERS num nCorrY_Store_Start{2};
    PERS num nCorrZ_Store_Start{2};
    PERS num nCorrX_Store_End{2};
    PERS num nCorrY_Store_End{2};
    PERS num nCorrZ_Store_End{2};

    TASK PERS num nCorrFailOffs_Y:=0;
    TASK PERS num nCorrFailOffs_Z:=0;
    CONST bool bEnd:=FALSE;
    CONST bool bStart:=TRUE;


    PERS torchmotion macroStartBuffer2{10};
    PERS torchmotion macroEndBuffer2{10};
    PERS num nWeldLineLength:=400;
    ! 264.966;
    PERS num nWeldLineLength_R2;
    ! 264.966;
    PERS robtarget pSearchStart:=[[0,-37.0002,4.16317],[0.270598,-0.653282,-0.653282,-0.270598],[0,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    PERS robtarget pSearchEnd:=[[0,15,4.16317],[0.270598,-0.653282,-0.653282,-0.270598],[0,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    TASK PERS string TouchErrorDirSub:="Start_Y";
    TASK PERS string TouchErrorDirMain:="Ready";
    PERS num nTouchRetryCount{2};
    PERS num n_Angle;
    TASK PERS num RetryDepthData{3}:=[10,10,10];
    PERS robtarget pWeldPosR2{40}:=[[[-3,7,1],[0.307623,-0.549545,-0.742667,-0.227629],[-1,0,0,1],[-8704.03,-8704.03,294.161,1030.31,9E+09,9E+09]],[[-3,7,1],[0.307623,-0.549545,-0.742667,-0.227629],[-1,0,0,1],[-8704.03,-8704.03,294.161,1030.31,9E+09,9E+09]],[[-3,-4.5,1],[0.307623,-0.549545,-0.742667,-0.227629],[-1,0,0,1],[-8704.03,-8704.03,294.161,1030.31,9E+09,9E+09]],[[15,-1,1],[0.307623,-0.549545,-0.742667,-0.227629],[-1,0,0,1],[-8704.03,-8704.03,294.161,1030.34,9E+09,9E+09]],[[200,-1,1],[0.270598,-0.653282,-0.653282,-0.270598],[-1,0,0,1],[-8704.03,-8704.03,294.161,1030.72,9E+09,9E+09]],[[1390,-1.00592,0.996463],[0.270597,-0.653283,-0.653281,-0.270597],[0,0,-1,1],[-8707.81,-8707.8,1477.15,1033.13,9E+09,9E+09]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0,0,0]],[[1390,-1,1],[0.270598,-0.653282,-0.653282,-0.270598],[-1,0,0,1],[-8707.8,-8707.8,1477.15,1033.12,9E+09,9E+09]]];
    PERS num nRobCorrSpaceHeight;
    PERS pos pCorredPosBuffer:=[-0.000742761,3.88479,5.49397];
    PERS bool bWireTouch2;
    CONST robtarget pNull:=[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

    PERS bool bRobSwap;
    PERS jointtarget jCorrT_ROB2_Start;
    PERS jointtarget jCorrT_ROB2_End;
    PERS robtarget pCorrT_ROB2_Start;
    PERS robtarget pCorrT_ROB2_End;

    !!!!jWireCut
    TASK PERS num nWireCutSpeed:=600;
    PERS tooldata tWeld2:=[TRUE,[[319.938,-6.311,330],[0.92587,0.003729,0.377818,-0.009128]],[3.1,[-71.4,3.8,173.2],[1,0,0,0],0.055,0.049,0.005]];
    PERS tooldata tWeld2copy:=[TRUE,[[320.377,0,330.247],[0.92587,0,0.37784,0]],[3.1,[-71.4,3.8,173.2],[1,0,0,0],0.055,0.049,0.005]];
    PERS bool bEnableWeldSkip;
    PERS num nTrapCheck_2:=0;
    PERS seamdata smDefault_2Trap;
    VAR num tool_rx_end{3};
    VAR num tool_rx_start{3};
    VAR num tool_rx_delta{3};
    VAR robtarget pcalcWeldpos;
    VAR robtarget pMoveWeldpos;
    VAR robtarget pSaveWeldpos;
    !Error
    TASK VAR intnum iErrorDuringEntry;
    PERS num nEntryRetryCount{2};
    TASK VAR intnum iMoveHome_RBT2;
    TASK PERS bool bTouchWorkCount{6}:=[FALSE,FALSE,FALSE,FALSE,FALSE,FALSE];
    PERS monRobs MonitorweldErrorpostion;
    PERS monRobs MonitorPosition;
    PERS pos posStart;
    PERS pos posEnd;
    PERS bool bGantryInTrap{2};
    TASK VAR intnum intOutGantryHold;
    PERS edgedata edgestartBuffer2;
    PERS edgedata edgeEndBuffer2;
    PERS num nStartThick;
    PERS num nEndThick;
    PERS bool bBreakPoint{2};
    PERS num nBreakPoint{2};
    PERS bool btouchTimeOut{2};
    PERS bool bWeldOutputDisable;
    TASK PERS seamdata tsm2:=[0.5,0.5,[0,0,32,0,0,380,0,0,0],0,0,0,0,0,[0,0,0,0,0,0,0,0,0],0,1,[0,0,32,0,0,380,0,0,0],0,0,[0,0,0,0,0,0,0,0,0],0];
    TASK PERS welddata twel2:=[0.01,0,[0,0,32,0,0,380,0,0,0],[0,0,0,0,0,0,0,0,0]];
    TASK PERS weavedata tweav2:=[1,2,2,2,0,0,0,0,0,0,0,0,0,0,0];
    TASK PERS bool bInstalldir:=FALSE;
    PERS num nMoveid;
    PERS bool bExitCycle:=FALSE;

    TRAP trapOutGantryHold
        IDelete intOutGantryHold;
        bGantryInTrap{2}:=FALSE;
        Reset intReHoldGantry_2;
        Holdwd1:=[Welds2{1}.cpm/6,0,[5,0,Welds2{1}.voltage,Welds2{1}.wfs,0,Welds2{1}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd2:=[Welds2{2}.cpm/6,0,[5,0,Welds2{2}.voltage,Welds2{2}.wfs,0,Welds2{2}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd3:=[Welds2{3}.cpm/6,0,[5,0,Welds2{3}.voltage,Welds2{3}.wfs,0,Welds2{3}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd4:=[Welds2{4}.cpm/6,0,[5,0,Welds2{4}.voltage,Welds2{4}.wfs,0,Welds2{4}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd5:=[Welds2{5}.cpm/6,0,[5,0,Welds2{5}.voltage,Welds2{5}.wfs,0,Welds2{5}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd6:=[Welds2{6}.cpm/6,0,[5,0,Welds2{6}.voltage,Welds2{6}.wfs,0,Welds2{6}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd7:=[Welds2{7}.cpm/6,0,[5,0,Welds2{7}.voltage,Welds2{7}.wfs,0,Welds2{7}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd8:=[Welds2{8}.cpm/6,0,[5,0,Welds2{8}.voltage,Welds2{8}.wfs,0,Welds2{8}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd9:=[Welds2{9}.cpm/6,0,[5,0,Welds2{9}.voltage,Welds2{9}.wfs,0,Welds2{9}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        Holdwd10:=[Welds2{10}.cpm/6,0,[5,0,Welds2{10}.voltage,Welds2{10}.wfs,0,Welds2{10}.Current,0,0,0],[0,0,0,0,0,0,0,0,0]];
        ArcRefresh;
    ENDTRAP

    TRAP trapMoveG_PosHold
        rTrapWeldMove;
    ENDTRAP

    TRAP trapErrorDuringEntry
        Set po34_EntryR2Error;
        IDelete iMoveHome_RBT2;
        rErrorDuringEntry;
    ENDTRAP

    TRAP trapMoveHome_RBT2
        VAR robtarget pTemp;
        IDelete iMoveHome_RBT2;
        StopMove;
        ClearPath;
        StartMove;
        pTemp:=CRobT(\TaskName:="T_ROB2"\Tool:=tWeld2\WObj:=wobjWeldLine2);
        MoveL RelTool(pTemp,0,0,-10),vTargetSpeed,z0,tWeld2\WObj:=wobjWeldLine2;
        bWeldOutputDisable:=TRUE;
        stReact{2}:="Error_Arc_Touch";
        WaitSyncTask Wait{80},taskGroup123;
        WaitUntil stReact=["Error_Arc_Touch","Error_Arc_Touch","Error_Arc_Touch"];
        WaitSyncTask Wait{81},taskGroup123;
        WaitUntil stCommand="Error_Arc_Touch";
        stReact{2}:="";
        WaitUntil stCommand="";
        WaitSyncTask Wait{82},taskGroup123;
        ExitCycle;

    ENDTRAP

    PROC main()
        rUpdateR2Position;
    ENDPROC

    PROC rInit()
        AccSet 30,30;

        stReact{2}:="";
        WaitUntil stCommand="";
        stReact{2}:="Ready";
        IDelete inumMoveG_PosHold;
        IDelete iMoveHome_RBT2;
        IDelete intOutGantryHold;
        Reset intReHoldGantry_2;
        Reset soLn2Touch;
        bGantryInTrap{2}:=FALSE;
        RETURN ;
        MoveAbsJ [[0.0204923,-24.7246,-8.05237,0.0496605,-57.6256,1.6],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]]\NoEOffs,v1000,z50,tool0;
        MoveJ [[168.50,0.00,1167.50],[0.999973,0.000344359,-0.00351527,0.00652012],[0,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],v1000,z50,tool0;
        RETURN ;
        ArcLStart [[-2.89,-0.02,1.95],[0.307559,-0.549626,-0.742627,-0.227649],[-1,-1,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],v10,smDefault_2,wd2,fine,tWeld2\WObj:=wobjWeldLine2;
        ArcLEnd [[31.01,-0.07,1.91],[0.307527,-0.549634,-0.742645,-0.227613],[-1,-1,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],v10,smDefault_2,wd2,fine,tWeld2\WObj:=wobjWeldLine2;
        RETURN ;
        MoveL [[0,0,0],[0.264906,0.659459,-0.649912,0.269356],[0,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]],v10,z50,tWeld2\WObj:=wobjWeldLine2;
    ENDPROC

    !    PROC rTrapNoWeldMove()
    !        VAR num i;
    !        VAR targetdata WeldsTemp;
    !        VAR robtarget pWeldTemp;

    !        StopMove;
    !        StorePath;

    !        i:=nRunningStep{2};
    !        WeldsTemp:=Welds2{i};
    !        pWeldTemp:=CRobT(\taskname:="T_ROB2"\Tool:=tWeld2\WObj:=wobjWeldLine2);
    !        WeldsTemp.position:=pWeldTemp;
    !        ConfL\Off;
    !        While (so_MoveG_PosHold=1) DO
    !            nTrapCheck_2:=1;
    !            MoveL RelTool(WeldsTemp.position,0,-0.1,0),vWeld{i},fine,tWeld2\WObj:=wobjWeldLine2;
    !            MoveL RelTool(WeldsTemp.position,0,0.1,0),vWeld{i},fine,tWeld2\WObj:=wobjWeldLine2;
    !        ENDWHILE
    !        ConfL\On;
    !        RestoPath;
    !        StartMove;
    !    ENDPROC

    PROC rTrapWeldMove()
        VAR num i;
        VAR robtarget pWeldTemp;
        VAR robtarget pTemp_pos;
        VAR num nTempMmps;
        VAR speeddata vWeldTemp;
        IDelete inumMoveG_PosHold;
        StopMove;
        !        ClearPath;
        !        StorePath;
        i:=nRunningStep{2};
        nTempMmps:=Welds2{i}.cpm/6;
        vWeldTemp:=[nTempMmps,200,200,200];
        pWeldTemp:=CRobT(\taskname:="T_ROB2"\Tool:=tWeld2\WObj:=wobjWeldLine2);
        StartMove;
        ConfL\Off;
        WHILE (so_MoveG_PosHold=1) DO
            nTrapCheck_2:=2;
            MoveL Offs(pWeldTemp,0,0,0),vWeldTemp,fine,tWeld2\WObj:=wobjWeldLine2;
            MoveL Offs(pWeldTemp,0,0,0),vWeldTemp,fine,tWeld2\WObj:=wobjWeldLine2;
        ENDWHILE
        ConfL\On;
        !        RestoPath;

    ENDPROC

    PROC rMoveCorrConnect(num X,num Y,num Z,num Rx,num Ry,num Rz,num EAX_D,bool isStartPos,bool CCW,\switch LIN)
        VAR robtarget pTempConnect;
        VAR num nCorrX_Store;
        VAR num nCorrY_Store;
        VAR num nCorrZ_Store;

        IF (isStartPos=bStart) THEN
            nCorrX_Store:=nCorrX_Store_Start{2};
            nCorrY_Store:=nCorrY_Store_Start{2};
            nCorrZ_Store:=nCorrZ_Store_Start{2};
        ELSE
            nCorrX_Store:=nCorrX_Store_End{2};
            nCorrY_Store:=nCorrY_Store_End{2};
            nCorrZ_Store:=nCorrZ_Store_End{2};
        ENDIF


        pTempConnect:=pNull;
        pTempConnect.robconf:=[0,0,0,1];

        IF isStartPos=bStart THEN
            !        pTempConnect:=ConvertTcpToGantryCoord(pWeldPosR2{2}.position);
            IF CCW=FALSE THEN
                pTempConnect.trans:=[nCorrX_Store+(-1*X),nCorrY_Store+(Y),nCorrZ_Store+(Z)];
                pTempConnect.rot:=[0.5,-0.5,-0.5,-0.5];
                pTempConnect:=RelTool(pTempConnect,0,0,0\Rx:=macroStartBuffer2{1}.TravelAngle\Ry:=-1*macroStartBuffer2{1}.WorkingAngle+nBreakPoint{2});
            ELSE
                pTempConnect.trans:=[nCorrX_Store+(-1*X),nCorrY_Store+(Y*(-1)),nCorrZ_Store+(Z)];
                pTempConnect.rot:=[0.5,0.5,-0.5,0.5];
                pTempConnect:=RelTool(pTempConnect,0,0,0\Rx:=-1*macroStartBuffer2{1}.TravelAngle\Ry:=-1*macroStartBuffer2{1}.WorkingAngle+nBreakPoint{2});
            ENDIF
        ELSEIF isStartPos=bEnd THEN
            !        pTempConnect:=ConvertTcpToGantryCoord(pWeldPosR2{nMotionStepCount}.position);
            IF CCW=FALSE THEN
                pTempConnect.trans:=[nWeldLineLength_R2+nCorrX_Store+(X),nCorrY_Store+(Y),nCorrZ_Store+(Z)];
                pTempConnect.rot:=[0.5,-0.5,-0.5,-0.5];
                pTempConnect:=RelTool(pTempConnect,0,0,0\Rx:=macroEndBuffer2{nMotionEndStepLast{2}}.TravelAngle\Ry:=-1*macroEndBuffer2{nMotionEndStepLast{2}}.WorkingAngle+nBreakPoint{2});
            ELSE
                pTempConnect.trans:=[nWeldLineLength_R2+nCorrX_Store+(X),nCorrY_Store+(Y*(-1)),nCorrZ_Store+(Z)];
                pTempConnect.rot:=[0.5,0.5,-0.5,0.5];
                pTempConnect:=RelTool(pTempConnect,0,0,0\Rx:=-1*macroEndBuffer2{nMotionEndStepLast{2}}.TravelAngle\Ry:=-1*macroEndBuffer2{nMotionEndStepLast{2}}.WorkingAngle+nBreakPoint{2});
            ENDIF
        ENDIF

        IF Present(LIN)=FALSE THEN
            MoveJ pTempConnect,v300,fine,tWeld2\WObj:=wobjWeldLine2;
        ELSE
            MoveL pTempConnect,v300,fine,tWeld2\WObj:=wobjWeldLine2;
        ENDIF

        RETURN ;
    ENDPROC

    PROC rCorrSearchWeldLineEdgeX(num X,num Y,num Z,num Depth,num RetX,bool isStartPos,bool CCW,string dirErrorCheck)
        VAR num nCorrX_Store;
        VAR num nCorrY_Store;
        VAR num nCorrZ_Store;
        WaitUntil bRobSwap=CCW;
        IF (isStartPos=bStart) THEN
            nCorrX_Store:=nCorrX_Store_Start{2};
            nCorrY_Store:=nCorrY_Store_Start{2};
            nCorrZ_Store:=nCorrZ_Store_Start{2};
        ELSE
            nCorrX_Store:=nCorrX_Store_End{2};
            nCorrY_Store:=nCorrY_Store_End{2};
            nCorrZ_Store:=nCorrZ_Store_End{2};
        ENDIF

        TouchErrorDirSub:=dirErrorCheck;
        IF TouchErrorDirMain=dirErrorCheck AND nTouchRetryCount{2}>0 THEN
            IF (isStartPos=bEnd AND (nMacro001{1}=2 OR nMacro001{1}=5)) OR (isStartPos=bStart AND (nMacro010{1}=2 OR nMacro010{1}=5)) THEN
                Depth:=Depth+((RetryDepthData{1}*(-1))*nTouchRetryCount{2});
            ELSE
                Depth:=Depth+(RetryDepthData{1}*nTouchRetryCount{2});
            ENDIF
        ENDIF
        !!! Search weld X edge !!!
        WaitUntil bRobSwap=CCW;
        IF (isStartPos=bStart) THEN
            !        pSearchStart:=ConvertTcpToGantryCoord(pWeldPosR2{1}.position);
            pSearchStart.rot:=Welds2{1}.position.rot;
            IF (CCW=FALSE) pSearchStart.trans:=[nCorrX_Store+(-1*X),nCorrY_Store+(Y),nCorrZ_Store+(Z)];
            IF (CCW=TRUE) pSearchStart.trans:=[nCorrX_Store+(-1*X),nCorrY_Store+(Y*(-1)),nCorrZ_Store+(Z)];
        ELSEIF (isStartPos=bEnd) THEN
            !        pSearchStart:=ConvertTcpToGantryCoord(pWeldPosR2{nMotionStepCount}.position);
            !  pSearchStart.rot:=pWeldPosR2{nMotionStepCount{2}}.rot;
            pSearchStart.rot:=Welds2{nMotionStepCount{2}}.position.rot;
            IF (CCW=FALSE) pSearchStart.trans:=[nWeldLineLength_R2+nCorrX_Store+(X),nCorrY_Store+(Y),nCorrZ_Store+(Z)];
            IF (CCW=TRUE) pSearchStart.trans:=[nWeldLineLength_R2+nCorrX_Store+(X),nCorrY_Store+(Y*(-1)),nCorrZ_Store+(Z)];
        ENDIF

        pSearchStart.robconf.cfx:=1;
        pSearchStart.extax:=[9e9,9e9,9e9,9e9,9e9,9e9];
        !    pSearchStart.extax.eax_d:=wobjWeldLine1.uframe.trans.z-(nRobCorrSpaceHeight+wobjWeldLine1.oframe.trans.z);

        pSearchEnd:=pSearchStart;
        IF (isStartPos=bStart) pSearchEnd.trans.x:=pSearchStart.trans.x+Depth;
        IF (isStartPos=bEnd) pSearchEnd.trans.x:=pSearchStart.trans.x-Depth;

        rCorrSearchByWire pSearchStart,pSearchEnd\X;

        IF (isStartPos=bStart) nCorrX_Store:=pCorredPosBuffer.x;
        IF (isStartPos=bEnd) nCorrX_Store:=pCorredPosBuffer.x-nWeldLineLength_R2;

        IF (isStartPos=bStart) THEN
            nCorrX_Store_Start{2}:=nCorrX_Store;
            nCorrY_Store_Start{2}:=nCorrY_Store;
            nCorrZ_Store_Start{2}:=nCorrZ_Store;
        ELSE
            nCorrX_Store_End{2}:=nCorrX_Store;
            nCorrY_Store_End{2}:=nCorrY_Store;
            nCorrZ_Store_End{2}:=nCorrZ_Store;
        ENDIF

        rMoveCorrConnect RetX,Y,Z,0,0,0,pSearchStart.extax.eax_d,isStartPos,CCW;
        nTouchRetryCount{2}:=0;
        TouchErrorDirMain:="Ready";

        RETURN ;
    ENDPROC

    PROC rCorrSearchWeldLineEdgeY(num X,num Y,num Z,num Depth,num RetY,bool isStartPos,bool CCW,string dirErrorCheck)
        VAR num nCorrX_Store;
        VAR num nCorrY_Store;
        VAR num nCorrZ_Store;
        WaitUntil bRobSwap=CCW;
        IF (isStartPos=bStart) THEN
            nCorrX_Store:=nCorrX_Store_Start{2};
            nCorrY_Store:=nCorrY_Store_Start{2};
            nCorrZ_Store:=nCorrZ_Store_Start{2};
        ELSE
            nCorrX_Store:=nCorrX_Store_End{2};
            nCorrY_Store:=nCorrY_Store_End{2};
            nCorrZ_Store:=nCorrZ_Store_End{2};
        ENDIF

        TouchErrorDirSub:=dirErrorCheck;
        RetryDepthData{2}:=RetryDepthData{2}*(-1);
        IF TouchErrorDirMain=dirErrorCheck AND nTouchRetryCount{2}>0 Depth:=Depth+(RetryDepthData{2}*nTouchRetryCount{2});
        RetryDepthData{2}:=RetryDepthData{2}*(-1);

        !!! Search weld Y edge !!!
        WaitUntil bRobSwap=CCW;
        IF (isStartPos=bStart) THEN
            !        pSearchStart:=ConvertTcpToGantryCoord(pWeldPosR2{1}.position);
            pSearchStart.rot:=Welds2{1}.position.rot;
            IF (CCW=FALSE) pSearchStart.trans:=[nCorrX_Store+(-1*X),nCorrY_Store+(Y),nCorrZ_Store+(Z)];
            IF (CCW=TRUE) pSearchStart.trans:=[nCorrX_Store+(-1*X),nCorrY_Store+(Y*(-1)),nCorrZ_Store+Z];
        ELSEIF (isStartPos=bEnd) THEN
            !        pSearchStart:=ConvertTcpToGantryCoord(pWeldPosR2{nMotionStepCount}.position);
            !pSearchStart.rot:=pWeldPosR2{nMotionStepCount{2}}.rot;
            pSearchStart.rot:=Welds2{nMotionStepCount{2}}.position.rot;
            IF (CCW=FALSE) pSearchStart.trans:=[nWeldLineLength_R2+nCorrX_Store+(X),nCorrY_Store+(Y),nCorrZ_Store+(Z)];
            IF (CCW=TRUE) pSearchStart.trans:=[nWeldLineLength_R2+nCorrX_Store+(X),nCorrY_Store+(Y*(-1)),nCorrZ_Store+(Z)];
        ENDIF

        pSearchStart.robconf.cfx:=1;
        !  pSearchStart.extax.eax_d:=wobjWeldLine1.uframe.trans.z-(nRobCorrSpaceHeight+wobjWeldLine1.oframe.trans.z);

        pSearchEnd:=pSearchStart;
        pSearchStart.extax:=[9e9,9e9,9e9,9e9,9e9,9e9];
        IF (CCW=FALSE) pSearchEnd.trans.y:=pSearchStart.trans.y-Depth;
        IF (CCW=TRUE) pSearchEnd.trans.y:=pSearchStart.trans.y+Depth;

        rCorrSearchByWire pSearchStart,pSearchEnd\Y;

        nCorrY_Store:=pCorredPosBuffer.y;

        IF (isStartPos=bStart) THEN
            nCorrX_Store_Start{2}:=nCorrX_Store;
            nCorrY_Store_Start{2}:=nCorrY_Store;
            nCorrZ_Store_Start{2}:=nCorrZ_Store;
        ELSE
            nCorrX_Store_End{2}:=nCorrX_Store;
            nCorrY_Store_End{2}:=nCorrY_Store;
            nCorrZ_Store_End{2}:=nCorrZ_Store;
        ENDIF

        rMoveCorrConnect X,RetY,Z,0,0,0,pSearchStart.extax.eax_d,isStartPos,CCW;
        nTouchRetryCount{2}:=0;
        TouchErrorDirMain:="Ready";

        RETURN ;
    ENDPROC

    PROC rCorrSearchWeldLineEdgeZ(num X,num Y,num Z,num Depth,num RetZ,bool isStartPos,bool CCW,string dirErrorCheck)
        VAR num nCorrX_Store;
        VAR num nCorrY_Store;
        VAR num nCorrZ_Store;
        WaitUntil bRobSwap=CCW;
        IF (isStartPos=bStart) THEN
            nCorrX_Store:=nCorrX_Store_Start{2};
            nCorrY_Store:=nCorrY_Store_Start{2};
            nCorrZ_Store:=nCorrZ_Store_Start{2};
        ELSE
            nCorrX_Store:=nCorrX_Store_End{2};
            nCorrY_Store:=nCorrY_Store_End{2};
            nCorrZ_Store:=nCorrZ_Store_End{2};
        ENDIF
        TouchErrorDirSub:=dirErrorCheck;
        IF TouchErrorDirMain=dirErrorCheck AND nTouchRetryCount{2}>0 Depth:=Depth+(RetryDepthData{3}*nTouchRetryCount{2});
        !!! Search weld Z edge !!!
        WaitUntil bRobSwap=CCW;
        IF (isStartPos=bStart) THEN
            !       pSearchStart:=ConvertTcpToGantryCoord(pWeldPosR2{1}.position);
            pSearchStart.rot:=Welds2{1}.position.rot;
            IF (CCW=FALSE) pSearchStart.trans:=[nCorrX_Store+(-1*X),nCorrY_Store+(Y),nCorrZ_Store+(Z)];
            IF (CCW=TRUE) pSearchStart.trans:=[nCorrX_Store+(-1*X),nCorrY_Store+(Y*(-1)),nCorrZ_Store+(Z)];
        ELSEIF (isStartPos=bEnd) THEN
            !        pSearchStart:=ConvertTcpToGantryCoord(pWeldPosR2{nMotionStepCount}.position);
            pSearchStart.rot:=Welds2{nMotionStepCount{2}}.position.rot;
            ! pSearchStart.rot:=pWeldPosR2{nMotionStepCount{2}}.rot;
            IF (CCW=FALSE) pSearchStart.trans:=[nWeldLineLength_R2+nCorrX_Store+(X),nCorrY_Store+(Y),nCorrZ_Store+(Z)];
            IF (CCW=TRUE) pSearchStart.trans:=[nWeldLineLength_R2+nCorrX_Store+(X),nCorrY_Store+(Y*(-1)),nCorrZ_Store+(Z)];
        ENDIF

        pSearchStart.robconf.cfx:=1;
        pSearchStart.extax:=[9e9,9e9,9e9,9e9,9e9,9e9];
        !  pSearchStart.extax.eax_d:=wobjWeldLine1.uframe.trans.z-(nRobCorrSpaceHeight+wobjWeldLine1.oframe.trans.z);

        pSearchEnd:=pSearchStart;
        pSearchEnd.trans.z:=pSearchStart.trans.z-Depth;

        rCorrSearchByWire pSearchStart,pSearchEnd\Z;

        nCorrZ_Store:=pCorredPosBuffer.z;

        IF (isStartPos=bStart) THEN
            nCorrX_Store_Start{2}:=nCorrX_Store;
            nCorrY_Store_Start{2}:=nCorrY_Store;
            nCorrZ_Store_Start{2}:=nCorrZ_Store;
        ELSE
            nCorrX_Store_End{2}:=nCorrX_Store;
            nCorrY_Store_End{2}:=nCorrY_Store;
            nCorrZ_Store_End{2}:=nCorrZ_Store;
        ENDIF

        rMoveCorrConnect X,Y,RetZ,0,0,0,pSearchStart.extax.eax_d,isStartPos,CCW;
        nTouchRetryCount{2}:=0;
        TouchErrorDirMain:="Ready";

        RETURN ;
    ENDPROC

    PROC rCorrSearchByWire(robtarget SearchStart,robtarget SearchEnd,\switch X\switch Y\switch Z)
        VAR robtarget pTemp:=[[0,0,0],[1,0,0,0],[0,0,0,0],[0,0,0,0,9E+09,9E+09]];
        MoveJ SearchStart,v100,fine,tWeld2\WObj:=wobjWeldLine2;
        rCheckWelder;
        SearchL\SStop,bWireTouch2,SearchStart,SearchEnd,v10,tWeld2\WObj:=wobjWeldLine2;

        Reset soLn2Touch;
        WaitTime 0;
        WaitUntil(siLn2TouchActive=0);
        pTemp:=CRobT(\taskname:="T_ROB2"\tool:=tWeld2\WObj:=wobjWeldLine2);
        pCorredPosBuffer:=pTemp.trans;
        !        stop;
        RETURN ;
    ERROR

        TouchErrorDirMain:=TouchErrorDirSub;
        IDelete iMoveHome_RBT2;
        IF ERRNO=ERR_WHLSEARCH THEN
            rTouchErrorHandling 2;
        ELSEIF ERRNO=ERR_SIGSUPSEARCH THEN
            WaitTime 999;
            rTouchErrorHandling 3;
        ELSE
            rTouchErrorHandling 3;
        ENDIF
    ENDPROC

    PROC rZero()
        MoveAbsJ [[0,0,0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]]\NoEOffs,v1000,fine,tool0;
    ENDPROC

    PROC rErrorDuringEntry()
        VAR robtarget pTemp;
        Reset soLn2Touch;
        StopMove;
        ClearPath;
        StartMove;
        pTemp:=CRobT(\TaskName:="T_ROB2"\Tool:=tWeld2\WObj:=wobjWeldLine2);
        MoveL RelTool(pTemp,0,0,-10),vTargetSpeed,fine,tWeld2\WObj:=wobjWeldLine2;
        stReact{2}:="Error_Arc_Touch";
        WaitSyncTask Wait{80},taskGroup123;
        WaitUntil stReact=["Error_Arc_Touch","Error_Arc_Touch","Error_Arc_Touch"];
        WaitSyncTask Wait{81},taskGroup123;
        WaitUntil stCommand="Error_Arc_Touch";
        stReact{2}:="";
        WaitUntil stCommand="";
        WaitSyncTask Wait{82},taskGroup123;

        ExitCycle;
    ENDPROC

    PROC rArcError()
        VAR robtarget pTemp;

        IDelete iMoveHome_RBT2;
        StopMove;
        ClearPath;
        StartMove;
        IF bRobSwap=FALSE THEN
            Set po37_ArcR2Error;
            MonitorweldErrorpostion.monPose1:=MonitorPosition.monPose1;
            MonitorweldErrorpostion.monPose2:=MonitorPosition.monPose2;
        ELSE
            Set po36_ArcR1Error;
            MonitorweldErrorpostion.monPose1:=MonitorPosition.monPose1;
            MonitorweldErrorpostion.monPose2:=MonitorPosition.monPose2;
        ENDIF

        pTemp:=CRobT(\TaskName:="T_ROB2"\Tool:=tWeld2\WObj:=wobjWeldLine2);
        MoveL RelTool(pTemp,0,0,-10),vTargetSpeed,z0,tWeld2\WObj:=wobjWeldLine2;

        stReact{2}:="Error_Arc_Touch";
        WaitSyncTask Wait{80},taskGroup123;
        WaitUntil stReact=["Error_Arc_Touch","Error_Arc_Touch","Error_Arc_Touch"];
        WaitSyncTask Wait{81},taskGroup123;
        WaitUntil stCommand="Error_Arc_Touch";
        stReact{2}:="";
        WaitUntil stCommand="";
        WaitSyncTask Wait{82},taskGroup123;
        ExitCycle;

    ENDPROC

    PROC rTouchErrorHandling(num Errorno)
        VAR robtarget pTemp;
        Reset soLn2Touch;
        Set po35_TouchR2Error;
        IDelete iMoveHome_RBT2;

        pTemp:=CRobT(\TaskName:="T_ROB2"\tool:=tWeld2\WObj:=wobjWeldLine2);
        MoveL RelTool(pTemp,0,0,-10),v200,z10,tWeld2\WObj:=wobjWeldLine2;
        stReact{2}:="Error_Arc_Touch";
        WaitSyncTask Wait{80},taskGroup123;
        WaitUntil stReact=["Error_Arc_Touch","Error_Arc_Touch","Error_Arc_Touch"];
        WaitSyncTask Wait{81},taskGroup123;
        WaitUntil stCommand="Error_Arc_Touch";
        stReact{2}:="";
        WaitUntil stCommand="";
        WaitSyncTask Wait{82},taskGroup123;
        StartMove;
        ExitCycle;


    ENDPROC

    PROC rT_ROB2check()
        VAR robtarget pTemp;
        pTemp:=CRobT(\TaskName:="T_ROB2"\Tool:=tWeld2\WObj:=wobjWeldLine2);
        IF Abs(pTemp.trans.Y)<100 AND Abs(pTemp.trans.Z)<200 THEN
            IF pTemp.trans.Y>0 then
                pTemp.trans.y:=140;
                MoveL pTemp,v100,z10,tWeld2\WObj:=wobjWeldLine2;
            ENDIF
            IF pTemp.trans.Y<0 THEN
                pTemp.trans.y:=-140;
                MoveL pTemp,v100,z10,tWeld2\WObj:=wobjWeldLine2;
            ENDIF
        ENDIF
    ENDPROC

    PROC rCheckWelder()
        IF (soLn2Touch=1) THEN
            Reset soLn2Touch;
            WaitTime 0.5;
        ENDIF
        WaitTime 0.5;
        WaitUntil(siLn2TouchActive=0 OR soLn2Touch=0);
        Set soLn2Touch;
        WaitUntil(siLn2TouchActive=1 AND soLn2Touch=1);
    ENDPROC

    PROC rWeldinit()
        return1:
        !!!===ArcWareReset===!!!
        reset soAwDeleteSDB2;
        WaitUntil soAwDeleteSDB2=0\MaxTime:=5;
        reset soAwError2;
        WaitUntil soAwError2=0\MaxTime:=5;
        reset soAwGasOn2;
        WaitUntil soAwGasOn2=0\MaxTime:=5;
        reset soAwInitSDB2;
        WaitUntil soAwInitSDB2=0\MaxTime:=5;
        reset soAwManFeed15mm2;
        WaitUntil soAwManFeed15mm2=0\MaxTime:=5;
        reset soAwManFeedRev2;
        WaitUntil soAwManFeedRev2=0\MaxTime:=5;
        reset soAwManGasOn2;
        WaitUntil soAwManGasOn2=0\MaxTime:=5;
        reset soAwOnFlag2;
        WaitUntil soAwOnFlag2=0\MaxTime:=5;
        reset soAwRestart2;
        WaitUntil soAwRestart2=0\MaxTime:=5;
        reset soAwRunning2;
        WaitUntil soAwRunning2=0\MaxTime:=5;
        reset soAwWeldUpdate2;
        WaitUntil soAwWeldUpdate2=0\MaxTime:=5;
        set soAwTaskReady2;
        WaitUntil soAwTaskReady2=1\MaxTime:=5;
        set soAwStart2;
        WaitUntil soAwStart2=1\MaxTime:=5;
        set soAwEquipOK2;
        WaitUntil soAwEquipOK2=1\MaxTime:=5;
        !!!!!!!====Lincoln_Reset====!!!!
        reset soLn2AdjWireStickOut;
        WaitUntil soLn2AdjWireStickOut=0\MaxTime:=5;
        reset soLn2ArcOkLatch;
        WaitUntil soLn2ArcOkLatch=0\MaxTime:=5;
        set soLn2BusAvailable;
        WaitUntil soLn2BusAvailable=1\MaxTime:=5;
        reset soLn2EvalWeldDataLog;
        WaitUntil soLn2EvalWeldDataLog=0\MaxTime:=5;
        reset soLn2FeedOn;
        WaitUntil soLn2FeedOn=0\MaxTime:=5;
        reset soLn2Gas;
        WaitUntil soLn2Gas=0\MaxTime:=5;
        reset soLn2GasError;
        WaitUntil soLn2GasError=0\MaxTime:=5;
        set soLn2Installed;
        WaitUntil soLn2Installed=1\MaxTime:=5;
        set soLn2Listen;
        WaitUntil soLn2Listen=1\MaxTime:=5;
        reset soLn2LoadWeldModes;
        WaitUntil soLn2LoadWeldModes=0\MaxTime:=5;
        reset soLn2ManWireFeed;
        WaitUntil soLn2ManWireFeed=0\MaxTime:=5;
        set soLn2NOP_Enable;
        WaitUntil soLn2NOP_Enable=1\MaxTime:=5;
        reset soLn2NOPDisable;
        WaitUntil soLn2NOPDisable=0\MaxTime:=5;
        reset soLn2SaveCapLog;
        WaitUntil soLn2SaveCapLog=0\MaxTime:=5;
        reset soLn2ShowRecMessage;
        WaitUntil soLn2ShowRecMessage=0\MaxTime:=5;
        reset soLn2StartPart;
        WaitUntil soLn2StartPart=0\MaxTime:=5;
        set soLn2StartupComplete;
        WaitUntil soLn2StartupComplete=1\MaxTime:=5;
        reset soLn2StopProc;
        WaitUntil soLn2StopProc=0\MaxTime:=5;
        set soLn2T1Exec;
        WaitUntil soLn2T1Exec=1\MaxTime:=5;
        set soLn2T2Exec;
        WaitUntil soLn2T2Exec=1\MaxTime:=5;
        reset soLn2Touch;
        WaitUntil soLn2Touch=0\MaxTime:=5;
        reset soLn2TouchActive;
        WaitUntil soLn2TouchActive=0\MaxTime:=5;
        set soLn2ValidSchedule;
        WaitUntil soLn2ValidSchedule=1\MaxTime:=5;
        reset soLn2VoltError;
        WaitUntil soLn2VoltError=0\MaxTime:=5;
        reset soLn2WaterError;
        WaitUntil soLn2WaterError=0\MaxTime:=5;
        reset soLn2Weld;
        WaitUntil soLn2Weld=0\MaxTime:=5;
        reset soLn2WeldDataLogOn;
        WaitUntil soLn2WeldDataLogOn=0\MaxTime:=5;
        set soLn2WelderRdyDO;
        WaitUntil soLn2WelderRdyDO=1\MaxTime:=5;
        reset soLn2WeldError;
        WaitUntil soLn2WeldError=0\MaxTime:=5;
        reset soLn2WireBurnOff;
        WaitUntil soLn2WireBurnOff=0\MaxTime:=5;
        reset soLn2WireFeedError;
        WaitUntil soLn2WireFeedError=0\MaxTime:=5;
        set soLn2WireFeedRdyDO;
        WaitUntil soLn2WireFeedRdyDO=1\MaxTime:=5;
        reset soLn2WireStickDO;
        WaitUntil soLn2WireStickDO=0\MaxTime:=5;
        RETURN ;
        GOTO return1;
    ENDPROC

    PROC Routine2()
        MoveJ [[-0.00,981.00,441.10],[0.5,-0.5,0.5,0.5],[1,0,0,2],[9E+9,9E+9,9E+9,9E+9,9E+9,9E+9]],v1000,z50,tool0;
    ENDPROC

    PROC rUpdateR2Position()
        VAR num X;
        VAR num Y;
        VAR num Z;
        VAR num R;
        VAR num X2;
        VAR num Y2;
        VAR num Z2;
        !        jTemp:=[[0,0,0,0,0,0],[0,0,0,30,0,0]];
        jTemp := CJointT(\TaskName:="T_ROB1");

        X:=jtemp.extax.eax_a;
        Y:=jtemp.extax.eax_b;
        Z:=jtemp.extax.eax_c;
        R:=jtemp.extax.eax_d;

        X2:=X-(488*cos(R));
        !X2:=X-(976*cos(R));
        Y2:=Y-(488*sin(R));
        !Y2:=Y-(976*sin(R));

        nCaledR2Pos:=[X2,Y2,Z];
        wobjtest:=[FALSE,TRUE,"GantryRob",[[X2,Y2,Z],[1,0,0,0]],[[0,0,0],[1,0,0,0]]];
    ENDPROC

	!========================================
	! Robot2 Capability Tests
	!========================================
	! Version: v1.0.0
	! Date: 2025-12-17
	! Purpose: Verify Robot2 gantry external axis access

	!========================================
	! Test 1: Read External Axes via CJointT()
	!========================================
	PROC TestRobot2_ReadExternalAxes()
		VAR jointtarget current_joint;
		VAR num gantry_x;
		VAR num gantry_y;
		VAR num gantry_z;
		VAR num gantry_r;
		VAR num gantry_x2;
		VAR iodev logfile;

		TPWrite "========================================";
		TPWrite "Test 1: Robot2 - Read External Axes";
		TPWrite "========================================";

		current_joint := CJointT();

		TPWrite "Robot Joints:";
		TPWrite "  J1 = " + NumToStr(current_joint.robax.rax_1, 2) + " deg";
		TPWrite "  J2 = " + NumToStr(current_joint.robax.rax_2, 2) + " deg";
		TPWrite "  J3 = " + NumToStr(current_joint.robax.rax_3, 2) + " deg";
		TPWrite "  J4 = " + NumToStr(current_joint.robax.rax_4, 2) + " deg";
		TPWrite "  J5 = " + NumToStr(current_joint.robax.rax_5, 2) + " deg";
		TPWrite "  J6 = " + NumToStr(current_joint.robax.rax_6, 2) + " deg";

		gantry_x := current_joint.extax.eax_a;
		gantry_y := current_joint.extax.eax_b;
		gantry_z := current_joint.extax.eax_c;
		gantry_r := current_joint.extax.eax_d;
		gantry_x2 := current_joint.extax.eax_f;

		TPWrite "Gantry External Axes:";
		TPWrite "  X1 = " + NumToStr(gantry_x, 4) + " m";
		TPWrite "  Y  = " + NumToStr(gantry_y, 4) + " m";
		TPWrite "  Z  = " + NumToStr(gantry_z, 4) + " m";
		TPWrite "  R  = " + NumToStr(gantry_r, 4) + " rad";
		TPWrite "  X2 = " + NumToStr(gantry_x2, 4) + " m";

		Open "/HOME/", logfile \Write;
		Open "robot2_external_axes_test.txt", logfile \Append;

		Write logfile, "========================================";
		Write logfile, "Robot2 - External Axes Reading Test";
		Write logfile, "========================================";
		Write logfile, "Date: " + CDate();
		Write logfile, "Time: " + CTime();
		Write logfile, "";
		Write logfile, "Robot Joints: ["
			+ NumToStr(current_joint.robax.rax_1, 2) + ", "
			+ NumToStr(current_joint.robax.rax_2, 2) + ", "
			+ NumToStr(current_joint.robax.rax_3, 2) + ", "
			+ NumToStr(current_joint.robax.rax_4, 2) + ", "
			+ NumToStr(current_joint.robax.rax_5, 2) + ", "
			+ NumToStr(current_joint.robax.rax_6, 2) + "]";
		Write logfile, "";
		Write logfile, "Gantry External Axes:";
		Write logfile, "  X1 = " + NumToStr(gantry_x, 4) + " m";
		Write logfile, "  Y  = " + NumToStr(gantry_y, 4) + " m";
		Write logfile, "  Z  = " + NumToStr(gantry_z, 4) + " m";
		Write logfile, "  R  = " + NumToStr(gantry_r, 4) + " rad";
		Write logfile, "  X2 = " + NumToStr(gantry_x2, 4) + " m";
		Write logfile, "";
		Write logfile, "Result: ";

		IF gantry_x <> 9E9 OR gantry_y <> 9E9 OR gantry_z <> 9E9 THEN
			Write logfile, "SUCCESS - Robot2 can read gantry external axes!";
			TPWrite "Result: SUCCESS";
		ELSE
			Write logfile, "FAIL - Robot2 cannot read gantry external axes";
			TPWrite "Result: FAIL";
		ENDIF

		Write logfile, "========================================\0A";
		Close logfile;

		TPWrite "========================================";
		TPWrite "Test 1 Complete. Check robot2_external_axes_test.txt";

	ERROR
		TPWrite "ERROR in TestRobot2_ReadExternalAxes: " + NumToStr(ERRNO, 0);
		Close logfile;
		TRYNEXT;
	ENDPROC

	!========================================
	! Test 2: Robot2 TCP Coordinates
	!========================================
	PROC TestRobot2_TCPCoordinates()
		VAR robtarget tcp_world;
		VAR robtarget tcp_wobj0;
		VAR robtarget tcp_base;
		VAR iodev logfile;

		TPWrite "========================================";
		TPWrite "Test 2: Robot2 - TCP Coordinates";
		TPWrite "========================================";

		tcp_world := CRobT(\Tool:=tool0);
		tcp_wobj0 := CRobT(\Tool:=tool0\WObj:=wobj0);
		tcp_base := tcp_wobj0;

		TPWrite "World Coordinates:";
		TPWrite "  X = " + NumToStr(tcp_world.trans.x, 3) + " mm";
		TPWrite "  Y = " + NumToStr(tcp_world.trans.y, 3) + " mm";
		TPWrite "  Z = " + NumToStr(tcp_world.trans.z, 3) + " mm";

		TPWrite "wobj0 Coordinates:";
		TPWrite "  X = " + NumToStr(tcp_wobj0.trans.x, 3) + " mm";
		TPWrite "  Y = " + NumToStr(tcp_wobj0.trans.y, 3) + " mm";
		TPWrite "  Z = " + NumToStr(tcp_wobj0.trans.z, 3) + " mm";

		Open "/HOME/", logfile \Write;
		Open "robot2_tcp_coordinates.txt", logfile \Append;

		Write logfile, "========================================";
		Write logfile, "Robot2 - TCP Coordinates Test";
		Write logfile, "========================================";
		Write logfile, "Date: " + CDate();
		Write logfile, "Time: " + CTime();
		Write logfile, "";
		Write logfile, "1. World Coordinates:";
		Write logfile, "   X = " + NumToStr(tcp_world.trans.x, 3) + " mm";
		Write logfile, "   Y = " + NumToStr(tcp_world.trans.y, 3) + " mm";
		Write logfile, "   Z = " + NumToStr(tcp_world.trans.z, 3) + " mm";
		Write logfile, "";
		Write logfile, "2. wobj0 Coordinates:";
		Write logfile, "   X = " + NumToStr(tcp_wobj0.trans.x, 3) + " mm";
		Write logfile, "   Y = " + NumToStr(tcp_wobj0.trans.y, 3) + " mm";
		Write logfile, "   Z = " + NumToStr(tcp_wobj0.trans.z, 3) + " mm";
		Write logfile, "";
		Write logfile, "Note: Robot2 wobj0 should be at Robot2 Base";
		Write logfile, "========================================\0A";

		Close logfile;

		TPWrite "========================================";
		TPWrite "Test 2 Complete. Check robot2_tcp_coordinates.txt";

	ERROR
		TPWrite "ERROR in TestRobot2_TCPCoordinates: " + NumToStr(ERRNO, 0);
		Close logfile;
		TRYNEXT;
	ENDPROC

	!========================================
	! Test Runner
	!========================================
	PROC RunAllTests()
		TPWrite "Starting Robot2 Capabilities Test Suite...";
		TPWrite "";

		TestRobot2_ReadExternalAxes;
		WaitTime 2;

		TestRobot2_TCPCoordinates;
		WaitTime 2;

		TPWrite "";
		TPWrite "All tests complete!";
		TPWrite "Check /HOME folder for result files.";
	ENDPROC

	!========================================
	! Compare Robot1/Robot2 wobj0 (Snapshot)
	!========================================
	! Version: v1.6.0
	! Date: 2025-12-25
	! Purpose: Print Robot1/Robot2 wobj0 values and differences in one output
	PROC CompareWobj0Snapshots()
		VAR iodev logfile;
		VAR num dux;
		VAR num duy;
		VAR num duz;
		VAR num dox;
		VAR num doy;
		VAR num doz;
		VAR num duq1;
		VAR num duq2;
		VAR num duq3;
		VAR num duq4;
		VAR num doq1;
		VAR num doq2;
		VAR num doq3;
		VAR num doq4;

		TPWrite "========================================";
		TPWrite "Compare Robot1/Robot2 wobj0 (v1.6.0)";
		TPWrite "========================================";

		! Refresh Robot1 snapshot from TASK1
		%"T_ROB1:UpdateRobot1Wobj0Snapshot"%;

		TPWrite "Robot1 wobj0 (T_ROB1):";
		TPWrite "  UFrame X = " + NumToStr(robot1_wobj0_snapshot.uframe.trans.x, 2);
		TPWrite "  UFrame Y = " + NumToStr(robot1_wobj0_snapshot.uframe.trans.y, 2);
		TPWrite "  UFrame Z = " + NumToStr(robot1_wobj0_snapshot.uframe.trans.z, 2);
		TPWrite "  UFrame q1 = " + NumToStr(robot1_wobj0_snapshot.uframe.rot.q1, 4);
		TPWrite "  UFrame q2 = " + NumToStr(robot1_wobj0_snapshot.uframe.rot.q2, 4);
		TPWrite "  UFrame q3 = " + NumToStr(robot1_wobj0_snapshot.uframe.rot.q3, 4);
		TPWrite "  UFrame q4 = " + NumToStr(robot1_wobj0_snapshot.uframe.rot.q4, 4);
		TPWrite "  OFrame X = " + NumToStr(robot1_wobj0_snapshot.oframe.trans.x, 2);
		TPWrite "  OFrame Y = " + NumToStr(robot1_wobj0_snapshot.oframe.trans.y, 2);
		TPWrite "  OFrame Z = " + NumToStr(robot1_wobj0_snapshot.oframe.trans.z, 2);

		TPWrite "";
		TPWrite "Robot2 wobj0 (T_ROB2):";
		TPWrite "  UFrame X = " + NumToStr(wobj0.uframe.trans.x, 2);
		TPWrite "  UFrame Y = " + NumToStr(wobj0.uframe.trans.y, 2);
		TPWrite "  UFrame Z = " + NumToStr(wobj0.uframe.trans.z, 2);
		TPWrite "  UFrame q1 = " + NumToStr(wobj0.uframe.rot.q1, 4);
		TPWrite "  UFrame q2 = " + NumToStr(wobj0.uframe.rot.q2, 4);
		TPWrite "  UFrame q3 = " + NumToStr(wobj0.uframe.rot.q3, 4);
		TPWrite "  UFrame q4 = " + NumToStr(wobj0.uframe.rot.q4, 4);
		TPWrite "  OFrame X = " + NumToStr(wobj0.oframe.trans.x, 2);
		TPWrite "  OFrame Y = " + NumToStr(wobj0.oframe.trans.y, 2);
		TPWrite "  OFrame Z = " + NumToStr(wobj0.oframe.trans.z, 2);

		dux := wobj0.uframe.trans.x - robot1_wobj0_snapshot.uframe.trans.x;
		duy := wobj0.uframe.trans.y - robot1_wobj0_snapshot.uframe.trans.y;
		duz := wobj0.uframe.trans.z - robot1_wobj0_snapshot.uframe.trans.z;
		dox := wobj0.oframe.trans.x - robot1_wobj0_snapshot.oframe.trans.x;
		doy := wobj0.oframe.trans.y - robot1_wobj0_snapshot.oframe.trans.y;
		doz := wobj0.oframe.trans.z - robot1_wobj0_snapshot.oframe.trans.z;
		duq1 := wobj0.uframe.rot.q1 - robot1_wobj0_snapshot.uframe.rot.q1;
		duq2 := wobj0.uframe.rot.q2 - robot1_wobj0_snapshot.uframe.rot.q2;
		duq3 := wobj0.uframe.rot.q3 - robot1_wobj0_snapshot.uframe.rot.q3;
		duq4 := wobj0.uframe.rot.q4 - robot1_wobj0_snapshot.uframe.rot.q4;
		doq1 := wobj0.oframe.rot.q1 - robot1_wobj0_snapshot.oframe.rot.q1;
		doq2 := wobj0.oframe.rot.q2 - robot1_wobj0_snapshot.oframe.rot.q2;
		doq3 := wobj0.oframe.rot.q3 - robot1_wobj0_snapshot.oframe.rot.q3;
		doq4 := wobj0.oframe.rot.q4 - robot1_wobj0_snapshot.oframe.rot.q4;

		TPWrite "";
		TPWrite "Difference (R2 - R1):";
		TPWrite "  UFrame dX = " + NumToStr(dux, 2);
		TPWrite "  UFrame dY = " + NumToStr(duy, 2);
		TPWrite "  UFrame dZ = " + NumToStr(duz, 2);
		TPWrite "  UFrame dq1 = " + NumToStr(duq1, 4);
		TPWrite "  UFrame dq2 = " + NumToStr(duq2, 4);
		TPWrite "  UFrame dq3 = " + NumToStr(duq3, 4);
		TPWrite "  UFrame dq4 = " + NumToStr(duq4, 4);
		TPWrite "  OFrame dX = " + NumToStr(dox, 2);
		TPWrite "  OFrame dY = " + NumToStr(doy, 2);
		TPWrite "  OFrame dZ = " + NumToStr(doz, 2);
		TPWrite "  OFrame dq1 = " + NumToStr(doq1, 4);
		TPWrite "  OFrame dq2 = " + NumToStr(doq2, 4);
		TPWrite "  OFrame dq3 = " + NumToStr(doq3, 4);
		TPWrite "  OFrame dq4 = " + NumToStr(doq4, 4);
		TPWrite "========================================";

		Open "HOME:/wobj0_compare.txt", logfile \Write;
		Write logfile, "========================================";
		Write logfile, "Compare Robot1/Robot2 wobj0 (v1.6.0)";
		Write logfile, "========================================";
		Write logfile, "Date: " + CDate();
		Write logfile, "Time: " + CTime();
		Write logfile, "";
		Write logfile, "Robot1 wobj0 (T_ROB1):";
		Write logfile, "  UFrame X = " + NumToStr(robot1_wobj0_snapshot.uframe.trans.x, 2);
		Write logfile, "  UFrame Y = " + NumToStr(robot1_wobj0_snapshot.uframe.trans.y, 2);
		Write logfile, "  UFrame Z = " + NumToStr(robot1_wobj0_snapshot.uframe.trans.z, 2);
		Write logfile, "  UFrame q1 = " + NumToStr(robot1_wobj0_snapshot.uframe.rot.q1, 4);
		Write logfile, "  UFrame q2 = " + NumToStr(robot1_wobj0_snapshot.uframe.rot.q2, 4);
		Write logfile, "  UFrame q3 = " + NumToStr(robot1_wobj0_snapshot.uframe.rot.q3, 4);
		Write logfile, "  UFrame q4 = " + NumToStr(robot1_wobj0_snapshot.uframe.rot.q4, 4);
		Write logfile, "  OFrame X = " + NumToStr(robot1_wobj0_snapshot.oframe.trans.x, 2);
		Write logfile, "  OFrame Y = " + NumToStr(robot1_wobj0_snapshot.oframe.trans.y, 2);
		Write logfile, "  OFrame Z = " + NumToStr(robot1_wobj0_snapshot.oframe.trans.z, 2);
		Write logfile, "";
		Write logfile, "Robot2 wobj0 (T_ROB2):";
		Write logfile, "  UFrame X = " + NumToStr(wobj0.uframe.trans.x, 2);
		Write logfile, "  UFrame Y = " + NumToStr(wobj0.uframe.trans.y, 2);
		Write logfile, "  UFrame Z = " + NumToStr(wobj0.uframe.trans.z, 2);
		Write logfile, "  UFrame q1 = " + NumToStr(wobj0.uframe.rot.q1, 4);
		Write logfile, "  UFrame q2 = " + NumToStr(wobj0.uframe.rot.q2, 4);
		Write logfile, "  UFrame q3 = " + NumToStr(wobj0.uframe.rot.q3, 4);
		Write logfile, "  UFrame q4 = " + NumToStr(wobj0.uframe.rot.q4, 4);
		Write logfile, "  OFrame X = " + NumToStr(wobj0.oframe.trans.x, 2);
		Write logfile, "  OFrame Y = " + NumToStr(wobj0.oframe.trans.y, 2);
		Write logfile, "  OFrame Z = " + NumToStr(wobj0.oframe.trans.z, 2);
		Write logfile, "";
		Write logfile, "Difference (R2 - R1):";
		Write logfile, "  UFrame dX = " + NumToStr(dux, 2);
		Write logfile, "  UFrame dY = " + NumToStr(duy, 2);
		Write logfile, "  UFrame dZ = " + NumToStr(duz, 2);
		Write logfile, "  UFrame dq1 = " + NumToStr(duq1, 4);
		Write logfile, "  UFrame dq2 = " + NumToStr(duq2, 4);
		Write logfile, "  UFrame dq3 = " + NumToStr(duq3, 4);
		Write logfile, "  UFrame dq4 = " + NumToStr(duq4, 4);
		Write logfile, "  OFrame dX = " + NumToStr(dox, 2);
		Write logfile, "  OFrame dY = " + NumToStr(doy, 2);
		Write logfile, "  OFrame dZ = " + NumToStr(doz, 2);
		Write logfile, "  OFrame dq1 = " + NumToStr(doq1, 4);
		Write logfile, "  OFrame dq2 = " + NumToStr(doq2, 4);
		Write logfile, "  OFrame dq3 = " + NumToStr(doq3, 4);
		Write logfile, "  OFrame dq4 = " + NumToStr(doq4, 4);
		Write logfile, "========================================\0A";
		Close logfile;

		TPWrite "Saved to: /HOME/wobj0_compare.txt";

	ERROR
		TPWrite "ERROR in CompareWobj0Snapshots: " + NumToStr(ERRNO, 0);
		Close logfile;
		TRYNEXT;
	ENDPROC

	!========================================
	! Check wobj0 Definition
	!========================================
	! Version: v1.1.0
	! Date: 2025-12-18
	! Changes: Added file output to /HOME/task2_wobj0_definition.txt

	PROC ShowWobj0Definition()
		VAR string str_robhold;
		VAR string str_ufprog;
		VAR iodev logfile;

		TPWrite "========================================";
		TPWrite "TASK2 - wobj0 Definition (v1.1.0)";
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
		Open "task2_wobj0_definition.txt", logfile \Append;

		Write logfile, "========================================";
		Write logfile, "TASK2 - wobj0 Definition (v1.1.0)";
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
		TPWrite "Saved to: /HOME/task2_wobj0_definition.txt";

	ERROR
		TPWrite "ERROR in ShowWobj0Definition: " + NumToStr(ERRNO, 0);
		Close logfile;
		TRYNEXT;
	ENDPROC

	! Version: v1.1.0
	! Date: 2025-12-18
	! Changes: Added file output to /HOME/task2_world_vs_wobj0.txt

	PROC CompareWorldAndWobj0()
		VAR robtarget pos_world;
		VAR robtarget pos_wobj0;
		VAR iodev logfile;

		TPWrite "========================================";
		TPWrite "TASK2 - Compare World vs wobj0 (v1.1.0)";
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
		Open "task2_world_vs_wobj0.txt", logfile \Append;

		Write logfile, "========================================";
		Write logfile, "TASK2 - Compare World vs wobj0 (v1.1.0)";
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
		TPWrite "Saved to: /HOME/task2_world_vs_wobj0.txt";

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
	!   4. wobjRob2Base - Robot2 Base Frame (45° rotation per MOC.cfg)
	! Output: FlexPendant display + /HOME/task2_tcp_orientation.txt
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
		tcp_rob_base := CRobT(\Tool:=tool0\WObj:=wobjRob2Base);

		! Display on FlexPendant (reduced output)
		TPWrite "TASK2 - TCP Orientation (v1.2.1)";
		TPWrite "World: [" + NumToStr(tcp_world.trans.x, 1) + "," + NumToStr(tcp_world.trans.y, 1) + "," + NumToStr(tcp_world.trans.z, 1) + "]";
		TPWrite "Floor: [" + NumToStr(tcp_floor.trans.x, 1) + "," + NumToStr(tcp_floor.trans.y, 1) + "," + NumToStr(tcp_floor.trans.z, 1) + "]";
		TPWrite "Rob2Base: [" + NumToStr(tcp_rob_base.trans.x, 1) + "," + NumToStr(tcp_rob_base.trans.y, 1) + "," + NumToStr(tcp_rob_base.trans.z, 1) + "]";

		! Save to file (with WaitTime to prevent "Too intense frequency" error)
		Open "HOME:/task2_tcp_orientation.txt", logfile \Append;

		Write logfile, "========================================";
		Write logfile, "TASK2 - TCP Orientation Verification (v1.2.1)";
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

		Write logfile, "4. Rob2Base: Pos=[" + NumToStr(tcp_rob_base.trans.x, 3) + "," + NumToStr(tcp_rob_base.trans.y, 3) + "," + NumToStr(tcp_rob_base.trans.z, 3) + "]";
		Write logfile, "   Rot=[" + NumToStr(tcp_rob_base.rot.q1, 6) + "," + NumToStr(tcp_rob_base.rot.q2, 6) + "," + NumToStr(tcp_rob_base.rot.q3, 6) + "," + NumToStr(tcp_rob_base.rot.q4, 6) + "]";
		WaitTime 0.05;

		Write logfile, "========================================\0A";

		Close logfile;
		TPWrite "Saved to: /HOME/task2_tcp_orientation.txt";

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
	!   - Move robot in specified coordinate system
	!   - Check if Floor coordinate system shows expected movement
	!   - Validates coordinate system direction and position relationship
	! Parameters:
	!   delta_x, delta_y, delta_z: Movement distance (mm)
	!   mode: 0=WobjFloor base, 1=wobj0 base
	! Output: /HOME/task2_coordinate_test.txt
	PROC TestCoordinateMovement(num delta_x, num delta_y, num delta_z, num mode)
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

		! Calculate target position based on mode
		IF mode = 0 THEN
			! MODE=0: Use WobjFloor as base
			pos_target := CRobT(\Tool:=tool0\WObj:=WobjFloor);
			pos_target.trans.x := pos_target.trans.x + delta_x;
			pos_target.trans.y := pos_target.trans.y + delta_y;
			pos_target.trans.z := pos_target.trans.z + delta_z;
			TPWrite "Moving in Floor coordinate: [" + NumToStr(delta_x, 1) + "," + NumToStr(delta_y, 1) + "," + NumToStr(delta_z, 1) + "]";
			MoveL pos_target, v100, fine, tool0\WObj:=WobjFloor;
		ELSE
			! MODE=1: Use wobj0 as base
			pos_target := CRobT(\Tool:=tool0\WObj:=wobj0);
			pos_target.trans.x := pos_target.trans.x + delta_x;
			pos_target.trans.y := pos_target.trans.y + delta_y;
			pos_target.trans.z := pos_target.trans.z + delta_z;
			TPWrite "Moving in wobj0 coordinate: [" + NumToStr(delta_x, 1) + "," + NumToStr(delta_y, 1) + "," + NumToStr(delta_z, 1) + "]";
			MoveL pos_target, v100, fine, tool0\WObj:=wobj0;
		ENDIF

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
		Open "HOME:/task2_coordinate_test.txt", logfile \Append;

		Write logfile, "========================================";
		Write logfile, "TASK2 - Coordinate System Movement Test (v1.3.0)";
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
		TPWrite "Saved to: /HOME/task2_coordinate_test.txt";

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
		Open "HOME:/task2_gantry_test.txt", logfile \Append;
		Write logfile, "========================================";
		Write logfile, "TASK2 - Gantry Axis Movement Test (v1.4.0)";
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

		TPWrite "Saved to: task2_gantry_test.txt";
	ENDPROC

	! ========================================
	! Quick Test - Gantry X Axis Movement
	! ========================================
	! Version: v1.4.1
	! Date: 2025-12-23
	! Purpose: Test M1DM3 (Gantry X) +1000mm movement from current position
	PROC TestGantryX()
		TPWrite "TASK2 - Gantry X Axis Test";
		TPWrite "Testing M1DM3 (X axis) +1000mm";
		TestGantryAxisMovement 1000, 0, 0;
		TPWrite "Test complete!";
	ENDPROC

	! ========================================
	! Quick Test - Gantry Y Axis Movement
	! ========================================
	PROC TestGantryY()
		TPWrite "TASK2 - Gantry Y Axis Test";
		TPWrite "Testing M2DM3 (Y axis) +500mm";
		TestGantryAxisMovement 0, 500, 0;
		TPWrite "Test complete!";
	ENDPROC

	! ========================================
	! Quick Test - Gantry Z Axis Movement
	! ========================================
	PROC TestGantryZ()
		TPWrite "TASK2 - Gantry Z Axis Test";
		TPWrite "Testing M3DM3 (Z axis) +200mm";
		TestGantryAxisMovement 0, 0, 200;
		TPWrite "Test complete!";
	ENDPROC

	! ========================================
	! Robot2 TCP Coordinate Test - XYZ Combined with Return
	! ========================================
	! Version: v1.5.0
	! Date: 2025-12-24
	! Purpose: Move Robot2 TCP in [X+50, Y+30, Z+20] from home position and return
	! MODE Selection (from /HOME/config.txt):
	!   MODE=0 (User's coordinate system):
	!     - Base: WobjFloor
	!     - Floor [+50, +30, +20] -> wobj0 [+50, +30, +20], Floor [+50, +30, +20]
	!   MODE=1 (Claude's coordinate system):
	!     - Base: wobj0
	!     - wobj0 [+50, +30, +20] -> Floor [+50, -30, -20]
	! Changes from v1.4.7:
	!   - Added config.txt MODE support
	!   - MODE=0: Use WobjFloor as base coordinate
	!   - MODE=1: Use wobj0 as base coordinate (default behavior)
	PROC TestRobot2_XYZ()
		VAR jointtarget original_pos;
		VAR jointtarget home_pos;
		VAR num config_mode;

		TPWrite "TASK2 - Robot2 Coordinate Test (v1.5.0)";

		! Read config mode
		config_mode := ReadConfigMode();
		TPWrite "Config MODE=" + NumToStr(config_mode, 0);

		! Save original joint position
		original_pos := CJointT();
		TPWrite "Original joint position saved";

		! Create home position (Robot2: [+90,0,0,0,30,0], keep gantry position)
		home_pos := original_pos;
		home_pos.robax.rax_1 := 90;
		home_pos.robax.rax_2 := 0;
		home_pos.robax.rax_3 := 0;
		home_pos.robax.rax_4 := 0;
		home_pos.robax.rax_5 := 30;
		home_pos.robax.rax_6 := 0;

		! Move to home position
		TPWrite "Moving to home position [+90,0,0,0,30,0]...";
		MoveAbsJ home_pos, v100, fine, tool0;
		TPWrite "At home position";

		! Perform coordinate test based on MODE
		IF config_mode = 0 THEN
			! MODE=0: User's coordinate - use WobjFloor as base
			TPWrite "MODE=0: Moving Floor: [+50, +30, +20]";
			TestCoordinateMovement 50, 30, 20, 0;
		ELSE
			! MODE=1: Claude's coordinate - use wobj0 as base
			TPWrite "MODE=1: Moving wobj0: [+50, +30, +20]";
			TestCoordinateMovement 50, 30, 20, 1;
		ENDIF

		! Return to original joint position
		TPWrite "Returning to original position...";
		MoveAbsJ original_pos, v100, fine, tool0;
		TPWrite "Returned to original position";

		TPWrite "Test complete! Check txt file";
	ENDPROC

	! ========================================
	! Update Robot1 Floor Position (local)
	! ========================================
	! Version: v1.5.2
	! Date: 2025-12-25
	! Purpose: Read Robot1 TCP from T_ROB1 without cross-task procedure call
	PROC UpdateRobot1FloorPositionLocal()
		robot1_floor_pos := CRobT(\TaskName:="T_ROB1"\Tool:=tool0\WObj:=WobjFloor);
	ENDPROC

	! ========================================
	! Update Robot2 Floor Position
	! ========================================
	! Version: v1.7.3
	! Date: 2025-12-28
	! Purpose: Update Robot2 TCP position in Floor coordinate system
	! Uses WobjFloor_Rob2 which has no rotation (Robot2 wobj0 already rotated)
	! Used for distance measurement between robots
	PROC UpdateRobot2FloorPosition()
		robot2_floor_pos := CRobT(\Tool:=tool0\WObj:=WobjFloor_Rob2);
	ENDPROC

	! ========================================
	! Calculate Robot Distance
	! ========================================
	! Version: v1.5.1
	! Date: 2025-12-25
	! Purpose: Calculate 3D distance between Robot1 and Robot2 in Floor coordinate
	! Returns: Distance in mm
	FUNC num CalculateRobotDistance()
		VAR num dx;
		VAR num dy;
		VAR num dz;

		dx := robot2_floor_pos.trans.x - robot1_floor_pos.trans.x;
		dy := robot2_floor_pos.trans.y - robot1_floor_pos.trans.y;
		dz := robot2_floor_pos.trans.z - robot1_floor_pos.trans.z;

		RETURN Sqrt(Pow(dx, 2) + Pow(dy, 2) + Pow(dz, 2));
	ENDFUNC

	! ========================================
	! Measure Robot Distance
	! ========================================
	! Version: v1.5.1
	! Date: 2025-12-25
	! Purpose: Measure and log distance between Robot1 and Robot2
	! Output: TP display + /HOME/robot_distance_log.txt
	PROC MeasureRobotDistance()
		VAR num distance;
		VAR iodev logfile;

		TPWrite "========================================";
		TPWrite "Robot Distance Measurement (v1.5.1)";
		TPWrite "========================================";

		! Update both robot positions
		UpdateRobot1FloorPositionLocal;
		UpdateRobot2FloorPosition;

		! Calculate distance
		distance := CalculateRobotDistance();

		! Display on TP
		TPWrite "Robot1 Floor Position:";
		TPWrite "  X = " + NumToStr(robot1_floor_pos.trans.x, 2) + " mm";
		TPWrite "  Y = " + NumToStr(robot1_floor_pos.trans.y, 2) + " mm";
		TPWrite "  Z = " + NumToStr(robot1_floor_pos.trans.z, 2) + " mm";
		TPWrite "";
		TPWrite "Robot2 Floor Position:";
		TPWrite "  X = " + NumToStr(robot2_floor_pos.trans.x, 2) + " mm";
		TPWrite "  Y = " + NumToStr(robot2_floor_pos.trans.y, 2) + " mm";
		TPWrite "  Z = " + NumToStr(robot2_floor_pos.trans.z, 2) + " mm";
		TPWrite "";
		TPWrite "Distance between robots: " + NumToStr(distance, 2) + " mm";
		TPWrite "========================================";

		! Save to log file
		Open "HOME:/robot_distance_log.txt", logfile \Write;

		Write logfile, "========================================";
		Write logfile, "Robot Distance Measurement (v1.5.1)";
		Write logfile, "========================================";
		Write logfile, "Date: " + CDate();
		Write logfile, "Time: " + CTime();
		Write logfile, "";
		Write logfile, "Robot1 Floor Position (tool0):";
		Write logfile, "  X = " + NumToStr(robot1_floor_pos.trans.x, 2) + " mm";
		Write logfile, "  Y = " + NumToStr(robot1_floor_pos.trans.y, 2) + " mm";
		Write logfile, "  Z = " + NumToStr(robot1_floor_pos.trans.z, 2) + " mm";
		Write logfile, "";
		Write logfile, "Robot2 Floor Position (tool0):";
		Write logfile, "  X = " + NumToStr(robot2_floor_pos.trans.x, 2) + " mm";
		Write logfile, "  Y = " + NumToStr(robot2_floor_pos.trans.y, 2) + " mm";
		Write logfile, "  Z = " + NumToStr(robot2_floor_pos.trans.z, 2) + " mm";
		Write logfile, "";
		Write logfile, "Distance: " + NumToStr(distance, 2) + " mm";
		Write logfile, "========================================\0A";

		Close logfile;
		TPWrite "Saved to: /HOME/robot_distance_log.txt";

	ERROR
		TPWrite "ERROR in MeasureRobotDistance: " + NumToStr(ERRNO, 0);
		Close logfile;
		TRYNEXT;
	ENDPROC

	! ========================================
	! Test Robot2 Base Height
	! ========================================
	! Version: v1.7.3
	! Date: 2025-12-28
	! Purpose: Check tool0 TCP height from base at specific joint angles
	! Uses WobjFloor_Rob2 (no rotation, adjusted Y offset)
	! Output: TP display + /HOME/robot2_base_height.txt
	PROC TestRobot2BaseHeight()
		VAR jointtarget test_pos;
		VAR robtarget tcp_wobj0;
		VAR robtarget tcp_floor;
		VAR iodev logfile;

		TPWrite "========================================";
		TPWrite "Robot2 Base Height Test (v1.7.3)";

		! Get current position
		test_pos := CJointT();

		! Set robot joints to [+90, 0, 0, 0, 0, 0]
		test_pos.robax.rax_1 := 90;
		test_pos.robax.rax_2 := 0;
		test_pos.robax.rax_3 := 0;
		test_pos.robax.rax_4 := 0;
		test_pos.robax.rax_5 := 0;
		test_pos.robax.rax_6 := 0;

		! Move to test position
		TPWrite "Moving to test position [+90,0,0,0,0,0]...";
		MoveAbsJ test_pos, v100, fine, tool0;
		WaitTime 0.5;

		! Read TCP position in wobj0
		tcp_wobj0 := CRobT(\Tool:=tool0\WObj:=wobj0);

		! Read TCP position in Floor coordinate (using Robot2-specific Floor)
		tcp_floor := CRobT(\Tool:=tool0\WObj:=WobjFloor_Rob2);

		! Display on TP
		TPWrite "Robot2 wobj0:";
		TPWrite "  X = " + NumToStr(tcp_wobj0.trans.x, 2);
		TPWrite "  Y = " + NumToStr(tcp_wobj0.trans.y, 2);
		TPWrite "  Z = " + NumToStr(tcp_wobj0.trans.z, 2);

		TPWrite "Robot2 Floor (WobjFloor_Rob2):";
		TPWrite "  X = " + NumToStr(tcp_floor.trans.x, 2);
		TPWrite "  Y = " + NumToStr(tcp_floor.trans.y, 2);
		TPWrite "  Z = " + NumToStr(tcp_floor.trans.z, 2);

		TPWrite "========================================";

		! Save to log file
		Open "HOME:/robot2_base_height.txt", logfile \Write;

		Write logfile, "========================================";
		Write logfile, "Robot2 Base Height Test (v1.7.3)";
		Write logfile, "========================================";
		Write logfile, "Date: " + CDate();
		Write logfile, "Time: " + CTime();
		Write logfile, "";
		Write logfile, "Joint Angles: [+90, 0, 0, 0, 0, 0]";
		Write logfile, "";
		Write logfile, "Robot2 wobj0 (tool0):";
		Write logfile, "  X = " + NumToStr(tcp_wobj0.trans.x, 2) + " mm";
		Write logfile, "  Y = " + NumToStr(tcp_wobj0.trans.y, 2) + " mm";
		Write logfile, "  Z = " + NumToStr(tcp_wobj0.trans.z, 2) + " mm";
		Write logfile, "";
		Write logfile, "Robot2 Floor (tool0) - using WobjFloor_Rob2:";
		Write logfile, "  X = " + NumToStr(tcp_floor.trans.x, 2) + " mm";
		Write logfile, "  Y = " + NumToStr(tcp_floor.trans.y, 2) + " mm";
		Write logfile, "  Z = " + NumToStr(tcp_floor.trans.z, 2) + " mm";
		Write logfile, "========================================\0A";

		Close logfile;
		TPWrite "Saved to: /HOME/robot2_base_height.txt";

	ERROR
		TPWrite "ERROR in TestRobot2BaseHeight: " + NumToStr(ERRNO, 0);
		Close logfile;
		TRYNEXT;
	ENDPROC

ENDMODULE
