#!/usr/bin/env node

require('dotenv').config();
const cloudinary = require('cloudinary');
const fs = require('fs');
const path = require('path');

// Cloudinary 설정
cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET
});

/**
 * 단일 파일 업로드
 * @param {string} filePath - 업로드할 파일 경로
 * @param {object} options - 업로드 옵션
 * @returns {Promise<object>} - 업로드 결과
 */
async function uploadFile(filePath, options = {}) {
  try {
    const defaultOptions = {
      folder: process.env.CLOUDINARY_UPLOAD_FOLDER || 's25016',
      use_filename: true,
      unique_filename: false,
      overwrite: true,
      ...options
    };

    console.log(`📤 업로드 중: ${filePath}`);
    const result = await cloudinary.uploader.upload(filePath, defaultOptions);

    console.log(`✅ 성공: ${path.basename(filePath)}`);
    console.log(`   URL: ${result.secure_url}`);

    return {
      success: true,
      file: filePath,
      url: result.secure_url,
      public_id: result.public_id
    };
  } catch (error) {
    console.error(`❌ 실패: ${filePath}`);
    console.error(`   오류: ${error.message}`);

    return {
      success: false,
      file: filePath,
      error: error.message
    };
  }
}

/**
 * 다중 파일 업로드
 * @param {string[]} filePaths - 업로드할 파일 경로 배열
 * @param {object} options - 업로드 옵션
 * @returns {Promise<object[]>} - 업로드 결과 배열
 */
async function uploadMultiple(filePaths, options = {}) {
  console.log(`\n🚀 총 ${filePaths.length}개 파일 업로드 시작...\n`);

  const results = [];

  for (const filePath of filePaths) {
    const result = await uploadFile(filePath, options);
    results.push(result);
  }

  // 결과 요약
  const successCount = results.filter(r => r.success).length;
  const failCount = results.filter(r => !r.success).length;

  console.log(`\n📊 업로드 완료!`);
  console.log(`   ✅ 성공: ${successCount}개`);
  console.log(`   ❌ 실패: ${failCount}개`);

  return results;
}

/**
 * 디렉토리 내 모든 파일 업로드
 * @param {string} dirPath - 디렉토리 경로
 * @param {object} options - 업로드 옵션
 * @param {string[]} extensions - 허용할 파일 확장자 (기본: 모든 파일)
 * @returns {Promise<object[]>} - 업로드 결과 배열
 */
async function uploadDirectory(dirPath, options = {}, extensions = null) {
  if (!fs.existsSync(dirPath)) {
    console.error(`❌ 디렉토리를 찾을 수 없습니다: ${dirPath}`);
    return [];
  }

  const files = fs.readdirSync(dirPath);
  const filePaths = files
    .map(file => path.join(dirPath, file))
    .filter(filePath => {
      const stat = fs.statSync(filePath);
      if (!stat.isFile()) return false;

      if (extensions && extensions.length > 0) {
        const ext = path.extname(filePath).toLowerCase();
        return extensions.includes(ext);
      }

      return true;
    });

  if (filePaths.length === 0) {
    console.log(`⚠️  업로드할 파일이 없습니다.`);
    return [];
  }

  return uploadMultiple(filePaths, options);
}

/**
 * 업로드 결과를 JSON 파일로 저장
 * @param {object[]} results - 업로드 결과 배열
 * @param {string} outputPath - 출력 파일 경로
 */
function saveResults(results, outputPath = './upload-results.json') {
  const data = {
    timestamp: new Date().toISOString(),
    total: results.length,
    success: results.filter(r => r.success).length,
    failed: results.filter(r => !r.success).length,
    results: results
  };

  fs.writeFileSync(outputPath, JSON.stringify(data, null, 2), 'utf-8');
  console.log(`\n💾 결과 저장: ${outputPath}`);
}

/**
 * URL 목록을 텍스트 파일로 저장 (복사하기 쉽게)
 * @param {object[]} results - 업로드 결과 배열
 * @param {string} outputPath - 출력 파일 경로
 */
