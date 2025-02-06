package egovframework.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.mapper.ExperiencePersonMapper;
import egovframework.service.ExperiencePersonService;
import egovframework.vo.ExperiencePersonVO;

@Service
public class ExperiencePersonServiceImpl implements ExperiencePersonService {
	
	@Autowired
	private ExperiencePersonMapper experiencePersonMapper;
	
	// 예약Pk로 체험인원들 조회
	@Override
	public List<ExperiencePersonVO> getExperiencePersonsByReservationPk(int reservationPk) {
	    return experiencePersonMapper.getExperiencePersonsByReservationPk(reservationPk);
	}
}
