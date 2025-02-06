package egovframework.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.mapper.MemberMapper;
import egovframework.service.MemberService;
import egovframework.vo.MemberVO;

@Service
public class MemberServiceImpl implements MemberService{
	
	@Autowired
	private MemberMapper memberMapper;

    @Transactional
    @Override
    public void registerMember(MemberVO member) {
    	if(memberMapper.isMemberIdExists(member.getMemberId())) {
    		throw new IllegalArgumentException("이미 사용 중인 아이디입니다.");
    	}
    	//pk 가져오기
    	int nextVal = memberMapper.selectNextMemberPk();
    	
    	// vo에 세팅
    	member.setMemberPk(nextVal);
        // 평문 비번 그대로 저장
        memberMapper.insertMember(member);
    }
    
    @Override
    public boolean isMemberIdExists(String memberId) {
    	return memberMapper.isMemberIdExists(memberId);
    }
    
    @Override
    public MemberVO login(String memberId, String rawPassword) {
    	MemberVO member = memberMapper.getMemberByMemberId(memberId);
    	if(member != null) {
    		if(member.getPassword().equals(rawPassword)) {
    			return member;
    		}
    	}
    	return null; // 로그인 실패
    }
    
    // pk로 사용자 정보 가져오기(pk, 이름, 연락처)
    @Override
    public MemberVO getMemberByPk(int memberPk) {
        return memberMapper.selectMemberByPk(memberPk);
    }
    
    // 사용자 이름으로 검색 (관리자페이지 예약내역 생성)
    @Override
    public List<MemberVO> searchMembersByNameAndLevel(String keyword, String level) {
        return memberMapper.searchMembersByNameAndLevel(keyword, level);
    }
    
    // pk로 사용자 정보 가져오기(기안문 작성용, 사용자 정보 다 가져옴)
    @Override
    public MemberVO getMemberWithDetails(int memberPk) {
        return memberMapper.selectMemberWithDetails(memberPk);
    }
    
    // 결재자 검색 가져오기
    @Override
    public List<MemberVO> searchApprovers(String department, String rank, String name, int loginMemberPk) {
        return memberMapper.searchApprovers(department, rank, name, loginMemberPk);
    }
}
