package egovframework.service;

import java.time.LocalDate;
import java.util.List;

import egovframework.vo.ScheduleBulkVO;
import egovframework.vo.ScheduleVO;

public interface ScheduleService {
	// 관리자 홈 해당 월 일정관리 정보 가져오기
	List<ScheduleVO> getSchedulesByProgramAndMonth(int programPk, LocalDate month);
	// 프로그램 PK로 프로그램 이름 가져오기
	String getProgramNameByPk(Integer programPk);
    // 예약일정 저장하기
	void saveSchedule(ScheduleVO scheduleVO);
	// 예약일정pk로 가져오기
	ScheduleVO getScheduleByPk(int schedulePk);
	// 예약일정관리에서 필요한 schedule 데이터 가져오기
	ScheduleVO getScheduleDetails(int schedulePk);
	// 예약일정 제한인원 수정
	void updateScheduleCapacity(int schedulePk, int maxCapacity);
	// 예약일정 일괄생성
	void saveBulkSchedule(ScheduleBulkVO bulkVO);
	// 예약일정 중복확인
	boolean isDuplicateSchedule(int programPk, LocalDate date, String time);
}
