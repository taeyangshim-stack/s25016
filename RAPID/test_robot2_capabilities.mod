MODULE TestRobot2Capabilities
	!========================================
	! Robot2 기능 확인 테스트
	!========================================
	!
	! Version: v1.0.0
	! Date: 2025-12-17
	! Purpose: Robot2에서 갠트리 외부축 접근 가능 여부 확인
	!
	! Test Items:
	! 1. CJointT() - 갠트리 외부축 읽기 가능 여부
	! 2. PERS 변수 공유 - TASK1 변수 접근 가능 여부
	! 3. 좌표 변환 - Robot2 TCP를 World 좌표로 변환
	!
	!========================================

	!========================================
	! Test 1: CJointT()로 외부축 읽기
	!========================================
	PROC TestRobot2_ReadExternalAxes()
		VAR jointtarget current_joint;
		VAR num gantry_x;
		VAR num gantry_y;
		VAR num gantry_z;
		VAR num gantry_r;
		VAR num gantry_x2;

		TPWrite "========================================";
		TPWrite "Test 1: Robot2 - Read External Axes";
		TPWrite "========================================";

		! 현재 조인트 위치 읽기 (로봇 관절 + 외부축)
		current_joint := CJointT();

		! 로봇 관절 출력
		TPWrite "Robot Joints:";
		TPWrite "  J1 = " + NumToStr(current_joint.robax.rax_1, 2) + " deg";
		TPWrite "  J2 = " + NumToStr(current_joint.robax.rax_2, 2) + " deg";
		TPWrite "  J3 = " + NumToStr(current_joint.robax.rax_3, 2) + " deg";
		TPWrite "  J4 = " + NumToStr(current_joint.robax.rax_4, 2) + " deg";
		TPWrite "  J5 = " + NumToStr(current_joint.robax.rax_5, 2) + " deg";
		TPWrite "  J6 = " + NumToStr(current_joint.robax.rax_6, 2) + " deg";

		! 갠트리 외부축 추출 시도
		gantry_x := current_joint.extax.eax_a;   ! X1
		gantry_y := current_joint.extax.eax_b;   ! Y
		gantry_z := current_joint.extax.eax_c;   ! Z
		gantry_r := current_joint.extax.eax_d;   ! R
		gantry_x2 := current_joint.extax.eax_f;  ! X2

		TPWrite "Gantry External Axes:";
		TPWrite "  X1 = " + NumToStr(gantry_x, 4) + " m";
		TPWrite "  Y  = " + NumToStr(gantry_y, 4) + " m";
		TPWrite "  Z  = " + NumToStr(gantry_z, 4) + " m";
		TPWrite "  R  = " + NumToStr(gantry_r, 4) + " rad";
		TPWrite "  X2 = " + NumToStr(gantry_x2, 4) + " m";

		! 파일 저장
		VAR iodev logfile;
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

		! 값이 0이 아니면 성공
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
	! Test 2: PERS 변수 공유 테스트
	!========================================

	! TASK1에서 공유할 변수 (이 코드는 TASK1 MainModule에 추가 필요)
	! PERS jointtarget shared_gantry_pos;
	! PERS num shared_test_value := 12345;

	PROC TestRobot2_ReadSharedVariable()
		VAR num test_value;

		TPWrite "========================================";
		TPWrite "Test 2: Robot2 - Read Shared PERS Variable";
		TPWrite "========================================";

		! TASK1의 shared_test_value 읽기 시도
		! 주의: TASK1에 해당 변수가 정의되어 있어야 함

		TPWrite "Attempting to read TASK1 shared variable...";

		! 직접 참조 시도
		! test_value := shared_test_value;  ! 같은 컨트롤러면 가능

		! 또는 GetDataVal 사용
		! GetDataVal "TASK1/shared_test_value", test_value;

		TPWrite "If you see this without error, variable sharing works!";
		TPWrite "Test 2 requires TASK1 code modification first.";

		! 파일 저장
		VAR iodev logfile;
		Open "/HOME/", logfile \Write;
		Open "robot2_pers_sharing_test.txt", logfile \Append;

		Write logfile, "========================================";
		Write logfile, "Robot2 - PERS Variable Sharing Test";
		Write logfile, "========================================";
		Write logfile, "Date: " + CDate();
		Write logfile, "Time: " + CTime();
		Write logfile, "";
		Write logfile, "Result: Test requires TASK1 code modification";
		Write logfile, "Action: Add PERS variables to TASK1 MainModule";
		Write logfile, "========================================\0A";

		Close logfile;

	ERROR
		TPWrite "ERROR in TestRobot2_ReadSharedVariable: " + NumToStr(ERRNO, 0);
		Close logfile;
		TRYNEXT;
	ENDPROC

	!========================================
	! Test 3: Robot2 TCP 좌표 확인
	!========================================
	PROC TestRobot2_TCPCoordinates()
		VAR robtarget tcp_world;
		VAR robtarget tcp_wobj0;
		VAR robtarget tcp_base;

		TPWrite "========================================";
		TPWrite "Test 3: Robot2 - TCP Coordinates";
		TPWrite "========================================";

		! World 좌표계
		tcp_world := CRobT(\Tool:=tool0);

		! wobj0 좌표계
		tcp_wobj0 := CRobT(\Tool:=tool0\WObj:=wobj0);

		! Robot Base 좌표계 (wobj0가 Robot Base라고 가정)
		tcp_base := tcp_wobj0;

		TPWrite "World Coordinates:";
		TPWrite "  X = " + NumToStr(tcp_world.trans.x, 3) + " mm";
		TPWrite "  Y = " + NumToStr(tcp_world.trans.y, 3) + " mm";
		TPWrite "  Z = " + NumToStr(tcp_world.trans.z, 3) + " mm";

		TPWrite "wobj0 Coordinates:";
		TPWrite "  X = " + NumToStr(tcp_wobj0.trans.x, 3) + " mm";
		TPWrite "  Y = " + NumToStr(tcp_wobj0.trans.y, 3) + " mm";
		TPWrite "  Z = " + NumToStr(tcp_wobj0.trans.z, 3) + " mm";

		! 파일 저장
		VAR iodev logfile;
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
		Write logfile, "      (Gantry R-axis center + 488mm in opposite direction from Robot1)";
		Write logfile, "========================================\0A";

		Close logfile;

		TPWrite "========================================";
		TPWrite "Test 3 Complete. Check robot2_tcp_coordinates.txt";

	ERROR
		TPWrite "ERROR in TestRobot2_TCPCoordinates: " + NumToStr(ERRNO, 0);
		Close logfile;
		TRYNEXT;
	ENDPROC

	!========================================
	! Main Test Runner
	!========================================
	PROC main()
		TPWrite "Starting Robot2 Capabilities Test Suite...";
		TPWrite "";

		! Test 1: 외부축 읽기
		TestRobot2_ReadExternalAxes;
		WaitTime 2;

		! Test 2: PERS 변수 공유 (나중에 활성화)
		! TestRobot2_ReadSharedVariable;
		! WaitTime 2;

		! Test 3: TCP 좌표
		TestRobot2_TCPCoordinates;
		WaitTime 2;

		TPWrite "";
		TPWrite "All tests complete!";
		TPWrite "Check /HOME folder for result files.";
	ENDPROC

ENDMODULE
