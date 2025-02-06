package egovframework.service;

import java.io.IOException;

import org.springframework.core.io.Resource;
import org.springframework.web.multipart.MultipartFile;

public interface FileStorageService {
	// 파일 저장
	String saveFile(MultipartFile file, String uuid) throws IOException;
	// 파일 로드
    Resource loadFile(String filePath) throws IOException; 
}
