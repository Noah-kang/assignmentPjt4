package egovframework.service;

import java.util.List;

import egovframework.vo.CommonCodeVO;

public interface CommonCodeService {
	// 공통코드 그룹이름 으로 조회
	List<CommonCodeVO> getCodesByGroup(String codeGroup);
}
