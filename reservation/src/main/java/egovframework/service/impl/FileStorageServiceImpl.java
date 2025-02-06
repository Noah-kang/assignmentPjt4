package egovframework.service.impl;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import egovframework.service.FileStorageService;

@Service
public class FileStorageServiceImpl implements FileStorageService {

	private final String UPLOAD_DIR = "C:\\Users\\winitech\\Desktop\\draftfile"; // 파일 저장 경로

    @Override
    public String saveFile(MultipartFile file, String uuid) throws IOException {
        // 디렉토리 생성
        Path uploadPath = Paths.get(UPLOAD_DIR);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        // 파일 확장자 추출
        String originalFileName = file.getOriginalFilename();
        String fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));

        // UUID 기반 고유 파일명 생성
        String uniqueFileName = uuid + fileExtension;

        // 파일 저장
        Path filePath = uploadPath.resolve(uniqueFileName);
        file.transferTo(filePath.toFile());

        // 저장된 파일 경로 반환
        return filePath.toString();
    }

    @Override
    public Resource loadFile(String filePath) throws IOException {
        Path path = Paths.get(filePath);
        if (!Files.exists(path)) {
            throw new IOException("파일을 찾을 수 없습니다: " + filePath);
        }
        return new UrlResource(path.toUri());
    }
}
