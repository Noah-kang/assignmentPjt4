package egovframework.controller;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.config.SessionListener;
import egovframework.service.MemberService;
import egovframework.vo.MemberVO;

@Controller
@RequestMapping("/member")
public class MemberController {
	// 로거 생성
    Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Autowired
	private MemberService memberService;
	
	// 회원가입 폼
	@GetMapping("/register")
	public String registerForm() {
		return "member/register";
	}
	
	// 회원가입 처리
	@PostMapping("/register")
	public String register(@ModelAttribute MemberVO member, Model model) {
		try {
			memberService.registerMember(member);
			return "redirect:/member/login";
		} catch (IllegalArgumentException e) {
			model.addAttribute("errorMessage", e.getMessage());
			return "member/register";
		}
	}
	
	// 로그인 폼 
	@GetMapping("/login")
	public String loginForm() {
		return "member/login";
	}
	
	// 로그인 처리
	@PostMapping("/login")
	public String login(@RequestParam String memberId,
						@RequestParam String password,
						HttpSession session,
						Model model) {
		
		logger.info("로그인 시도: memberId={}", memberId);
		
		//로그인 시도
		MemberVO member = memberService.login(memberId, password);
		if (member == null) {
			// 로그인 실패
			logger.warn("로그인 실패: 아이디 또는 비밀번호가 잘못되었습니다. memberId={}", memberId);
			model.addAttribute("error", "아이디 또는 비밀번호가 잘못되었습니다.");
			return "member/login";
		}
		
		// 중복 로그인 방지: SessionListener에 저장된 세션이 있으면 먼저 무효화
		HttpSession oldSession = SessionListener.getSession(memberId);
		if(oldSession != null && oldSession != session) {
			logger.info("중복 로그인 감지: 기존 세션 무효화 처리. memberId={}", memberId);
			oldSession.invalidate(); // 기존 세션 만료
		}
		
		// 새 세션을 맵에등록
		SessionListener.addSession(memberId, session);
		logger.info("세션 등록 완료: memberId={}, sessionId={}", memberId, session.getId());
		
		// 세션에 로그인 정보 저장
		session.setAttribute("loginMemberId", member.getMemberId());
		session.setAttribute("loginMemberPk", member.getMemberPk());
		session.setAttribute("loginMemberLevel", member.getMemberLevel());
		
		logger.info("로그인 성공: memberId={}, memberLevel={}", member.getMemberId(), member.getMemberLevel());
		
		// 로그인 성공 후 이동 경로 결정
	    if ("A".equals(member.getMemberLevel())) {
	        logger.info("관리자 로그인 성공: memberId={}", member.getMemberId());
	        return "redirect:/admin/calendar"; // 관리자 페이지로 이동
	    } else {
	        logger.info("일반 사용자 로그인 성공: memberId={}", member.getMemberId());
	        return "redirect:/"; // 일반 사용자 메인 페이지로 이동
	    }
	}
	
	// 로그아웃 (POST)
	@PostMapping("/logout")
	public String logout(HttpSession session) {
		// 현재 세션에서 memberId 가져오기
		String memberId = (String) session.getAttribute("loginMemberId");
		if (memberId != null) {
			// SessionListener에서도 제거
			SessionListener.removeSession(memberId);
		}
		
		//세션 무효화
		session.invalidate();
		
		return "redirect:/";
	}
	
	// 아이디 중복 확인 (AJAX)
	@GetMapping("/checkId")
	@ResponseBody
	public boolean checkId(@RequestParam("memberId") String memberId) {
		return memberService.isMemberIdExists(memberId);
	}
}
