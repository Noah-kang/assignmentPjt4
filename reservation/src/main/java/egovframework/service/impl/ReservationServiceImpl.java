package egovframework.service.impl;

import java.time.LocalDate;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.mapper.ExperiencePersonMapper;
import egovframework.mapper.ReservationMapper;
import egovframework.service.ReservationService;
import egovframework.vo.ExperiencePersonVO;
import egovframework.vo.ReservationVO;
import egovframework.vo.ScheduleVO;

@Service
public class ReservationServiceImpl implements ReservationService{

	@Autowired
    private ReservationMapper reservationMapper;

	@Autowired
    private ExperiencePersonMapper experiencePersonMapper;
	
	// 예약일정PK로 예약일정 가져오기
	@Override
    public ScheduleVO getScheduleByPk(int schedulePk) {
        return reservationMapper.selectSchedule(schedulePk);
    }
    
    // 예약 저장하기
	@Override
	@Transactional
    public void saveReservation(ReservationVO reservation, List<ExperiencePersonVO> participants) {
        reservationMapper.insertReservation(reservation);
        participants.forEach(person -> {
            person.setReservationPk(reservation.getReservationPk());
            reservationMapper.insertExperiencePerson(person);
        });
    }
	
	// 예약 채번
	@Override
    public int getNextReservationPk() {
        return reservationMapper.selectNextReservationPk();
    }

	// 체험인원 채번
    @Override
    public int getNextExperiencePersonPk() {
        return reservationMapper.selectNextExperiencePersonPk();
    }

    // 예약 저장
    @Override
    public void saveReservation(ReservationVO reservationVO) {
        reservationMapper.insertReservation(reservationVO);
    }

    // 체험인원 저장
    @Override
    public void saveExperiencePerson(ExperiencePersonVO experiencePersonVO) {
        reservationMapper.insertExperiencePerson(experiencePersonVO);
    }
    
    // 해당 schedule이 가진 체험인원 가져오기
    @Override
    public int getTotalExperiencePersonCount(int schedulePk) {
        return reservationMapper.getExperiencePersonCountBySchedulePk(schedulePk);
    }
    
    // 예약일정pk로 예약내역들 가져오기
    @Override
    public List<ReservationVO> getReservationsBySchedulePk(int schedulePk) {
        return reservationMapper.getReservationsBySchedulePk(schedulePk);
    }
    
    // 예약일정 관리에서 쓸 reservation 정보 join member, EP
    @Override
    public List<ReservationVO> getReservationsWithDetailsBySchedulePk(int schedulePk) {
        return reservationMapper.getReservationsWithDetailsBySchedulePk(schedulePk);
    }
    
    // 예약일정 관리에서 예약내역 삭제 
    @Transactional
    @Override
    public void deleteReservationWithPersons(int reservationPk) {
        // 먼저 체험 인원 삭제
        experiencePersonMapper.deleteByReservationPk(reservationPk);

        // 예약 정보 삭제
        reservationMapper.deleteByPk(reservationPk);
    }
    
    // 예약내역 검색
    @Override
    public List<ReservationVO> searchReservations(String name, String phoneNumber, LocalDate date, Integer programPk) {
        return reservationMapper.searchReservations(name, phoneNumber, date, programPk);
    }
    
    // memberPk로 예약내역 가져오기
    @Override
    public List<ReservationVO> getReservationsByMemberPk(int memberPk) {
        return reservationMapper.getReservationsByMemberPk(memberPk);
    }
}
