package egovframework.vo;

import java.time.LocalDate;

import org.springframework.format.annotation.DateTimeFormat;

public class ReservationVO {
	private int reservationPk; // 예약 PK
    private int schedulePk; // 예약 일정 PK
    private String reservationType; // 예약 구분 (개인/단체)
    private int programPk; // 프로그램 PK
    private int memberPk; // 등록자(사용자) PK
    
    private String memberName; // 회원 이름 (조인해서 가져옴)
    private Integer experiencePersonCount; // 체험 인원 수 (조인해서 가져옴)
    private int rowNum; // 번호
    private String reservationTypeName; // 공통코드랑 조인한 타입이름
    private String phoneNumber; // 관리자 예약검색에서 사용할 연락처 
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate date;   // 관리자 예약검색에서 사용할 날짜
    private String time; // 
    private String programName;
    
    
    // 게터세터
	public int getReservationPk() {
		return reservationPk;
	}
	public void setReservationPk(int reservationPk) {
		this.reservationPk = reservationPk;
	}
	public int getSchedulePk() {
		return schedulePk;
	}
	public void setSchedulePk(int schedulePk) {
		this.schedulePk = schedulePk;
	}
	public String getReservationType() {
		return reservationType;
	}
	public void setReservationType(String reservationType) {
		this.reservationType = reservationType;
	}
	public int getProgramPk() {
		return programPk;
	}
	public void setProgramPk(int programPk) {
		this.programPk = programPk;
	}
	public int getMemberPk() {
		return memberPk;
	}
	public void setMemberPk(int memberPk) {
		this.memberPk = memberPk;
	}
	public String getMemberName() {
		return memberName;
	}
	public void setMemberName(String memberName) {
		this.memberName = memberName;
	}
	public Integer getExperiencePersonCount() {
		return experiencePersonCount;
	}
	public void setExperiencePersonCount(Integer experiencePersonCount) {
		this.experiencePersonCount = experiencePersonCount;
	}
	public int getRowNum() {
		return rowNum;
	}
	public void setRowNum(int rowNum) {
		this.rowNum = rowNum;
	}
	public String getReservationTypeName() {
		return reservationTypeName;
	}
	public void setReservationTypeName(String reservationTypeName) {
		this.reservationTypeName = reservationTypeName;
	}
	public String getPhoneNumber() {
		return phoneNumber;
	}
	public void setPhoneNumber(String phoneNumber) {
		this.phoneNumber = phoneNumber;
	}
	public LocalDate getDate() {
		return date;
	}
	public void setDate(LocalDate date) {
		this.date = date;
	}
	public String getTime() {
		return time;
	}
	public void setTime(String time) {
		this.time = time;
	}
	public String getProgramName() {
		return programName;
	}
	public void setProgramName(String programName) {
		this.programName = programName;
	}

}
