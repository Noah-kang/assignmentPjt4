package egovframework.service;

import java.util.List;

import egovframework.vo.MemberVO;

public interface MemberService {
	// 회원가입
	void registerMember(MemberVO member);
	// 로그인
	MemberVO login(String memberId, String rawPassword);
	// 아이디 중복확인
	boolean isMemberIdExists(String memberId);
	// Pk로 멤버 가져오기
	MemberVO getMemberByPk(int memberPk);
	// 일반사용자 이름으로 검색(관리자 예약내역 생성)
	List<MemberVO> searchMembersByNameAndLevel(String keyword, String level);
	// Pk로 멤버 정보 가져오기(기안문 생성 직급 부서 용)
	MemberVO getMemberWithDetails(int memberPk);
	// 결재자 검색
	List<MemberVO> searchApprovers(String department, String rank, String name, int loginMemberPk);
}
