package egovframework.service.impl;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import egovframework.mapper.ApprovalLineMapper;
import egovframework.mapper.DraftDocumentMapper;
import egovframework.mapper.DraftFileMapper;
import egovframework.service.DraftDocumentService;
import egovframework.service.FileStorageService;
import egovframework.vo.ApprovalLineVO;
import egovframework.vo.DraftDocumentVO;
import egovframework.vo.DraftFileVO;

@Service
public class DraftDocumentServiceImpl  implements DraftDocumentService{

	@Autowired
    private DraftDocumentMapper draftDocumentMapper;
	
	@Autowired
    private ApprovalLineMapper approvalLineMapper;
	
	@Autowired
    private DraftFileMapper draftFileMapper;
	
	@Autowired
	private FileStorageService fileStorageService;
	
	
	//기안문 저장
	@Override
	public int saveDraft(DraftDocumentVO draftDocumentVO) {
	    int draftPk = draftDocumentMapper.getNextDraftPk();
	    draftDocumentVO.setDraftDocumentPk(draftPk);
	    draftDocumentMapper.insertDraft(draftDocumentVO);
	    return draftPk;
	}
	
	//결재라인 저장
	@Override
	@Transactional
	public void saveApprovalLines(int draftDocumentPk, List<String> approvers) {
	    for (int i = 0; i < approvers.size(); i++) {
	        ApprovalLineVO line = new ApprovalLineVO();
	        line.setApprovalLinePk(approvalLineMapper.getNextApprovalLinePk());
	        line.setDraftDocumentPk(draftDocumentPk);
	        line.setMemberPk(Integer.parseInt(approvers.get(i)));
	        line.setLineOrder(i + 1);
	        approvalLineMapper.insertApprovalLine(line);
	    }
	}
	
	//첨부파일 저장
	@Override
	@Transactional
	public void saveAttachedFiles(int draftDocumentPk, List<MultipartFile> files) {
		for (MultipartFile file : files) {
			// 1) 파일이 비어있으면 skip
	        if (file.isEmpty() || file.getOriginalFilename() == null || file.getOriginalFilename().isEmpty()) {
	            continue; 
	        }
			
	        try {
	            String uuid = UUID.randomUUID().toString(); // UUID 생성
	            String filePath = fileStorageService.saveFile(file, uuid); // 파일 저장 처리 (UUID 전달)

	            DraftFileVO fileVO = new DraftFileVO();
	            fileVO.setFilePk(draftFileMapper.getNextFilePk());
	            fileVO.setDraftDocumentPk(draftDocumentPk);
	            fileVO.setFileName(file.getOriginalFilename());
	            fileVO.setFilePath(filePath);
	            fileVO.setFileSize(file.getSize());
	            fileVO.setUuid(uuid); // UUID 저장
	            draftFileMapper.insertDraftFile(fileVO);
	        } catch (IOException e) {
	            // 예외 처리 로직
	            e.printStackTrace(); // 로그로 출력하거나 사용자 정의 예외를 던집니다.
	            throw new RuntimeException("파일 저장 중 오류 발생", e); // 필요한 경우 런타임 예외로 래핑하여 다시 던짐
	        }
	    }
	}
	
	// schedule이 기안문 보유 여부
	@Override
    public boolean isDraftExistsBySchedulePk(int schedulePk) {
        return draftDocumentMapper.isDraftExistsBySchedulePk(schedulePk);
    }
	
	 // schedule로 기안문 조회
	@Override
    public DraftDocumentVO getDraftBySchedulePk(int schedulePk) {
        return draftDocumentMapper.getDraftBySchedulePk(schedulePk);
    }
	
	// draftPk로 기안문 조회
	@Override
    public DraftDocumentVO getDraftByDraftDocumentPk(int draftDocumentPk) {
        return draftDocumentMapper.getDraftByDraftDocumentPk(draftDocumentPk);
    }

	// 기안pk로 결재라인들 조회
    @Override
    public List<ApprovalLineVO> getApprovalLinesByDraftPk(int draftDocumentPk) {
        return approvalLineMapper.getApprovalLinesByDraftPk(draftDocumentPk);
    }

    // 기안pk로 첨부파일들 조회
    @Override
    public List<DraftFileVO> getAttachedFilesByDraftPk(int draftDocumentPk) {
        return draftFileMapper.getAttachedFilesByDraftPk(draftDocumentPk);
    }
    
    // 파일 단건 조회 (다운로드용)
    @Override
    public DraftFileVO getFileByPk(int filePk) {
        return draftFileMapper.getFileByPk(filePk);
    }
    
    // 기안함 조회(memberPk)
    @Override
    public List<DraftDocumentVO> getDraftsForApproval(int memberPk) {
        return draftDocumentMapper.selectDraftsForApproval(memberPk);
    }
    
    // 결재 승인 로직
    @Override
    @Transactional
    public void approveDraftLine(int draftDocumentPk, int memberPk) {
        // 현재 결재라인 승인 처리
        approvalLineMapper.updateLineStatus(draftDocumentPk, memberPk, "A"); // 승인 상태로 변경

        // 다음 결재라인 찾기
        ApprovalLineVO nextLine = approvalLineMapper.getNextApprovalLine(draftDocumentPk);
        if (nextLine != null) {
            approvalLineMapper.updateLineStatus(draftDocumentPk, nextLine.getMemberPk(), "I"); // 다음 라인을 결재중으로 변경
        } else {
            // 더 이상 결재라인이 없으면 기안문 상태를 결재 완료로 변경
            draftDocumentMapper.updateApprovalStatus(draftDocumentPk, "C");
        }
    }
    
    // 결재 반려 로직
    @Override
    @Transactional
    public void rejectDraftLine(int draftDocumentPk, int memberPk) {
        // 현재 결재라인 반려 처리
        approvalLineMapper.updateLineStatus(draftDocumentPk, memberPk, "R");

        // 기안문 상태를 반려로 변경
        draftDocumentMapper.updateApprovalStatus(draftDocumentPk, "R");
    }

    //기안문 목록 가져오기 schedulePk
    @Override
    public List<DraftDocumentVO> getDraftsBySchedulePk(int schedulePk) {
        return draftDocumentMapper.selectDraftsBySchedulePk(schedulePk);
    }
    
}
