MODULE ConfigModule
! ========================================
! S25016 SpGantry Configuration Module
! ========================================
! Version: v1.9.1
! Date: 2026-01-17
! Purpose: Centralized configuration using PERS variables
! v1.9.0: Added weld sequence configuration
! v1.9.1: Fixed R-axis (X+=0°), added WObj positions, 45° torch
! ========================================

! ========================================
! Mode2 Test Configuration
! ========================================
! TCP Offsets for Robot1 (mm)
! Robot1: WobjGantry Y=-100, Floor Y effect = +100*cos(R) (above gantry center)
! v1.8.57: Changed from +100 to -100 to reverse direction
PERS num MODE2_TCP_OFFSET_R1_X := 0;
PERS num MODE2_TCP_OFFSET_R1_Y := -100;
PERS num MODE2_TCP_OFFSET_R1_Z := 0;

! TCP Offsets for Robot2 (mm)
! Robot2: WobjGantry_Rob2 Y = 488 + (-100) = 388, Floor Y effect = -100*cos(R) (below gantry center)
! Y distance = 200*cos(R), Robot2 below, Robot1 above
! v1.8.57: Changed from +100 to -100 to reverse direction
PERS num MODE2_TCP_OFFSET_R2_X := 0;
PERS num MODE2_TCP_OFFSET_R2_Y := -100;
PERS num MODE2_TCP_OFFSET_R2_Z := 0;

! Complex Motion Test Positions
! v1.8.77: 10 random positions with various angles for comprehensive testing
PERS num MODE2_NUM_POS := 10;

! Position arrays (COMPLEX_POS format: offset from HOME)
! Floor coordinates = HOME + offset
! HOME = [9500, 5300, 2100, 0]
! offset_X = floor_X - 9500, offset_Y = floor_Y - 5300, offset_Z = floor_Z - 2100
!
! Gantry limits (Physical):
!   X: [-9510, 12310] mm, Y: [-50, 5350] mm, Z: [-50, 1050] mm, R: [-100, 100]°
!
! Test positions (Floor coords):
!   1. [5000, 5000, 2100] R=0°   - Center, no rotation
!   2. [5000, 5000, 2100] R=45°  - Center, 45° CCW
!   3. [5000, 5000, 2100] R=-45° - Center, 45° CW
!   4. [5000, 5000, 2100] R=90°  - Center, 90° CCW
!   5. [5000, 5000, 2100] R=-90° - Center, 90° CW
!   6. [3000, 4000, 2000] R=30°  - Different XYZ, 30° CCW
!   7. [7000, 5200, 2100] R=-30° - Different XYZ, 30° CW
!   8. [2000, 3500, 1800] R=60°  - Low Z, 60° CCW
!   9. [8000, 4500, 2050] R=-60° - Different XYZ, 60° CW
!  10. [4500, 5000, 1900] R=15°  - Small angle test
PERS num MODE2_POS_X{10} := [-4500, -4500, -4500, -4500, -4500, -6500, -2500, -7500, -1500, -5000];
PERS num MODE2_POS_Y{10} := [-300, -300, -300, -300, -300, -1300, -100, -1800, -800, -300];
PERS num MODE2_POS_Z{10} := [0, 0, 0, 0, 0, -100, 0, -300, -50, -200];
PERS num MODE2_POS_R{10} := [0, 45, -45, 90, -90, 30, -30, 60, -60, 15];

! ========================================
! Weld Sequence Configuration (v1.9.0)
! ========================================
! Robot TCP Offset from R-center (mm)
! Distance from gantry R-center to tWeld TCP when robot points down
! Used to calculate gantry Z from Floor weld Z
! Gantry_Z = 2100 - Floor_Z - TCP_OFFSET
PERS num WELD_R1_TCP_Z_OFFSET := 1600;  ! Robot1 tWeld1: +Z direction from R-center
PERS num WELD_R2_TCP_Z_OFFSET := 1600;  ! Robot2 tWeld2: -Z direction from R-center

