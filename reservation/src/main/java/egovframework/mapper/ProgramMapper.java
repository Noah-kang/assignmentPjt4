package egovframework.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import egovframework.vo.ProgramVO;

@Mapper
public interface ProgramMapper {
	// 모든 프로그램 가져오기
	List<ProgramVO> getAllPrograms();
}
