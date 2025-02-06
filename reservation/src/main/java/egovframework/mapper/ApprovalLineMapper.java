package egovframework.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import egovframework.vo.ApprovalLineVO;

@Mapper
public interface ApprovalLineMapper {
	// 결재라인 PK 생성
	int getNextApprovalLinePk(); 
	// 결재라인 저장
    void insertApprovalLine(ApprovalLineVO approvalLineVO); 
    // 기안문Pk로 결재라인들 가져오기
    List<ApprovalLineVO> getApprovalLinesByDraftPk(int draftDocumentPk);
    // 현재 결재라인 상태 업데이트 (승인 처리)
    void updateLineStatus(@Param("draftDocumentPk") int draftDocumentPk,
                          @Param("memberPk") int memberPk,
                          @Param("lineStatus") String lineStatus);
    // 다음 결재라인 가져오기
    ApprovalLineVO getNextApprovalLine(@Param("draftDocumentPk") int draftDocumentPk);
}
