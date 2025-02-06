package egovframework.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import egovframework.vo.MemberVO;

@Mapper
public interface MemberMapper {
	//PK 구하기
	int selectNextMemberPk();
	//아이디 존재 여부
	boolean isMemberIdExists(String memberId);
	//회원 가입(INSERT)
	void insertMember(MemberVO member);	
	//아이디로 회원 조회 
	MemberVO getMemberByMemberId(String memberId);
	//pk로 회원조회(pk, 이름, 연락처)
	MemberVO selectMemberByPk(int memberPk);
	//일반사용자 이름으로 조회 (관리자 검색)
	List<MemberVO> searchMembersByNameAndLevel(@Param("keyword") String keyword, @Param("level") String level);
	//pk로 사용자조회(기안문작성용, 정보 다 가져옴)
	MemberVO selectMemberWithDetails(int memberPk);
	//결재자 검색
	List<MemberVO> searchApprovers(@Param("department") String department, @Param("rank") String rank, @Param("name") String name, @Param("loginMemberPk") int loginMemberPk);
}