function saveUrls(results, outputPath = './upload-urls.txt') {
  const successResults = results.filter(r => r.success);

  if (successResults.length === 0) {
    console.log('\n⚠️  저장할 URL이 없습니다.');
    return;
  }

  // URL만 추출하여 텍스트로 저장
  const urlList = successResults.map(r => r.url).join('\n');
  fs.writeFileSync(outputPath, urlList, 'utf-8');

  console.log(`\n🔗 URL 목록 저장: ${outputPath}`);
  console.log(`   📋 ${successResults.length}개 URL 저장됨`);

  // 마크다운 형식으로도 저장
  const mdPath = outputPath.replace('.txt', '.md');
  const mdContent = successResults
    .map((r, idx) => {
      const fileName = path.basename(r.file);
      return `${idx + 1}. [${fileName}](${r.url})`;
    })
    .join('\n');

  const mdFull = `# 업로드된 파일 목록\n\n업로드 일시: ${new Date().toLocaleString('ko-KR')}\n\n${mdContent}\n`;
  fs.writeFileSync(mdPath, mdFull, 'utf-8');
  console.log(`   📄 마크다운 저장: ${mdPath}`);
}

/**
 * 클립보드에 URL 복사 (Linux의 경우 xclip 필요)
 * @param {string[]} urls - URL 배열
 */
function copyToClipboard(urls) {
  if (urls.length === 0) return;

  const urlText = urls.join('\n');

  try {
    // xclip 사용 (Linux)
    const { execSync } = require('child_process');
    execSync('command -v xclip', { stdio: 'ignore' });

    const proc = require('child_process').spawn('xclip', ['-selection', 'clipboard']);
    proc.stdin.write(urlText);
    proc.stdin.end();

    console.log('\n📋 클립보드에 URL 복사 완료!');
  } catch (error) {
    console.log('\n💡 클립보드 복사 실패 (xclip 설치 필요)');
    console.log('   sudo apt-get install xclip');
  }
}

// CLI 실행 시
if (require.main === module) {
  const args = process.argv.slice(2);

  if (args.length === 0) {
    console.log(`
사용법:
  node uploader.js <파일1> <파일2> ...          # 개별 파일 업로드
  node uploader.js <디렉토리>                   # 디렉토리 전체 업로드

옵션:
  --folder=<폴더명>         # Cloudinary 폴더 지정
  --ext=<확장자>            # 특정 확장자만 업로드 (예: --ext=.jpg,.png)
  --save=<결과파일>         # 결과를 JSON으로 저장
  --urls                    # URL 목록을 텍스트/마크다운으로 저장
  --copy                    # URL을 클립보드에 복사

예제:
  node uploader.js image1.jpg image2.png
  node uploader.js ./images --folder=project/photos
  node uploader.js ./docs --ext=.pdf,.docx --save=results.json
  node uploader.js ./photos --folder=gallery --urls --copy
    `);
    process.exit(0);
  }

  // 옵션 파싱
  const options = {};
  let extensions = null;
  let saveResultsPath = null;
  let saveUrlsFlag = false;
  let copyFlag = false;
  const filePaths = [];

  args.forEach(arg => {
    if (arg.startsWith('--folder=')) {
      options.folder = arg.split('=')[1];
    } else if (arg.startsWith('--ext=')) {
      extensions = arg.split('=')[1].split(',');
    } else if (arg.startsWith('--save=')) {
      saveResultsPath = arg.split('=')[1];
    } else if (arg === '--urls') {
      saveUrlsFlag = true;
    } else if (arg === '--copy') {
      copyFlag = true;
    } else {
      filePaths.push(arg);
    }
  });

  // 업로드 실행
  (async () => {
    let results = [];

    if (filePaths.length === 1 && fs.statSync(filePaths[0]).isDirectory()) {
      // 디렉토리 업로드
      results = await uploadDirectory(filePaths[0], options, extensions);
    } else {
      // 개별 파일 업로드
      results = await uploadMultiple(filePaths, options);
    }

    // 결과 저장
    if (saveResultsPath) {
      saveResults(results, saveResultsPath);
    }

    // URL 목록 저장
    if (saveUrlsFlag) {
      saveUrls(results, './upload-urls.txt');
    }

    // 클립보드 복사
    if (copyFlag) {
      const urls = results.filter(r => r.success).map(r => r.url);
      copyToClipboard(urls);
    }
  })();
}

// 모듈로 export
module.exports = {
  uploadFile,
  uploadMultiple,
  uploadDirectory,
  saveResults,
  saveUrls,
  copyToClipboard
};
