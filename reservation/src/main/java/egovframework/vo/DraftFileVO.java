package egovframework.vo;


public class DraftFileVO {
	private int filePk;               // 파일 PK
    private int draftDocumentPk;      // 기안문 PK
    private String fileName;          // 파일 이름
    private String uuid;              // UUID
    private String filePath;          // 파일 경로
    private long fileSize;             // 파일 크기
	
    // 게터 세터
    public int getFilePk() {
		return filePk;
	}
	public void setFilePk(int filePk) {
		this.filePk = filePk;
	}
	public int getDraftDocumentPk() {
		return draftDocumentPk;
	}
	public void setDraftDocumentPk(int draftDocumentPk) {
		this.draftDocumentPk = draftDocumentPk;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public String getUuid() {
		return uuid;
	}
	public void setUuid(String uuid) {
		this.uuid = uuid;
	}
	public String getFilePath() {
		return filePath;
	}
	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}
	public long getFileSize() {
		return fileSize;
	}
	public void setFileSize(long fileSize) {
		this.fileSize = fileSize;
	}
    
}
