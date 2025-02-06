package egovframework.vo;

public class ScheduleBulkVO {
    private int programPk;        // 프로그램 PK
    private String yearMonth;     // 예약 생성 대상 월 (yyyy-MM)
    private String time;          // 예약 시간
    private int maxCapacity;      // 제한 인원
    private int memberPk; 		  // 사용자Pk
	
    // 게터 세터
    public int getProgramPk() {
		return programPk;
	}
	public void setProgramPk(int programPk) {
		this.programPk = programPk;
	}
	public String getYearMonth() {
		return yearMonth;
	}
	public void setYearMonth(String yearMonth) {
		this.yearMonth = yearMonth;
	}
	public String getTime() {
		return time;
	}
	public void setTime(String time) {
		this.time = time;
	}
	public int getMaxCapacity() {
		return maxCapacity;
	}
	public void setMaxCapacity(int maxCapacity) {
		this.maxCapacity = maxCapacity;
	}
	public int getMemberPk() {
		return memberPk;
	}
	public void setMemberPk(int memberPk) {
		this.memberPk = memberPk;
	}


}
