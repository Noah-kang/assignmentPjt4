package egovframework.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.mapper.ProgramMapper;
import egovframework.service.ProgramService;
import egovframework.vo.ProgramVO;

@Service
public class ProgramServiceImpl implements ProgramService {

    @Autowired
    private ProgramMapper programMapper;

    @Override
    public List<ProgramVO> getAllPrograms() {
        return programMapper.getAllPrograms();
    }
}
