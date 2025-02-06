package egovframework.service;

import java.time.LocalDate;
import java.util.List;

import egovframework.vo.ExperiencePersonVO;
import egovframework.vo.ReservationVO;
import egovframework.vo.ScheduleVO;

public interface ReservationService {
	// 예약일정 PK로 정보 가져오기
	ScheduleVO getScheduleByPk(int schedulePk);
	// 예약 저장하기
	void saveReservation(ReservationVO reservation, List<ExperiencePersonVO> participants);
	// 예약PK 채번
	int getNextReservationPk();
	// 체험인원PK 채번
	int getNextExperiencePersonPk();
	// 예약 저장
	void saveReservation(ReservationVO reservationVO);
	// 체험인원 저장
	void saveExperiencePerson(ExperiencePersonVO experiencePersonVO);
	// 해당 schedule이 가진 체험인원 수 가져오기
	int getTotalExperiencePersonCount(int schedulePk);
	// schedulPk로 reservation 가져오기 
	List<ReservationVO> getReservationsBySchedulePk(int schedulePk);
	// 예약일정 관리에서 쓸 예약내역 정보 join member, experience_person
	List<ReservationVO> getReservationsWithDetailsBySchedulePk(int schedulePk);
	// 예약일정 삭제 + 체험인원
	void deleteReservationWithPersons(int reservationPk);
	// 예약내역 검색 관리자 
	List<ReservationVO> searchReservations(String name, String phoneNumber, LocalDate date, Integer programPk);
	// memberPk로 예약 정보 가져오기
	List<ReservationVO> getReservationsByMemberPk(int memberPk);
}
