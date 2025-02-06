package egovframework.mapper;

import java.time.LocalDate;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import egovframework.vo.ExperiencePersonVO;
import egovframework.vo.ReservationVO;
import egovframework.vo.ScheduleVO;

@Mapper
public interface ReservationMapper {
	// 예약pk 채번
	int selectNextReservationPk();
	// 체험인원 pk 채번
	int selectNextExperiencePersonPk();
	// 예약 정보 저장
	void insertReservation(ReservationVO reservation);
	// 체험 인원 정보 저장
	void insertExperiencePerson(ExperiencePersonVO experiencePerson);
	// 예약 일정 조회
	ScheduleVO selectSchedule(@Param("schedulePk") int schedulePk);
	// 해당 schedule이 가진 체험인원 수 반환
	int getExperiencePersonCountBySchedulePk(@Param("schedulePk") int schedulePk);
	// 예약일정Pk로 예약내역들 가져오기
	List<ReservationVO> getReservationsBySchedulePk(int schedulePk);
	// 예약일정 관리에서 쓸 예약내역 join member, experience_person
	List<ReservationVO> getReservationsWithDetailsBySchedulePk(int schedulePk);
	// Pk로 예약내역 삭제
	void deleteByPk(int reservationPk);
	// 예약내역 검색 관리자
	List<ReservationVO> searchReservations(@Param("name") String name,
            @Param("phoneNumber") String phoneNumber,
            @Param("date") LocalDate date,
            @Param("programPk") Integer programPk);
	// 사용자Pk로 예약내역 가져오기
	List<ReservationVO> getReservationsByMemberPk(int memberPk);

}
