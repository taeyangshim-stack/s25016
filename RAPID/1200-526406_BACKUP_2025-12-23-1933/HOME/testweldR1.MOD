
MODULE testweldR1
	CONST robtarget p10:=[[415.45,-121.57,1507.81],[0.939165,0.0108297,0.341914,-0.0307528],[-1,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
	CONST robtarget p20:=[[415.53,-121.57,1555.10],[0.939151,0.0108177,0.34196,-0.0306933],[-1,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
	CONST robtarget p30:=[[415.54,111.46,1555.09],[0.939147,0.0107909,0.341972,-0.0306739],[0,-1,-1,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
	CONST robtarget p40:=[[415.54,111.49,1518.34],[0.93915,0.0107545,0.341968,-0.0306422],[0,-1,-1,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
	CONST robtarget p50:=[[415.41,-121.54,1507.86],[0.939178,0.010814,0.341878,-0.0307643],[-1,0,0,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
	PROC rWeldTestR1_01()
		MoveL p10, vTargetSpeed, zTargetZone, tWeld1\WObj:=wobj0;
		ArcLStart p20, vTargetSpeed, smDefault_1, wd1\Weave:=weave1, fine, tWeld1\WObj:=wobj0;
		ArcLEnd p30, vTargetSpeed, smDefault_1, wd2\Weave:=weave2, fine, tWeld1\WObj:=wobj0;
		MoveL p40, vTargetSpeed, zTargetZone, tWeld1\WObj:=wobj0;
		Stop;
	ENDPROC

ENDMODULE