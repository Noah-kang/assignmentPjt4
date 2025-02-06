package egovframework.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import egovframework.vo.DraftFileVO;

@Mapper
public interface DraftFileMapper {
	// 첨부파일 PK 생성
	int getNextFilePk();
	// 첨부파일 저장
    void insertDraftFile(DraftFileVO draftFileVO);
    // 기안문Pk로 첨부파일들 가져오기
    List<DraftFileVO> getAttachedFilesByDraftPk(int draftDocumentPk);
    // 파일Pk로 첨부파일 정보 가져오기(다운로드용)
    DraftFileVO getFileByPk(int filePk);
}
