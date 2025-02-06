package egovframework.mapper;

import java.time.LocalDate;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import egovframework.vo.ScheduleVO;

@Mapper
public interface ScheduleMapper {
	// 관리자 페이지 홈 월별 예약일정 가져오기
	List<ScheduleVO> getSchedulesByProgramAndDateRange(@Param("programPk") Integer programPk,
            @Param("startDate") LocalDate startDate,
            @Param("endDate") LocalDate endDate);	
	// 프로그램PK로 프로그램 이름 가져오기
	String selectProgramNameByPk(Integer programPk);
	// 예약일정 저장하기
    void insertSchedule(ScheduleVO scheduleVO);
    // 예약일정 pk 채번
    int selectNextSchedulePk();
    // 예약일정 pk로 예약일정 가져오기
    ScheduleVO getScheduleByPk(int schedulePk);
    // 예약관리 에서 필요한 schedule 데이터
    ScheduleVO getScheduleDetails(@Param("schedulePk") int schedulePk);
    // 예약일정 제한인원 수정
    void updateMaxCapacity(@Param("schedulePk") int schedulePk, @Param("maxCapacity") int maxCapacity);
    // 같은 날짜와 시간에 예약 존재 여부 확인
    boolean existsSchedule(@Param("programPk") int programPk,
                           @Param("date") LocalDate date,
                           @Param("time") String time);
}
