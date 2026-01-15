MODULE ConfigModule
! ========================================
! S25016 SpGantry Configuration Module
! ========================================
! Version: v1.8.51
! Date: 2026-01-09
! Purpose: Centralized configuration using PERS variables
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

ENDMODULE
