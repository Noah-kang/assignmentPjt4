package egovframework.controller;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import egovframework.mapper.ScheduleMapper;
import egovframework.service.ExperiencePersonService;
import egovframework.service.MemberService;
import egovframework.service.ProgramService;
import egovframework.service.ReservationService;
import egovframework.service.ScheduleService;
import egovframework.vo.ExperiencePersonVO;
import egovframework.vo.MemberVO;
import egovframework.vo.ProgramVO;
import egovframework.vo.ReservationVO;
import egovframework.vo.ScheduleVO;

@Controller
@RequestMapping("/")
public class ReservationController {

	// 로거 생성
    Logger logger = LoggerFactory.getLogger(this.getClass());
    
    @Autowired
    private ProgramService programService;

    @Autowired
    private ScheduleService scheduleService;
    
    @Autowired
    private ReservationService reservationService;
    
    @Autowired
    private MemberService memberService;
    
    @Autowired
    private ExperiencePersonService experiencePersonService;
    
    @Autowired
    private ScheduleMapper scheduleMapper;

    // 사용자 메인화면
    @GetMapping("/")
    public String userCalendar(
            @RequestParam(value = "programPk", required = false) Integer programPk,
            @RequestParam(value = "date", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date,
            Model model) {
        try {
            // 현재 날짜 설정
            if (date == null) {
                date = LocalDate.now().withDayOfMonth(1); // 현재 달의 첫째 날
            }
            
            // 오늘 날짜 설정
            LocalDate today = LocalDate.now(); 
            logger.info("오늘날짜는? : {}", today);

            // 프로그램 목록 가져오기
            List<ProgramVO> programs = programService.getAllPrograms();
            if (programPk == null && !programs.isEmpty()) {
                programPk = programs.get(0).getProgramPk(); // 첫 번째 프로그램 기본 선택
            }

            // 선택된 프로그램의 예약 일정 가져오기
            List<ScheduleVO> schedules = scheduleService.getSchedulesByProgramAndMonth(programPk, date);

            // 예약자 수 계산
            for (ScheduleVO schedule : schedules) {
                int reservationCount = reservationService.getTotalExperiencePersonCount(schedule.getSchedulePk());
                schedule.setReservationCount(reservationCount); // VO에 예약자 수 추가
                logger.debug("Schedule Date: {}", schedule.getDate());
                logger.debug("Schedule Date Class: {}", schedule.getDate().getClass().getName());
            }
            
            // 날짜 포맷 설정
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM");

            // 모델에 데이터 추가
            model.addAttribute("programs", programs);
            model.addAttribute("selectedProgramPk", programPk);
            model.addAttribute("schedules", schedules);
            model.addAttribute("currentDate", date);
            model.addAttribute("dateFormatter", formatter);
            model.addAttribute("today", today);

            return "reservation/calendar";
        } catch (Exception e) {
            model.addAttribute("errorMessage", "시스템 오류가 발생했습니다. 관리자에게 문의하세요.");
            return "reservation/calendar";
        }
    }
    
    // 예약 생성 화면 겟
    @GetMapping("/reservation")
    public String createReservation(@RequestParam("schedulePk") int schedulePk, @RequestParam("programPk") int programPk, // 프로그램 PK 추가
            @RequestParam("date") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date, // 날짜 추가
            HttpSession session, Model model) {
        ScheduleVO schedule = reservationService.getScheduleByPk(schedulePk);
        
        // 프로그램 이름 가져오기
        String programName = scheduleMapper.selectProgramNameByPk(schedule.getProgramPk());
        schedule.setProgramName(programName);
        
        // 사용자 정보 가져오기 (로그인된 사용자)
        int loginMemberPk = (int) session.getAttribute("loginMemberPk");
        MemberVO member = memberService.getMemberByPk(loginMemberPk);
        
        // 현재 예약자 수 가져오기
        int reservationCount = reservationService.getTotalExperiencePersonCount(schedulePk);
        
        // 예약 가능 인원 = 최대 인원 - 현재 예약자 수
        int availableCapacity = schedule.getMaxCapacity() - reservationCount;
        
        model.addAttribute("schedule", schedule);
        model.addAttribute("member", member); // 사용자 정보 추가
        model.addAttribute("programPk", programPk); // 프로그램 PK 전달
        model.addAttribute("date", date); // 날짜 전달
        model.addAttribute("reservationCount", reservationCount); // 예약자수 넘기기 
        model.addAttribute("availableCapacity", availableCapacity); // 예약 가능 인원
        
        return "reservation/reservation-create";
    }
    
    // 예약 저장
    @PostMapping("/reservation/save")
    public String saveReservation(
            @ModelAttribute ReservationVO reservationVO,
            @RequestParam("schedulePk") int schedulePk,
            HttpServletRequest request,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        try {
            // 예약 PK 채번
            int reservationPk = reservationService.getNextReservationPk();
            reservationVO.setReservationPk(reservationPk);
            reservationVO.setSchedulePk(schedulePk);
            
            // `Schedule`에서 `programPk` 가져오기
            ScheduleVO schedule = reservationService.getScheduleByPk(schedulePk);
            reservationVO.setProgramPk(schedule.getProgramPk());

            // 현재 로그인한 사용자 정보 설정
            int loginMemberPk = (int) session.getAttribute("loginMemberPk");
            reservationVO.setMemberPk(loginMemberPk);

            // 예약 저장
            reservationService.saveReservation(reservationVO);
            
            
            // 체험 인원 저장
            Map<String, String[]> parameterMap = request.getParameterMap();
            int index = 0;

            while (parameterMap.containsKey("participants[" + index + "].name")) {
                ExperiencePersonVO person = new ExperiencePersonVO();
                person.setExperiencePersonPk(reservationService.getNextExperiencePersonPk());
                person.setReservationPk(reservationPk);
                person.setName(parameterMap.get("participants[" + index + "].name")[0]);
                person.setGender(parameterMap.get("participants[" + index + "].gender")[0]);
                person.setTargetType(parameterMap.get("participants[" + index + "].targetType")[0]);
                person.setResidence(parameterMap.get("participants[" + index + "].residence")[0]);
                person.setDetailedAddress(parameterMap.get("participants[" + index + "].detailedAddress")[0]);
                person.setDisabled("true".equals(parameterMap.get("participants[" + index + "].isDisabled")[0]));
                person.setForeigner("true".equals(parameterMap.get("participants[" + index + "].isForeigner")[0]));
                person.setProgramPk(schedule.getProgramPk());

                reservationService.saveExperiencePerson(person);
                index++;
            }

            redirectAttributes.addFlashAttribute("successMessage", "예약이 성공적으로 저장되었습니다.");
            return "redirect:/";
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("errorMessage", "예약 저장 중 오류가 발생했습니다.");
            redirectAttributes.addAttribute("schedulePk", schedulePk);
            return "redirect:/reservation";
        }
    }
    
    // 내 예약내역 확인
    @GetMapping("/reservation/myReservations")
    public String getUserReservations(HttpSession session, Model model, @RequestParam("programPk") int programPk, // 프로그램 PK 추가
            @RequestParam("date") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date // 날짜 추가
            ) {
        try {
            // 현재 로그인한 사용자 가져오기
            int memberPk = (int) session.getAttribute("loginMemberPk");

            // 사용자의 예약 정보 조회
            List<ReservationVO> reservations = reservationService.getReservationsByMemberPk(memberPk);
            
            // 현재 시간 전달
            LocalDate now = LocalDate.now();
            model.addAttribute("reservations", reservations);
            model.addAttribute("currentTime", now);
            
            model.addAttribute("programPk", programPk); // 프로그램 PK 전달
            model.addAttribute("date", date); // 날짜 전달

            return "reservation/my-reservations"; // JSP 파일 경로
        } catch (Exception e) {
            model.addAttribute("errorMessage", "예약 정보를 불러오는 중 문제가 발생했습니다.");
            return "error"; // 오류 페이지
        }
    }
    
    // 내 예약내역 확인에서 체험인원 조회
    @GetMapping("/reservation/experiencePersonsPopup")
    public String getExperiencePersonsPopup(@RequestParam("reservationPk") int reservationPk, Model model) {
        try {
            // 예약에 해당하는 체험인원 목록 가져오기
            List<ExperiencePersonVO> experiencePersons = experiencePersonService.getExperiencePersonsByReservationPk(reservationPk);

            model.addAttribute("experiencePersons", experiencePersons);
            return "admin/experience-person-list"; // JSP 템플릿 경로
        } catch (Exception e) {
            model.addAttribute("errorMessage", "체험인원 정보를 불러오는 중 문제가 발생했습니다.");
            return "error"; // 오류 페이지
        }
    }
    
    // 내 예약내역 확인에서 예약취소(체험인원 -> 예약내역 삭제)
    @DeleteMapping("/reservation/cancel/{reservationPk}")
    @ResponseBody
    public ResponseEntity<String> cancelReservation(@PathVariable("reservationPk") int reservationPk) {
        try {
        	// 관리자에서 사용했던 체험인원 삭제 후 예약내역 삭제 재활용
        	reservationService.deleteReservationWithPersons(reservationPk);

            return ResponseEntity.ok("예약이 취소되었습니다.");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("예약 취소 중 오류가 발생했습니다.");
        }
    }

}
