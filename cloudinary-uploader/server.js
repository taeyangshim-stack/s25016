#!/usr/bin/env node

/**
 * Cloudinary 업로드 서버
 * 대시보드와 연동하여 실제 파일 업로드 처리
 */

require('dotenv').config();
const express = require('express');
const multer = require('multer');
const cloudinary = require('cloudinary').v2;
const cors = require('cors');
const path = require('path');

// Cloudinary 설정
cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET
});

// Express 앱 설정
const app = express();
const PORT = process.env.PORT || 3000;

// 미들웨어
app.use(cors());
app.use(express.json());
app.use(express.static(__dirname));

// Multer 설정 (메모리 스토리지)
const storage = multer.memoryStorage();
const upload = multer({
  storage: storage,
  limits: {
    fileSize: 10 * 1024 * 1024 // 10MB 제한
  }
});

// 대시보드 페이지
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'dashboard.html'));
});

// 단일 파일 업로드
app.post('/upload', upload.single('file'), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: '파일이 없습니다.' });
    }

    const folder = req.body.folder || process.env.CLOUDINARY_UPLOAD_FOLDER || 's25016';

    // Buffer를 base64로 변환하여 업로드
    const b64 = Buffer.from(req.file.buffer).toString('base64');
    const dataURI = `data:${req.file.mimetype};base64,${b64}`;

    const result = await cloudinary.uploader.upload(dataURI, {
      folder: folder,
      use_filename: true,
      unique_filename: false,
      overwrite: true,
      resource_type: 'auto'
    });

    res.json({
      success: true,
      file: req.file.originalname,
      url: result.secure_url,
      public_id: result.public_id,
      format: result.format,
      bytes: result.bytes
    });

  } catch (error) {
    console.error('업로드 오류:', error);
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

// 다중 파일 업로드
app.post('/upload-multiple', upload.array('files', 50), async (req, res) => {
  try {
    if (!req.files || req.files.length === 0) {
      return res.status(400).json({ error: '파일이 없습니다.' });
    }

    const folder = req.body.folder || process.env.CLOUDINARY_UPLOAD_FOLDER || 's25016';
    const results = [];

    for (const file of req.files) {
      try {
        const b64 = Buffer.from(file.buffer).toString('base64');
        const dataURI = `data:${file.mimetype};base64,${b64}`;

        const result = await cloudinary.uploader.upload(dataURI, {
          folder: folder,
          use_filename: true,
          unique_filename: false,
          overwrite: true,
          resource_type: 'auto'
        });

        results.push({
          success: true,
          file: file.originalname,
          url: result.secure_url,
          public_id: result.public_id
        });

      } catch (error) {
        results.push({
          success: false,
          file: file.originalname,
          error: error.message
        });
      }
    }

    const successCount = results.filter(r => r.success).length;
    const failCount = results.filter(r => !r.success).length;

    res.json({
      total: results.length,
      success: successCount,
      failed: failCount,
      results: results
    });

  } catch (error) {
    console.error('업로드 오류:', error);
    res.status(500).json({
      error: error.message
    });
  }
});

// 업로드된 파일 목록 조회
app.get('/files', async (req, res) => {
  try {
    const folder = req.query.folder || process.env.CLOUDINARY_UPLOAD_FOLDER || 's25016';

    const result = await cloudinary.api.resources({
      type: 'upload',
      prefix: folder,
      max_results: 500
    });

    res.json({
      total: result.resources.length,
      files: result.resources.map(r => ({
        public_id: r.public_id,
        url: r.secure_url,
        format: r.format,
        bytes: r.bytes,
        created_at: r.created_at
      }))
    });

  } catch (error) {
    console.error('파일 목록 조회 오류:', error);
    res.status(500).json({
      error: error.message
    });
  }
});

// 폴더 목록 조회
app.get('/folders', async (req, res) => {
  try {
    const result = await cloudinary.api.root_folders();

    res.json({
      folders: result.folders.map(f => f.name)
    });

  } catch (error) {
    console.error('폴더 목록 조회 오류:', error);
    res.status(500).json({
      error: error.message
    });
  }
});

// 파일 삭제
app.delete('/delete/:public_id', async (req, res) => {
  try {
    const publicId = req.params.public_id.replace(/-/g, '/');

    const result = await cloudinary.uploader.destroy(publicId);

    res.json({
      success: result.result === 'ok',
      message: result.result
    });

  } catch (error) {
    console.error('파일 삭제 오류:', error);
    res.status(500).json({
      error: error.message
    });
  }
});

// 서버 시작
app.listen(PORT, () => {
  console.log(`\n🚀 Cloudinary 업로드 서버 실행 중!`);
  console.log(`   📡 주소: http://localhost:${PORT}`);
  console.log(`   ☁️  Cloudinary: ${process.env.CLOUDINARY_CLOUD_NAME}`);
  console.log(`   📁 기본 폴더: ${process.env.CLOUDINARY_UPLOAD_FOLDER || 's25016'}`);
  console.log(`\n브라우저에서 http://localhost:${PORT} 를 열어주세요.\n`);
});
