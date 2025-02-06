package egovframework.vo;

public class ExperiencePersonVO {
	private int experiencePersonPk; // 체험 인원 PK
    private int reservationPk; // 예약 내역 PK
    private String name; // 이름
    private String gender; // 성별
    private String targetType; // 대상 구분
    private String residence; // 거주지
    private String detailedAddress; // 상세주소
    private boolean isDisabled; // 장애 여부
    private boolean isForeigner; // 외국인 여부
    private int programPk; // 프로그램 PK
    
    private String targetTypeName; // 대상 구분 이름
	
    // 게터세터
    public int getExperiencePersonPk() {
		return experiencePersonPk;
	}
	public void setExperiencePersonPk(int experiencePersonPk) {
		this.experiencePersonPk = experiencePersonPk;
	}
	public int getReservationPk() {
		return reservationPk;
	}
	public void setReservationPk(int reservationPk) {
		this.reservationPk = reservationPk;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getGender() {
		return gender;
	}
	public void setGender(String gender) {
		this.gender = gender;
	}
	public String getTargetType() {
		return targetType;
	}
	public void setTargetType(String targetType) {
		this.targetType = targetType;
	}
	public String getResidence() {
		return residence;
	}
	public void setResidence(String residence) {
		this.residence = residence;
	}
	public String getDetailedAddress() {
		return detailedAddress;
	}
	public void setDetailedAddress(String detailedAddress) {
		this.detailedAddress = detailedAddress;
	}
	public boolean isDisabled() {
		return isDisabled;
	}
	public void setDisabled(boolean isDisabled) {
		this.isDisabled = isDisabled;
	}
	public boolean isForeigner() {
		return isForeigner;
	}
	public void setForeigner(boolean isForeigner) {
		this.isForeigner = isForeigner;
	}
	public int getProgramPk() {
		return programPk;
	}
	public void setProgramPk(int programPk) {
		this.programPk = programPk;
	}
	public String getTargetTypeName() {
		return targetTypeName;
	}
	public void setTargetTypeName(String targetTypeName) {
		this.targetTypeName = targetTypeName;
	}
	@Override
	public String toString() {
		return "ExperiencePersonVO [experiencePersonPk=" + experiencePersonPk + ", reservationPk=" + reservationPk
				+ ", name=" + name + ", gender=" + gender + ", targetType=" + targetType + ", residence=" + residence
				+ ", detailedAddress=" + detailedAddress + ", isDisabled=" + isDisabled + ", isForeigner=" + isForeigner
				+ ", programPk=" + programPk + "]";
	}
    
}
