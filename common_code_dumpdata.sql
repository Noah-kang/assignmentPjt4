INSERT INTO public.common_code (code_group,code_value,code_name,description) VALUES
	 ('MEMBER_LEVEL','A','관리자','관리자 권한'),
	 ('MEMBER_LEVEL','N','일반 사용자','일반 사용자 권한'),
	 ('RANK','01','인턴','인턴 직급'),
	 ('RANK','02','사원','사원 직급'),
	 ('RANK','03','대리','대리 직급'),
	 ('RANK','04','과장','과장 직급'),
	 ('RANK','05','차장','차장 직급'),
	 ('RANK','06','부장','부장 직급'),
	 ('DEPARTMENT','HR','인사총무팀','인사팀'),
	 ('DEPARTMENT','IT','개발사업본부','개발팀');
INSERT INTO public.common_code (code_group,code_value,code_name,description) VALUES
	 ('RESERVATION_TYPE','P','개인','개인 예약'),
	 ('RESERVATION_TYPE','G','단체','단체 예약'),
	 ('TARGET_TYPE','K','미취학','미취학 아동 대상'),
	 ('TARGET_TYPE','E','초등','초등학생 대상'),
	 ('APPROVAL_STATUS','P','결재중','기안문이 결재 라인에 전달되어 결재가 진행 중인 상태'),
	 ('APPROVAL_STATUS','C','결재 완료','모든 결재 라인이 승인되었음을 의미'),
	 ('LINE_STATUS','I','결재중','해당 결재 라인이 현재 결재를 진행 중임을 의미'),
	 ('LINE_STATUS','W','결재대기','해당 결재 라인이 결재를 기다리는 상태'),
	 ('LINE_STATUS','A','승인','해당 결재 라인이 승인된 상태'),
	 ('APPROVAL_STATUS','R','반려','기안문이 반려되었음');
INSERT INTO public.common_code (code_group,code_value,code_name,description) VALUES
	 ('LINE_STATUS','R','반려','이 결재라인에서 반려됨');
