MODULE Task1SharedVariables
	!========================================
	! TASK1 - 공유 변수 정의
	!========================================
	!
	! Version: v1.0.0
	! Date: 2025-12-17
	! Purpose: TASK2와 갠트리 위치 정보 공유
	!
	! 사용법:
	! 1. TASK1 MainModule에 이 모듈 로드
	! 2. UpdateSharedGantryPosition() 주기적 호출
	! 3. TASK2에서 shared_gantry_pos 읽기
	!
	!========================================

	!========================================
	! 공유 변수 선언 (TASK2에서도 동일하게 선언)
	!========================================

	! 갠트리 현재 위치 (조인트 타겟)
	TASK PERS jointtarget shared_gantry_pos;

	! 갠트리 외부축 (분해된 형태)
	TASK PERS num shared_gantry_x := 0;   ! X1 축
	TASK PERS num shared_gantry_y := 0;   ! Y 축
	TASK PERS num shared_gantry_z := 0;   ! Z 축
	TASK PERS num shared_gantry_r := 0;   ! R 축
	TASK PERS num shared_gantry_x2 := 0;  ! X2 축 (X1과 동기)

	! 갠트리 위치 업데이트 타임스탬프
	TASK PERS num shared_update_counter := 0;

	! 테스트용 변수
	TASK PERS num shared_test_value := 12345;

	!========================================
	! 갠트리 위치 업데이트 (TASK1에서 호출)
	!========================================
	PROC UpdateSharedGantryPosition()
		VAR jointtarget current_pos;

		! 현재 갠트리 + 로봇 조인트 위치
		current_pos := CJointT();

		! 공유 변수 업데이트
		shared_gantry_pos := current_pos;

		! 외부축 분해
		shared_gantry_x := current_pos.extax.eax_a;   ! X1
		shared_gantry_y := current_pos.extax.eax_b;   ! Y
		shared_gantry_z := current_pos.extax.eax_c;   ! Z
		shared_gantry_r := current_pos.extax.eax_d;   ! R
		shared_gantry_x2 := current_pos.extax.eax_f;  ! X2

		! 업데이트 카운터 증가
		shared_update_counter := shared_update_counter + 1;

	ERROR
		TPWrite "ERROR in UpdateSharedGantryPosition: " + NumToStr(ERRNO, 0);
	ENDPROC

	!========================================
	! 주기적 업데이트 (백그라운드 태스크용)
	!========================================
	PROC ContinuousUpdateGantryPosition()
		TPWrite "Starting continuous gantry position update...";

		WHILE TRUE DO
			UpdateSharedGantryPosition();
			WaitTime 0.1;  ! 100ms 주기
		ENDWHILE

	ERROR
		TPWrite "ERROR in ContinuousUpdateGantryPosition: " + NumToStr(ERRNO, 0);
	ENDPROC

	!========================================
	! 테스트: 갠트리 위치 출력
	!========================================
	PROC TestPrintSharedGantryPosition()
		TPWrite "========================================";
		TPWrite "TASK1 - Shared Gantry Position";
		TPWrite "========================================";

		UpdateSharedGantryPosition();

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

ENDMODULE
