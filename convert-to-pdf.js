const puppeteer = require('puppeteer');
const path = require('path');

(async () => {
  console.log('Starting PDF conversion...');

  const browser = await puppeteer.launch({
    headless: 'new',
    args: ['--no-sandbox', '--disable-setuid-sandbox']
  });

  const page = await browser.newPage();

  // HTML 파일 경로
  const htmlPath = 'file://' + path.resolve(__dirname, 'abb_spec_detailed.html');
  console.log('Loading HTML file:', htmlPath);

  // HTML 파일 로드
  await page.goto(htmlPath, {
    waitUntil: 'networkidle0',
    timeout: 60000
  });

  // PDF 저장 경로
  const pdfPath = path.resolve(__dirname, 'abb_spec_detailed.pdf');

  console.log('Generating PDF...');

  // PDF 생성
  await page.pdf({
    path: pdfPath,
    format: 'A4',
    printBackground: true,
    margin: {
      top: '20mm',
      right: '15mm',
      bottom: '20mm',
      left: '15mm'
    },
    displayHeaderFooter: true,
    headerTemplate: '<div></div>',
    footerTemplate: `
      <div style="width: 100%; font-size: 9px; padding: 5px; text-align: center; color: #666;">
        <span class="pageNumber"></span> / <span class="totalPages"></span>
      </div>
    `
  });

  console.log('PDF created successfully:', pdfPath);

  await browser.close();

  console.log('✅ Conversion complete!');
})();
