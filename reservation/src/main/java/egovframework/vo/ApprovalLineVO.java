package egovframework.vo;

import java.time.LocalDate;

public class ApprovalLineVO {
	private int approvalLinePk;       // 결재 라인 PK
    private int draftDocumentPk;      // 기안문 PK
    private int memberPk;             // 결재자 PK
    private int lineOrder;            // 결재 순서
    private String lineStatus;        // 결재 상태 (I: 진행중, W: 대기, A: 승인)
    private LocalDate approvedAt;     // 결재 처리일
    
    private String memberName;
    private String rankName;
	private String lineStatusName;
    
    // 게터와 세터
    public int getApprovalLinePk() {
		return approvalLinePk;
	}
	public void setApprovalLinePk(int approvalLinePk) {
		this.approvalLinePk = approvalLinePk;
	}
	public int getDraftDocumentPk() {
		return draftDocumentPk;
	}
	public void setDraftDocumentPk(int draftDocumentPk) {
		this.draftDocumentPk = draftDocumentPk;
	}
	public int getMemberPk() {
		return memberPk;
	}
	public void setMemberPk(int memberPk) {
		this.memberPk = memberPk;
	}
	public int getLineOrder() {
		return lineOrder;
	}
	public void setLineOrder(int lineOrder) {
		this.lineOrder = lineOrder;
	}
	public String getLineStatus() {
		return lineStatus;
	}
	public void setLineStatus(String lineStatus) {
		this.lineStatus = lineStatus;
	}
	public LocalDate getApprovedAt() {
		return approvedAt;
	}
	public void setApprovedAt(LocalDate approvedAt) {
		this.approvedAt = approvedAt;
	}
	public String getMemberName() {
		return memberName;
	}
	public void setMemberName(String memberName) {
		this.memberName = memberName;
	}
	public String getRankName() {
		return rankName;
	}
	public void setRankName(String rankName) {
		this.rankName = rankName;
	}
	public String getLineStatusName() {
		return lineStatusName;
	}
	public void setLineStatusName(String lineStatusName) {
		this.lineStatusName = lineStatusName;
	}
	
}
