package egovframework.service;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import egovframework.vo.ApprovalLineVO;
import egovframework.vo.DraftDocumentVO;
import egovframework.vo.DraftFileVO;

public interface DraftDocumentService {
	// 기안문 저장(pk 리턴)
	int saveDraft(DraftDocumentVO draftDocumentVO);
	// 결재라인 저장
	void saveApprovalLines(int draftDocumentPk, List<String> approvers);
	// 첨부파일 저장
	void saveAttachedFiles(int draftDocumentPk, List<MultipartFile> files);
	// schedule의 기안문 보유여부
	boolean isDraftExistsBySchedulePk(int schedulePk);
	// 기안문 가져오기(schedulePk)
	public DraftDocumentVO getDraftBySchedulePk(int schedulePk);
	// 기안문 가져오기(draftPk)
	public DraftDocumentVO getDraftByDraftDocumentPk(int DraftDocumentPk);
	// 결재라인 가져오기
	public List<ApprovalLineVO> getApprovalLinesByDraftPk(int draftDocumentPk);
	// 첨부파일 가져오기
	public List<DraftFileVO> getAttachedFilesByDraftPk(int draftDocumentPk);
	// 첨부파일 단건 가져오기(다운로드)
	public DraftFileVO getFileByPk(int filePk);
	// 기안함조회(memberPK)
	public List<DraftDocumentVO> getDraftsForApproval(int memberPk);
	// 결재 로직
	void approveDraftLine(int draftDocumentPk, int memberPk);
	// 반려 로직
	void rejectDraftLine(int draftDocumentPk, int memberPk);
	// 기안문 목록가져오기(schedulePk)
	List<DraftDocumentVO> getDraftsBySchedulePk(int schedulePk);
}
