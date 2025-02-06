package egovframework.config;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;

public class AuthInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession();
        String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();

        // 로그인 여부 확인
        String memberId = (String) session.getAttribute("loginMemberId");
        String memberLevel = (String) session.getAttribute("loginMemberLevel");

        // /admin 경로는 관리자만 접근 가능
        if (requestURI.startsWith(contextPath + "/admin")) {
            if (memberId == null || !"A".equals(memberLevel)) {
                response.sendRedirect(request.getContextPath() + "/");
                return false;
            }
        }

        // / 경로에서 특정 요청에 대해 로그인 필요 확인
        //	if (requestURI.startsWith(contextPath + "/reservation") || requestURI.startsWith(contextPath + "/submit")) {
        if (requestURI.startsWith(contextPath + "/reservation")) {
            if (memberId == null) {
                response.sendRedirect(request.getContextPath() + "/member/login");
                return false;
            }
        }

        return true;
    }
}
