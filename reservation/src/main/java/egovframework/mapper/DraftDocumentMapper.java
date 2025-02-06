package egovframework.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import egovframework.vo.DraftDocumentVO;

@Mapper
public interface DraftDocumentMapper {
	// 기안문 PK 생성
	int getNextDraftPk(); 
	// 기안문 PK 생성
    void insertDraft(DraftDocumentVO draftDocumentVO);
    // 기안문 존재 여부 확인
    boolean isDraftExistsBySchedulePk(@Param("schedulePk") int schedulePk);
    // schedulePk로 기안문 가져오기
    DraftDocumentVO getDraftBySchedulePk(int schedulePk);
    // drattPk로 기안문 가져오기
    DraftDocumentVO getDraftByDraftDocumentPk(int draftDocumentPk);
    // 기안함 조회(memberPk)
    List<DraftDocumentVO> selectDraftsForApproval(int memberPk);
    // 기안문 상태 업데이트 (결재 완료)
    void updateApprovalStatus(@Param("draftDocumentPk") int draftDocumentPk,
                              @Param("approvalStatus") String approvalStatus);
    // 기안문 목록 가져오기
    List<DraftDocumentVO> selectDraftsBySchedulePk(int schedulePk);
}
