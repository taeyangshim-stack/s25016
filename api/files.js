/**
 * Vercel 서버리스 함수: 업로드된 파일 목록 조회
 *
 * 엔드포인트: /api/files?folder=s25016
 */

const cloudinary = require('cloudinary').v2;

// Cloudinary 설정
cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET
});

module.exports = async (req, res) => {
  // CORS 헤더
  res.setHeader('Access-Control-Allow-Credentials', true);
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET,OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'X-CSRF-Token, X-Requested-With, Accept, Accept-Version, Content-Length, Content-MD5, Content-Type, Date, X-Api-Version');

  // OPTIONS 요청 처리
  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }

  // GET 요청만 허용
  if (req.method !== 'GET') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  try {
    const { folder } = req.query;
    const targetFolder = folder || process.env.CLOUDINARY_UPLOAD_FOLDER || 's25016';

    // Cloudinary에서 파일 목록 조회
    const result = await cloudinary.api.resources({
      type: 'upload',
      prefix: targetFolder,
      max_results: 500
    });

    res.status(200).json({
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
};
