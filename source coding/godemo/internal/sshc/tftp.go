package sshc

import (
	"fmt"
	"io"
	"os"
	"path/filepath"

	"godemo/internal/constants"
)

// 获取TFTP共享目录完整路径
func getTFTPSharedPath() string {
	return filepath.Join(constants.SharedDir, constants.TFTPDir)
}

// UploadFileToTFTP 上传文件到共享TFTP目录
func UploadFileToTFTP(localPath, remoteFileName string) error {
	sharedPath := getTFTPSharedPath()
	destPath := filepath.Join(sharedPath, remoteFileName)

	srcFile, err := os.Open(localPath)
	if err != nil {
		return fmt.Errorf("open local file failed: %w", err)
	}
	defer srcFile.Close()

	dstFile, err := os.Create(destPath)
	if err != nil {
		return fmt.Errorf("create destination file failed: %w", err)
	}
	defer dstFile.Close()

	_, err = io.Copy(dstFile, srcFile)
	if err != nil {
		return fmt.Errorf("copy file failed: %w", err)
	}

	return nil
}

// DownloadFileFromTFTP 下载文件从共享TFTP目录
func DownloadFileFromTFTP(remoteFileName, localPath string) error {
	sharedPath := getTFTPSharedPath()
	srcPath := filepath.Join(sharedPath, remoteFileName)

	srcFile, err := os.Open(srcPath)
	if err != nil {
		return fmt.Errorf("open remote file failed: %w", err)
	}
	defer srcFile.Close()

	dstFile, err := os.Create(localPath)
	if err != nil {
		return fmt.Errorf("create local file failed: %w", err)
	}
	defer dstFile.Close()

	_, err = io.Copy(dstFile, srcFile)
	if err != nil {
		return fmt.Errorf("copy file failed: %w", err)
	}

	return nil
}
