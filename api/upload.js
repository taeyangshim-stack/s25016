/**
 * Vercel 서버리스 함수: Cloudinary 파일 업로드
 *
 * 엔드포인트: /api/upload
 */

const cloudinary = require('cloudinary').v2;
const { formidable } = require('formidable');

// Cloudinary 설정
cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET
});

// formidable 파서
const parseForm = (req) => {
  return new Promise((resolve, reject) => {
    const form = formidable({ multiples: false });

    form.parse(req, (err, fields, files) => {
      if (err) reject(err);
      resolve({ fields, files });
    });
  });
};

// 파일을 Buffer로 읽기
const fileToBuffer = (filePath) => {
  return new Promise((resolve, reject) => {
    const fs = require('fs');
    fs.readFile(filePath, (err, data) => {
      if (err) reject(err);
      resolve(data);
    });
  });
};

module.exports = async (req, res) => {
  // CORS 헤더
  res.setHeader('Access-Control-Allow-Credentials', true);
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET,OPTIONS,PATCH,DELETE,POST,PUT');
  res.setHeader('Access-Control-Allow-Headers', 'X-CSRF-Token, X-Requested-With, Accept, Accept-Version, Content-Length, Content-MD5, Content-Type, Date, X-Api-Version');

  // OPTIONS 요청 처리
  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }

  // POST 요청만 허용
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  try {
    // 폼 데이터 파싱
    const { fields, files } = await parseForm(req);

    if (!files.file) {
      return res.status(400).json({ error: '파일이 없습니다.' });
    }

    const file = files.file;
    const folder = fields.folder || process.env.CLOUDINARY_UPLOAD_FOLDER || 's25016';

    // 파일을 Buffer로 읽기
    const buffer = await fileToBuffer(file.filepath);

    // Base64로 변환
    const b64 = buffer.toString('base64');
    const dataURI = `data:${file.mimetype};base64,${b64}`;

    // Cloudinary에 업로드
    const result = await cloudinary.uploader.upload(dataURI, {
      folder: folder,
      use_filename: true,
      unique_filename: false,
      overwrite: true,
      resource_type: 'auto'
    });

    // 성공 응답
    res.status(200).json({
      success: true,
      file: file.originalFilename,
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
};
