package egovframework.controller;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import egovframework.mapper.ScheduleMapper;
import egovframework.service.CommonCodeService;
import egovframework.service.DraftDocumentService;
import egovframework.service.ExperiencePersonService;
import egovframework.service.FileStorageService;
import egovframework.service.MemberService;
import egovframework.service.ProgramService;
import egovframework.service.ReservationService;
import egovframework.service.ScheduleService;
import egovframework.vo.ApprovalLineVO;
import egovframework.vo.CommonCodeVO;
import egovframework.vo.DraftDocumentVO;
import egovframework.vo.DraftFileVO;
import egovframework.vo.ExperiencePersonVO;
import egovframework.vo.MemberVO;
import egovframework.vo.ProgramVO;
import egovframework.vo.ReservationVO;
import egovframework.vo.ScheduleBulkVO;
import egovframework.vo.ScheduleVO;

@Controller
@RequestMapping("/admin")
public class AdminController {

	// 로거 생성
    Logger logger = LoggerFactory.getLogger(this.getClass());
	
    @Autowired
    private ProgramService programService;

    @Autowired
    private ScheduleService scheduleService;
    
    @Autowired
    private ReservationService reservationService;
    
    @Autowired
    private ExperiencePersonService experiencePersonService;
    
    @Autowired
    private MemberService memberService;
    
    @Autowired
    private CommonCodeService commonCodeService;
    
    @Autowired
    private DraftDocumentService draftDocumentService;
    
    @Autowired
    private FileStorageService fileStorageService;
    
    @Autowired
    private ScheduleMapper scheduleMapper;

