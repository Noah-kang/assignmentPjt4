package egovframework.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import egovframework.vo.ExperiencePersonVO;

@Mapper
public interface ExperiencePersonMapper {

	// 예약에 해당하는 체험 인원 목록 조회
	List<ExperiencePersonVO> getExperiencePersonsByReservationPk(int reservationPk);
	// 예약내역pk로 체험인원 삭제
	void deleteByReservationPk(int reservationPk); 
	
}
