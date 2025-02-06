package egovframework.service.impl;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.mapper.ScheduleMapper;
import egovframework.service.ScheduleService;
import egovframework.vo.ScheduleBulkVO;
import egovframework.vo.ScheduleVO;

@Service
public class ScheduleServiceImpl implements ScheduleService {

    @Autowired
    private ScheduleMapper scheduleMapper;

    // 관리자 홈 월별 예약 일정 가져오기
    @Override
    public List<ScheduleVO> getSchedulesByProgramAndMonth(int programPk, LocalDate month) {
        LocalDate startDate = month.withDayOfMonth(1);
        LocalDate endDate = month.withDayOfMonth(month.lengthOfMonth());
        return scheduleMapper.getSchedulesByProgramAndDateRange(programPk, startDate, endDate);
    }
    
    // 프로그램 PK로 프로그램이름 가져오기
    @Override
    public String getProgramNameByPk(Integer programPk) {
        return scheduleMapper.selectProgramNameByPk(programPk);
    }

    // 예약일정 저장하기
    @Override
    public void saveSchedule(ScheduleVO scheduleVO) {
    	int schedulePk = scheduleMapper.selectNextSchedulePk();
    	scheduleVO.setSchedulePk(schedulePk);
        scheduleMapper.insertSchedule(scheduleVO);
    }
    
    // 예약일정Pk로 예약일정 가져오기
    @Override
    public ScheduleVO getScheduleByPk(int schedulePk) {
        return scheduleMapper.getScheduleByPk(schedulePk);
    }
    
    // 예약일정 관리에서 필요한 schedule데이터 가져오기
    @Override
    public ScheduleVO getScheduleDetails(int schedulePk) {
        return scheduleMapper.getScheduleDetails(schedulePk);
    }
    
    // 예약일정 제한인원 수정
    @Override
    public void updateScheduleCapacity(int schedulePk, int maxCapacity) {
        scheduleMapper.updateMaxCapacity(schedulePk, maxCapacity);
    }
    
    // 예약일정 일괄생성
    @Override
    @Transactional
    public void saveBulkSchedule(ScheduleBulkVO bulkVO) {
        YearMonth yearMonth = YearMonth.parse(bulkVO.getYearMonth());
        LocalDate startDate = yearMonth.atDay(1);
        LocalDate endDate = yearMonth.atEndOfMonth();

        for (LocalDate date = startDate; !date.isAfter(endDate); date = date.plusDays(1)) {
            // 월요일은 제외
            if (date.getDayOfWeek() == DayOfWeek.MONDAY) continue;

            // 이미 같은 날짜와 시간에 예약이 존재하는지 확인
            boolean exists = scheduleMapper.existsSchedule(bulkVO.getProgramPk(), date, bulkVO.getTime());
            if (exists) continue;
            
            // 예약 일정 pk 채번해서 가져오기
            int schedulePk = scheduleMapper.selectNextSchedulePk();

            // 예약 일정 저장
            ScheduleVO scheduleVO = new ScheduleVO();
            scheduleVO.setSchedulePk(schedulePk);
            scheduleVO.setProgramPk(bulkVO.getProgramPk());
            scheduleVO.setDate(date);
            scheduleVO.setTime(bulkVO.getTime());
            scheduleVO.setMaxCapacity(bulkVO.getMaxCapacity());
            scheduleVO.setMemberPk(bulkVO.getMemberPk());
            scheduleMapper.insertSchedule(scheduleVO);
        }
    }
    
    // 예약일정 중복확인
    @Override
    public boolean isDuplicateSchedule(int programPk, LocalDate date, String time) {
        return scheduleMapper.existsSchedule(programPk, date, time);
    }
}
