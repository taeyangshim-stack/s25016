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
! TCP Offsets for Robot1 (mm, Floor-aligned)
PERS num MODE2_TCP_OFFSET_R1_X := 0;
PERS num MODE2_TCP_OFFSET_R1_Y := 100;
PERS num MODE2_TCP_OFFSET_R1_Z := 0;

! TCP Offsets for Robot2 (mm, Floor-aligned, shared with TASK2)
PERS num MODE2_TCP_OFFSET_R2_X := 0;
PERS num MODE2_TCP_OFFSET_R2_Y := -100;
PERS num MODE2_TCP_OFFSET_R2_Z := 0;

! Complex Motion Test Positions
PERS num MODE2_NUM_POS := 3;

! Position arrays (COMPLEX_POS format: offset from HOME)
! Floor coordinates = HOME + offset
! HOME = [9500, 5300, 2100, 0]
PERS num MODE2_POS_X{10} := [1200, 2600, -1500, 0, 0, 0, 0, 0, 0, 0];
PERS num MODE2_POS_Y{10} := [-400, -900, -600, 0, 0, 0, 0, 0, 0, 0];
PERS num MODE2_POS_Z{10} := [-500, -700, -300, 0, 0, 0, 0, 0, 0, 0];
PERS num MODE2_POS_R{10} := [30, -45, 60, 0, 0, 0, 0, 0, 0, 0];

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