    // 관리자 메인 페이지 (달력)
    @GetMapping("/calendar")
    public String calendar(
            @RequestParam(value = "programPk", required = false) Integer programPk,
            @RequestParam(value = "date", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date,
            Model model) {
        try {
            logger.info("관리자 메인 페이지 접근: programPk={}, date={}", programPk, date);

            // 기본 날짜 설정 (현재 월 1일)
            if (date == null) {
                date = LocalDate.now().withDayOfMonth(1);
            }
            
            // 오늘 날짜 설정
            LocalDate today = LocalDate.now(); 
            logger.info("오늘날짜는? : {}", today);

            // 프로그램 목록 가져오기
            List<ProgramVO> programs = programService.getAllPrograms();
            if (programPk == null && !programs.isEmpty()) {
                programPk = programs.get(0).getProgramPk(); // 첫 번째 프로그램 기본 선택
            }

            // 선택된 프로그램의 예약 일정 가져오기 (선택된 월 기준)
            List<ScheduleVO> schedules = scheduleService.getSchedulesByProgramAndMonth(programPk, date);

            // 예약자 수 계산
            for (ScheduleVO schedule : schedules) {
                int reservationCount = reservationService.getTotalExperiencePersonCount(schedule.getSchedulePk());
                schedule.setReservationCount(reservationCount); // VO에 예약자 수 추가
                logger.debug("Schedule Date: {}", schedule.getDate());
            }
            
            // 날짜 포맷터 생성
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM");
            
            // 모델에 데이터 추가
            model.addAttribute("programs", programs);
            model.addAttribute("selectedProgramPk", programPk);
            model.addAttribute("schedules", schedules);
            model.addAttribute("currentDate", date);
            model.addAttribute("dateFormatter", formatter);
            model.addAttribute("today", today);

            return "admin/calendar";
        } catch (Exception e) {
            logger.error("관리자 메인 페이지 처리 중 오류 발생", e);
            model.addAttribute("errorMessage", "시스템 오류가 발생했습니다. 관리자에게 문의하세요.");
            return "admin/calendar";
        }
    }

    // 예약 생성 페이지 이동
    @GetMapping("/schedule")
    public String createSchedule(@RequestParam("programPk") Integer programPk,
                                 @RequestParam("date") String date,
                                 Model model) {
        // 프로그램 이름 가져오기
        String programName = scheduleService.getProgramNameByPk(programPk);
        
        model.addAttribute("programPk", programPk);
        model.addAttribute("programName", programName);
        model.addAttribute("date", date);

        return "admin/schedule-create";
    }

    // 예약 저장 처리
    @PostMapping("/schedule/save")
    public String saveSchedule(@ModelAttribute @DateTimeFormat(pattern = "yyyy-MM-dd") ScheduleVO scheduleVO, HttpSession session, RedirectAttributes redirectAttributes) {
        try {
        	logger.debug("Received ScheduleVO: {}", scheduleVO);
        	
        	 // 세션에서 loginMemberPk 가져오기
            Integer loginMemberPk = (Integer) session.getAttribute("loginMemberPk");
            if (loginMemberPk == null) {
                redirectAttributes.addFlashAttribute("errorMessage", "로그인이 필요합니다.");
                return "redirect:/login";
            }
            
            // 중복 일정 체크
            boolean isDuplicate = scheduleService.isDuplicateSchedule(
                scheduleVO.getProgramPk(), 
                scheduleVO.getDate(), 
                scheduleVO.getTime()
            );

            if (isDuplicate) {
                redirectAttributes.addFlashAttribute("errorMessage", "이미 같은 날짜와 시간에 예약 일정이 존재합니다.");
                return "redirect:/admin/schedule?programPk=" + scheduleVO.getProgramPk() + "&date=" + scheduleVO.getDate();
            }
            
            // memberPk 설정
            scheduleVO.setMemberPk(loginMemberPk);
            scheduleService.saveSchedule(scheduleVO);
            redirectAttributes.addFlashAttribute("message", "예약일정이 성공적으로 저장되었습니다.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "예약일정 저장 중 오류가 발생했습니다.");
        }
        return "redirect:/admin/calendar";
    }
    
    // 일정 관리페이지 겟 
    @GetMapping("/scheduleDetail")
    public String scheduleDetail(
            @RequestParam("schedulePk") int schedulePk,
            Model model) {
        try {
            // Schedule 정보 가져오기
            ScheduleVO schedule = scheduleService.getScheduleDetails(schedulePk);

            // DraftDocument 목록 가져오기
            List<DraftDocumentVO> draftDocuments = draftDocumentService.getDraftsBySchedulePk(schedulePk);

            // 기본 상태 및 초기화
            String status = "R"; // 기안문 없음 또는 반려 상태
            Integer draftDocumentPk = null;

            // Draft 목록 순회하여 상태 결정
            for (DraftDocumentVO draft : draftDocuments) {
                if ("C".equals(draft.getApprovalStatus())) {
                    status = "C"; // 결재완료가 가장 우선
                    draftDocumentPk = draft.getDraftDocumentPk();
                    break; // 결재완료 상태가 있으면 더 이상 순회할 필요 없음
                } else if ("P".equals(draft.getApprovalStatus())) {
                    status = "P"; // 진행 중인 기안문이 있으면 저장
                    draftDocumentPk = draft.getDraftDocumentPk();
                }
            }

            
            // 해당 Schedule의 예약 리스트 가져오기
            List<ReservationVO> reservations = reservationService.getReservationsWithDetailsBySchedulePk(schedulePk);

            model.addAttribute("schedule", schedule);
            model.addAttribute("reservations", reservations);
            // Model에 상태와 기안문 PK 추가
            model.addAttribute("status",status);
            model.addAttribute("draftDocumentPk", draftDocumentPk);

            return "admin/schedule-management";
        } catch (Exception e) {
            model.addAttribute("errorMessage", "시스템 오류가 발생했습니다.");
            return "admin/error";
        }
    }
    
    // 일정관리 제한인원 수정
    @PostMapping("/schedule/updateCapacity")
    public String updateScheduleCapacity(
            @RequestParam("schedulePk") int schedulePk,
            @RequestParam("maxCapacity") int maxCapacity,
            RedirectAttributes redirectAttributes) {
        try {
            // 제한 인원수 업데이트
            scheduleService.updateScheduleCapacity(schedulePk, maxCapacity);

            // 성공 메시지 설정
            redirectAttributes.addFlashAttribute("successMessage", "제한 인원수가 성공적으로 저장되었습니다.");
        } catch (Exception e) {
            // 실패 메시지 설정
            redirectAttributes.addFlashAttribute("errorMessage", "제한 인원수 저장 중 오류가 발생했습니다.");
        }
        return "redirect:/admin/scheduleDetail?schedulePk=" + schedulePk; // 현재 페이지로 리다이렉트
    }
    
    // 체험 인원 목록 팝업 조회
    @GetMapping("/reservation/experiencePersonsPopup")
    public String showExperiencePersonsPopup(@RequestParam("reservationPk") int reservationPk, Model model) {
        // 해당 예약의 체험 인원 목록 조회
        List<ExperiencePersonVO> experiencePersons = experiencePersonService.getExperiencePersonsByReservationPk(reservationPk);
        model.addAttribute("experiencePersons", experiencePersons); // 체험 인원 목록
        return "admin/experience-person-list"; // 팝업 JSP 페이지
    }
    
    // 예약 삭제(체험인원 삭제 -> 예약내역 삭제)
    @DeleteMapping("/reservation/delete/{reservationPk}")
    @ResponseBody
    public ResponseEntity<Void> deleteReservation(@PathVariable("reservationPk") int reservationPk) {
        try {
            reservationService.deleteReservationWithPersons(reservationPk);
            return ResponseEntity.ok().build(); // 성공 응답
        } catch (Exception e) {
            logger.error("예약 삭제 중 오류 발생: ", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build(); // 실패 응답
        }
    }

    // 관리자 예약자 추가 페이지 겟
    @GetMapping("/reservation/create")
    public String adminCreateReservation(@RequestParam("schedulePk") int schedulePk, Model model) {
        ScheduleVO schedule = reservationService.getScheduleByPk(schedulePk);

        // 프로그램 이름 가져오기
        String programName = scheduleMapper.selectProgramNameByPk(schedule.getProgramPk());
        schedule.setProgramName(programName);
        
        // 현재 예약자 수 가져오기
        int reservationCount = reservationService.getTotalExperiencePersonCount(schedulePk);
        
        // 예약 가능 인원 = 최대 인원 - 현재 예약자 수
        int availableCapacity = schedule.getMaxCapacity() - reservationCount;

        model.addAttribute("schedule", schedule);
        model.addAttribute("reservationCount", reservationCount); // 예약자수 넘기기 
        model.addAttribute("availableCapacity", availableCapacity); // 예약 가능 인원
        return "admin/reservation-create";
    }
    
    // 관리자 예약자 추가
    @PostMapping("/reservation/save")
    public String adminSaveReservation(
            @ModelAttribute ReservationVO reservationVO,
            @RequestParam("schedulePk") int schedulePk,
            HttpServletRequest request,
            RedirectAttributes redirectAttributes) {
        try {
            // 예약 PK 생성
            int reservationPk = reservationService.getNextReservationPk();
            reservationVO.setReservationPk(reservationPk);
            reservationVO.setSchedulePk(schedulePk);

            // Schedule에서 programPk 가져오기
            ScheduleVO schedule = reservationService.getScheduleByPk(schedulePk);
            reservationVO.setProgramPk(schedule.getProgramPk());

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
            return "redirect:/admin/scheduleDetail?schedulePk=" + schedulePk;
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("errorMessage", "예약 저장 중 오류가 발생했습니다.");
            return "redirect:/admin/reservation/create?schedulePk=" + schedulePk;
        }
    }
    
    // 사용자검색 팝업열기
    @GetMapping("/member/searchPopup")
    public String showMemberSearchPopup() {
        return "admin/member-search-popup";
    }
    
    // 사용자 검색기능
    @GetMapping("/member/search")
    public String searchMembers(@RequestParam(value = "keyword", required = false) String keyword, Model model) {
        List<MemberVO> members = memberService.searchMembersByNameAndLevel(keyword, "N"); // MEMBER_LEVEL=N인 사용자만 조회
        model.addAttribute("members", members);
        return "admin/member-search-popup";
    }
    
    // 관리자 예약 검색
    @GetMapping("/reservation/check")
    public String checkReservations(
            @RequestParam(value = "name", required = false) String name,
            @RequestParam(value = "phoneNumber", required = false) String phoneNumber,
            @RequestParam(value = "date", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date,
            @RequestParam(value = "programPk", required = false) Integer programPk,
            Model model) {
        // 프로그램 목록 가져오기
        List<ProgramVO> programs = programService.getAllPrograms();
        model.addAttribute("programs", programs);

        // 검색 조건에 해당하는 예약 목록 조회
        List<ReservationVO> reservations = reservationService.searchReservations(name, phoneNumber, date, programPk);
        model.addAttribute("reservations", reservations);

        return "admin/reservation-check";
    }

    // 기안문 생성화면 가져오기
    @GetMapping("/draft")
    public String getDraftForm(
            @RequestParam("schedulePk") int schedulePk, // Schedule PK 받아오기
            @SessionAttribute("loginMemberPk") int loginMemberPk,
            Model model) {

        // Member 정보 조회
        MemberVO member = memberService.getMemberWithDetails(loginMemberPk);

        // 기본 정보 추가
        model.addAttribute("member", member);
        model.addAttribute("schedulePk", schedulePk); // Hidden으로 전달
        model.addAttribute("currentDate", LocalDate.now()); // 현재 날짜

        return "admin/draft-create";
    }

    // 결재라인 결재자 검색
    @GetMapping("/approver/search")
    public String searchApprovers(
            @RequestParam(value = "department", required = false) String department,
            @RequestParam(value = "rank", required = false) String rank,
            @RequestParam(value = "name", required = false) String name,
            @SessionAttribute("loginMemberPk") int loginMemberPk, // 로그인한 사용자 PK
            Model model) {
    	
    	// 공통코드에서 직급과 부서 정보 조회
        List<CommonCodeVO> ranks = commonCodeService.getCodesByGroup("RANK");
        List<CommonCodeVO> departments = commonCodeService.getCodesByGroup("DEPARTMENT");
        
        // 결재자 목록 조회
        List<MemberVO> members = memberService.searchApprovers(department, rank, name, loginMemberPk);
        
        model.addAttribute("ranks", ranks);
        model.addAttribute("departments", departments);
        model.addAttribute("members", members);
        return "admin/approver-popup";
    }
    
    // 기안문 저장 ( 기안문, 결재라인, 첨부파일 )
    @PostMapping("/draft/save")
    public ResponseEntity<?> saveDraft(
            @ModelAttribute DraftDocumentVO draftDocumentVO,
            @RequestParam("approvers") List<String> approvers,
            @RequestParam("files") List<MultipartFile> files) {

        try {
            // 1. 기안문 저장
            int draftDocumentPk = draftDocumentService.saveDraft(draftDocumentVO);

            // 2. 결재라인 저장
            draftDocumentService.saveApprovalLines(draftDocumentPk, approvers);

            // 3. 첨부파일 저장
            draftDocumentService.saveAttachedFiles(draftDocumentPk, files);

            // 성공 응답 반환
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            // 에러 응답 반환
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    // 기안문 가져오기(예약일정 관리에서 확인)
    @GetMapping("/draft/view")
    public String viewDraft(
            @RequestParam("draftDocumentPk") int draftDocumentPk,
            Model model) {
        // 기안문 및 관련 데이터 조회
    	DraftDocumentVO draftDocument = draftDocumentService.getDraftByDraftDocumentPk(draftDocumentPk);
        List<ApprovalLineVO> approvalLines = draftDocumentService.getApprovalLinesByDraftPk(draftDocumentPk);
        List<DraftFileVO> attachedFiles = draftDocumentService.getAttachedFilesByDraftPk(draftDocumentPk);

        // 모델에 데이터 추가
        model.addAttribute("draftDocument", draftDocument);
        model.addAttribute("approvalLines", approvalLines);
        model.addAttribute("attachedFiles", attachedFiles);

        return "admin/draft-view"; // 상세보기 JSP 페이지
    }
    
    // 첨부파일 다운로드
    @GetMapping("/draft/file/download")
    public ResponseEntity<Resource> downloadFile(@RequestParam("filePk") int filePk) {
        try {
            // 파일 정보를 가져옴
            DraftFileVO file = draftDocumentService.getFileByPk(filePk);
            
            // 파일 로드
            Resource resource = fileStorageService.loadFile(file.getFilePath());
            
            // 파일 다운로드를 위한 헤더 설정
            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + file.getFileName() + "\"")
                    .body(resource);
        } catch (IOException e) {
            // 파일 로드 실패 시 에러 처리
            e.printStackTrace(); // 로그 출력
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(null);
        } catch (Exception e) {
            // 기타 예외 처리
            e.printStackTrace(); // 로그 출력
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(null);
        }
    }

    // 결재함 조회
    @GetMapping("/approval/inbox")
    public String getApprovalInbox(HttpSession session, Model model) {
    	// 세션에서 로그인한 유저의 memberPk 가져오기
        Integer memberPk = (Integer) session.getAttribute("loginMemberPk");
        
        if (memberPk == null) {
            // 로그인하지 않은 상태라면 로그인 페이지로 리다이렉트
            return "redirect:/member/login";
        }
    	
        List<DraftDocumentVO> drafts = draftDocumentService.getDraftsForApproval(memberPk);
        model.addAttribute("drafts", drafts);
        return "admin/approval-inbox";
    }
    
    // 결재함 기안문 상세 및 결재 기능
    @GetMapping("/approval/draft/detail")
    public String getApprovalDraftDetail(
            @RequestParam("draftDocumentPk") int draftDocumentPk,
            HttpSession session, Model model) {
        // 로그인 사용자 확인
        Integer memberPk = (Integer) session.getAttribute("loginMemberPk");
        if (memberPk == null) {
            return "redirect:/member/login";
        }

        // 기안문 상세 및 관련 데이터 조회
        DraftDocumentVO draftDocument = draftDocumentService.getDraftByDraftDocumentPk(draftDocumentPk);
        List<ApprovalLineVO> approvalLines = draftDocumentService.getApprovalLinesByDraftPk(draftDocumentPk);
        List<DraftFileVO> attachedFiles = draftDocumentService.getAttachedFilesByDraftPk(draftDocumentPk);

        // 로그인한 사용자가 결재중인지 확인
        boolean isCurrentApprover = false;
        for (ApprovalLineVO line : approvalLines) {
        	logger.info("memberpk는 뭐로나오지: {}", memberPk);
        	logger.info("line.memberpk는 뭐로나오지: {}", line.getMemberPk());
        	logger.info("line상태 뭐로나오는지: {}", line.getLineStatus());
            if (line.getMemberPk() == memberPk && "I".equals(line.getLineStatus())) {
                isCurrentApprover = true;
                break;
            }
        }

        // isCurrentApprover 값 로그 출력
        logger.info("현재 로그인한 사용자가 결재중인지 여부: {}", isCurrentApprover);

        model.addAttribute("draftDocument", draftDocument);
        model.addAttribute("approvalLines", approvalLines);
        model.addAttribute("attachedFiles", attachedFiles);
        model.addAttribute("isCurrentApprover", isCurrentApprover);

        return "admin/approval-draft-detail"; // 새로운 JSP
    }

    // 결재 승인 처리
    @PostMapping("/approval/draft/approve")
    @ResponseBody
    public ResponseEntity<?> approveDraft(@RequestBody Map<String, Integer> requestData, HttpSession session) {
        Integer memberPk = (Integer) session.getAttribute("loginMemberPk");
        if (memberPk == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        }

        int draftDocumentPk = requestData.get("draftDocumentPk");

        try {
            draftDocumentService.approveDraftLine(draftDocumentPk, memberPk);
            return ResponseEntity.ok("결재가 완료되었습니다.");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("결재 처리 중 오류가 발생했습니다.");
        }
    }
    
    // 결재 반려 처리
    @PostMapping("/approval/draft/reject")
    @ResponseBody
    public ResponseEntity<?> rejectDraft(@RequestBody Map<String, Object> requestData, HttpSession session) {
        Integer memberPk = (Integer) session.getAttribute("loginMemberPk");
        if (memberPk == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
        }

        int draftDocumentPk = (int) requestData.get("draftDocumentPk");

        try {
            draftDocumentService.rejectDraftLine(draftDocumentPk, memberPk);
            return ResponseEntity.ok("반려가 완료되었습니다.");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("반려 처리 중 오류가 발생했습니다.");
        }
    }
    
    // 일괄 생성 페이지 이동
    @GetMapping("/schedule/bulk")
    public String bulkCreateSchedule(@RequestParam("programPk") Integer programPk,
                                     @RequestParam("yearMonth") String yearMonth,
                                     Model model) {
        String programName = scheduleService.getProgramNameByPk(programPk);

        model.addAttribute("programPk", programPk);
        model.addAttribute("programName", programName);
        model.addAttribute("yearMonth", yearMonth); // yyyy-MM 형식

        return "admin/schedule-bulk-create";
    }

    // 일괄 생성 처리
    @PostMapping("/schedule/bulk/save")
    public String saveBulkSchedule(@ModelAttribute ScheduleBulkVO bulkVO, HttpSession session, RedirectAttributes redirectAttributes) {
        try {
        	
        	// 세션에서 loginMemberPk 가져오기
            Integer loginMemberPk = (Integer) session.getAttribute("loginMemberPk");
            if (loginMemberPk == null) {
                redirectAttributes.addFlashAttribute("errorMessage", "로그인이 필요합니다.");
                return "redirect:/login";
            }
            
            // memberPk 설정
            bulkVO.setMemberPk(loginMemberPk);
        	
            scheduleService.saveBulkSchedule(bulkVO);
            redirectAttributes.addFlashAttribute("message", "일괄 생성이 성공적으로 완료되었습니다.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "일괄 생성 중 오류가 발생했습니다.");
        }
        return "redirect:/admin/calendar";
    }

}
