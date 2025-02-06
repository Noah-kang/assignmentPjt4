package egovframework.config;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

public class SessionListener implements HttpSessionListener {
    
    // 동시성 안전한 맵: memberId -> HttpSession
    private static final Map<String, HttpSession> loginSessions = new ConcurrentHashMap<>();

    public static HttpSession getSession(String memberId) {
        return loginSessions.get(memberId);
    }

    public static void addSession(String memberId, HttpSession session) {
        loginSessions.put(memberId, session);
    }
    
    public static void removeSession(String memberId) {
        loginSessions.remove(memberId);
    }

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        // 여기서는 특별히 할 것 없음
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        // 세션이 만료/종료되면 해당 userId를 찾아서 제거해줄 수도 있지만,
        // 세션에 "memberId"를 저장해두지 않았다면 찾기 어려울 수도 있음.
        // 여기서는 생략하거나 필요 시 로직 구현
    }
}
