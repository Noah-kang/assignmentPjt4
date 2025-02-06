package egovframework.service;

import java.util.List;

import egovframework.vo.ExperiencePersonVO;

public interface ExperiencePersonService {
	// 체험 인원 조회
	List<ExperiencePersonVO> getExperiencePersonsByReservationPk(int reservationPk);
}
