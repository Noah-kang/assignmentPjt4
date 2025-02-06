package egovframework.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.mapper.CommonCodeMapper;
import egovframework.service.CommonCodeService;
import egovframework.vo.CommonCodeVO;

@Service
public class CommonCodeServiceImpl implements CommonCodeService {
    
	@Autowired
    private CommonCodeMapper commonCodeMapper;

	// 코드그룹으로 공통코드정보 가져오기
    @Override
    public List<CommonCodeVO> getCodesByGroup(String codeGroup) {
        return commonCodeMapper.getCodesByGroup(codeGroup);
    }
}

