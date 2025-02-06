package egovframework.vo;

public class CommonCodeVO {
	private String codeGroup;    // 코드 그룹
    private String codeValue;    // 코드 값
    private String codeName;     // 코드 이름
    private String description;  // 코드 설명
	
    
    // 게터 세터
    public String getCodeGroup() {
		return codeGroup;
	}
	public void setCodeGroup(String codeGroup) {
		this.codeGroup = codeGroup;
	}
	public String getCodeValue() {
		return codeValue;
	}
	public void setCodeValue(String codeValue) {
		this.codeValue = codeValue;
	}
	public String getCodeName() {
		return codeName;
	}
	public void setCodeName(String codeName) {
		this.codeName = codeName;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
    
}
