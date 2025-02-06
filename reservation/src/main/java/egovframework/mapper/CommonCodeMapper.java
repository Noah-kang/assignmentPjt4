package egovframework.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import egovframework.vo.CommonCodeVO;

@Mapper
public interface CommonCodeMapper {
	// 코드그룹으로 공통코드 정보 가져오기
	List<CommonCodeVO> getCodesByGroup(@Param("codeGroup") String codeGroup);
}