! Robot1 Weld Line (Floor TCP coordinates, mm)
! Floor Z = (2100 - Gantry_Z) - TCP_OFFSET
! Example: Gantry_Z=0, TCP_OFFSET=1600, Floor_Z = 2100 - 0 - 1600 = 500
PERS num WELD_R1_START_X := 5000;
PERS num WELD_R1_START_Y := 5100;
PERS num WELD_R1_START_Z := 500;
PERS num WELD_R1_END_X := 5500;
PERS num WELD_R1_END_Y := 5100;
PERS num WELD_R1_END_Z := 500;

! Robot2 Weld Line (Floor TCP coordinates, mm)
! Robot2 on opposite side of R-center
PERS num WELD_R2_START_X := 5000;
PERS num WELD_R2_START_Y := 4900;
PERS num WELD_R2_START_Z := 500;
PERS num WELD_R2_END_X := 5500;
PERS num WELD_R2_END_Y := 4900;
PERS num WELD_R2_END_Z := 500;

! Robot Weld Position in WObj (mm)
! These are the TCP positions relative to WObj origin (weld start point)
! WObj: X=weld direction, Y=perpendicular, Z=Floor Z (down)
! Robot1: Y=-12 (above center), Z=1600 (below Floor by TCP offset)
! Robot2: Y=476 (488-12, below center + robot base offset), Z=-1600 (above Floor)
PERS num WELD_R1_WObj_X := 0;
PERS num WELD_R1_WObj_Y := -12;
PERS num WELD_R1_WObj_Z := 1600;

PERS num WELD_R2_WObj_X := 0;
PERS num WELD_R2_WObj_Y := 476;   ! 488 - 12 = 476
PERS num WELD_R2_WObj_Z := -1600;

! Robot1 Weld Orientation (quaternion: q1, q2, q3, q4)
! 45° torch angle: rotated around weld line (X-axis)
! Rotation Rx +45°: [cos(22.5°), sin(22.5°), 0, 0]
! Torch tilts perpendicular to weld direction
PERS num WELD_R1_ORIENT_Q1 := 0.9239;
PERS num WELD_R1_ORIENT_Q2 := 0.3827;
PERS num WELD_R1_ORIENT_Q3 := 0;
PERS num WELD_R1_ORIENT_Q4 := 0;

! Robot2 Weld Orientation (quaternion: q1, q2, q3, q4)
! 45° torch angle: rotated around weld line (X-axis)
! Rotation Rx -45°: [cos(-22.5°), sin(-22.5°), 0, 0]
! Robot2 tilts opposite direction from Robot1
PERS num WELD_R2_ORIENT_Q1 := 0.9239;
PERS num WELD_R2_ORIENT_Q2 := -0.3827;
PERS num WELD_R2_ORIENT_Q3 := 0;
PERS num WELD_R2_ORIENT_Q4 := 0;

! Weld Speed (mm/s)
PERS num WELD_SPEED := 100;

! ========================================
! Configuration Notes
! ========================================
! To modify test positions:
! 1. Open Program Data in RobotStudio
! 2. Find ConfigModule
! 3. Edit MODE2_POS_X, MODE2_POS_Y, MODE2_POS_Z, MODE2_POS_R
! 4. Change MODE2_NUM_POS to number of positions to test
! 5. Run program - changes take effect immediately!
!
! Example:
! MODE2_NUM_POS := 5  (test 5 positions)
! MODE2_POS_X{4} := 3000  (set position 4 X offset)
! MODE2_TCP_OFFSET_R1_Y := 150  (change Robot1 Y offset to 150mm)
!
! To configure weld sequence (v1.9.0):
! 1. Set WELD_R1_START_X/Y/Z and WELD_R1_END_X/Y/Z for Robot1 weld line
! 2. Set WELD_R2_START_X/Y/Z and WELD_R2_END_X/Y/Z for Robot2 weld line
! 3. Set WELD_R1_ORIENT_Q1~Q4 for Robot1 weld posture (quaternion)
! 4. Set WELD_R2_ORIENT_Q1~Q4 for Robot2 weld posture (quaternion)
! 5. Set WELD_SPEED for gantry travel speed during welding
! 6. Run ExecuteWeldSequence() to start welding

ENDMODULE
