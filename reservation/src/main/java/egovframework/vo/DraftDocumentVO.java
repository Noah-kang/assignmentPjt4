package egovframework.vo;

import java.time.LocalDate;

import org.springframework.format.annotation.DateTimeFormat;

public class DraftDocumentVO {
	private int draftDocumentPk; // 기안문 PK
    private String title; // 제목
    private String content; // 내용
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate date; // 작성일
    private int schedulePk; // 예약 일정 PK
    private int memberPk; // 작성자 PK
    private String approvalStatus; // 결재 상태
    
    private String memberName;
    private String department;
    private String departmentName;
    private String rank;
    private String rankName;
    private String drafterName;
    private String approvalStatusName;
	
    // 게터 세터
    public int getDraftDocumentPk() {
		return draftDocumentPk;
	}
	public void setDraftDocumentPk(int draftDocumentPk) {
		this.draftDocumentPk = draftDocumentPk;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public LocalDate getDate() {
		return date;
	}
	public void setDate(LocalDate date) {
		this.date = date;
	}
	public int getSchedulePk() {
		return schedulePk;
	}
	public void setSchedulePk(int schedulePk) {
		this.schedulePk = schedulePk;
	}
	public int getMemberPk() {
		return memberPk;
	}
	public void setMemberPk(int memberPk) {
		this.memberPk = memberPk;
	}
	public String getApprovalStatus() {
		return approvalStatus;
	}
	public void setApprovalStatus(String approvalStatus) {
		this.approvalStatus = approvalStatus;
	}
	public String getMemberName() {
		return memberName;
	}
	public void setMemberName(String memberName) {
		this.memberName = memberName;
	}
	public String getDepartment() {
		return department;
	}
	public void setDepartment(String department) {
		this.department = department;
	}
	public String getDepartmentName() {
		return departmentName;
	}
	public void setDepartmentName(String departmentName) {
		this.departmentName = departmentName;
	}
	public String getRank() {
		return rank;
	}
	public void setRank(String rank) {
		this.rank = rank;
	}
	public String getRankName() {
		return rankName;
	}
	public void setRankName(String rankName) {
		this.rankName = rankName;
	}
	public String getDrafterName() {
		return drafterName;
	}
	public void setDrafterName(String drafterName) {
		this.drafterName = drafterName;
	}
	public String getApprovalStatusName() {
		return approvalStatusName;
	}
	public void setApprovalStatusName(String approvalStatusName) {
		this.approvalStatusName = approvalStatusName;
	}
}
