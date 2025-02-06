package egovframework.vo;

import java.time.LocalDate;

import org.springframework.format.annotation.DateTimeFormat;

public class ScheduleVO {
    private int schedulePk;   // 예약일정 PK
    private int programPk;    // 프로그램 PK
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate date;   // 날짜
    private String time;      // 시간
    private int maxCapacity;  // 최대 인원 수
    private int memberPk;     // 등록자 PK
    
    private String programName; // 프로그램 이름
    // 예약자(예약건) 수 필드 추가
    private int reservationCount;
    // 체험인원 수 필드 추가
    private int experiencePersonCount;
    // 기안문 존재 여부
    private boolean hasDraft; 

    // Getters and Setters
    public int getSchedulePk() {
        return schedulePk;
    }

    public void setSchedulePk(int schedulePk) {
        this.schedulePk = schedulePk;
    }

    public int getProgramPk() {
        return programPk;
    }

    public void setProgramPk(int programPk) {
        this.programPk = programPk;
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
    
    public String getProgramName() {
        return programName;
    }

    public void setProgramName(String programName) {
        this.programName = programName;
    }

	public int getReservationCount() {
		return reservationCount;
	}

	public void setReservationCount(int reservationCount) {
		this.reservationCount = reservationCount;
	}

	public int getExperiencePersonCount() {
		return experiencePersonCount;
	}

	public void setExperiencePersonCount(int experiencePersonCount) {
		this.experiencePersonCount = experiencePersonCount;
	}

	public boolean isHasDraft() {
		return hasDraft;
	}

	public void setHasDraft(boolean hasDraft) {
		this.hasDraft = hasDraft;
	}
}
