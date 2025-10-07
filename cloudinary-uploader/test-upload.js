#!/usr/bin/env node

/**
 * Cloudinary 업로더 테스트 스크립트
 */

require('dotenv').config();
const { uploadFile, uploadMultiple, uploadDirectory } = require('./uploader');

// 환경 변수 확인
function checkConfig() {
  const required = ['CLOUDINARY_CLOUD_NAME', 'CLOUDINARY_API_KEY', 'CLOUDINARY_API_SECRET'];
  const missing = required.filter(key => !process.env[key]);

  if (missing.length > 0) {
    console.error('❌ 환경 변수 설정이 필요합니다:');
    missing.forEach(key => console.error(`   - ${key}`));
    console.error('\n.env 파일을 생성하고 위 값들을 설정해주세요.');
    console.error('(.env.example 파일을 참고하세요)\n');
    process.exit(1);
  }

  console.log('✅ Cloudinary 설정 확인 완료\n');
}

// 테스트 실행
async function runTests() {
  checkConfig();

  console.log('🧪 Cloudinary 업로더 테스트\n');
  console.log('테스트 파일을 준비해주세요:\n');
  console.log('예제:');
  console.log('  mkdir -p test-files');
  console.log('  echo "test" > test-files/test.txt');
  console.log('  node uploader.js test-files\n');
}

if (require.main === module) {
  runTests();
}
