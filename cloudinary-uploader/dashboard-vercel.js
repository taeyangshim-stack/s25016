// 상태 관리
let selectedFiles = [];
const fileStates = new Map();

// DOM 요소
const uploadArea = document.getElementById('uploadArea');
const fileInput = document.getElementById('fileInput');
const folderInput = document.getElementById('folderInput');
const uploadBtn = document.getElementById('uploadBtn');
const clearBtn = document.getElementById('clearBtn');
const previewGrid = document.getElementById('previewGrid');
const progressSection = document.getElementById('progressSection');
const progressFill = document.getElementById('progressFill');
const progressPct = document.getElementById('progressPct');
const fileCountDisplay = document.getElementById('fileCountDisplay');

// 통계 요소
const totalFilesEl = document.getElementById('totalFiles');
const uploadedFilesEl = document.getElementById('uploadedFiles');
const failedFilesEl = document.getElementById('failedFiles');
const totalSizeEl = document.getElementById('totalSize');
const toast = document.getElementById('toast');

// 클릭으로 파일 선택
uploadArea.addEventListener('click', () => fileInput.click());

// 파일 선택
fileInput.addEventListener('change', (e) => {
    handleFiles(Array.from(e.target.files));
});

// 드래그 앤 드롭
uploadArea.addEventListener('dragover', (e) => {
    e.preventDefault();
    uploadArea.classList.add('dragover');
});

uploadArea.addEventListener('dragleave', () => {
    uploadArea.classList.remove('dragover');
});

uploadArea.addEventListener('drop', (e) => {
    e.preventDefault();
    uploadArea.classList.remove('dragover');
    handleFiles(Array.from(e.dataTransfer.files));
});

// 클립보드 붙여넣기
document.addEventListener('paste', (e) => {
    const items = e.clipboardData && e.clipboardData.items;
    if (!items) return;

    const imageFiles = [];
    for (let i = 0; i < items.length; i++) {
        if (items[i].type.startsWith('image/')) {
            const blob = items[i].getAsFile();
            if (blob) {
                const now = new Date();
                const ts = now.getFullYear().toString() +
                    String(now.getMonth() + 1).padStart(2, '0') +
                    String(now.getDate()).padStart(2, '0') + '_' +
                    String(now.getHours()).padStart(2, '0') +
                    String(now.getMinutes()).padStart(2, '0') +
                    String(now.getSeconds()).padStart(2, '0');
                const ext = blob.type.split('/')[1] || 'png';
                const filename = 'clipboard_' + ts + '.' + ext;
                const file = new File([blob], filename, { type: blob.type });
                imageFiles.push(file);
            }
        }
    }

    if (imageFiles.length > 0) {
        e.preventDefault();
        handleFiles(imageFiles);

        // 시각 피드백
        uploadArea.classList.add('clipboard-flash');
        setTimeout(() => uploadArea.classList.remove('clipboard-flash'), 600);

        showToast('Clipboard image added');
    }
});

// 파일 처리 — 기존 목록에 추가 (덮어쓰기 아님)
function handleFiles(files) {
    files.forEach(file => {
        // 동일 파일명이 이미 있으면 건너뜀
        if (fileStates.has(file.name)) return;

        selectedFiles.push(file);
        fileStates.set(file.name, {
            file: file,
            status: 'pending',
            url: null,
            error: null,
            preview: null
        });

        // 이미지 미리보기 생성
        if (file.type.startsWith('image/')) {
            const reader = new FileReader();
            reader.onload = (e) => {
                const state = fileStates.get(file.name);
                if (state) {
                    state.preview = e.target.result;
                    renderPreviews();
                }
            };
            reader.readAsDataURL(file);
        }
    });
    updateStats();
    renderPreviews();
    uploadBtn.disabled = selectedFiles.length === 0;
}

// 통계 업데이트
function updateStats() {
    totalFilesEl.textContent = selectedFiles.length;
    fileCountDisplay.value = selectedFiles.length + ' files';

    const totalBytes = selectedFiles.reduce((sum, file) => sum + file.size, 0);
    const totalMB = (totalBytes / 1024 / 1024).toFixed(2);
    totalSizeEl.textContent = totalMB + ' MB';
}

// 미리보기 렌더링
function renderPreviews() {
    if (selectedFiles.length === 0) {
        previewGrid.innerHTML = '<div class="empty-state">Select files to preview</div>';
        return;
    }

    previewGrid.innerHTML = '';

    selectedFiles.forEach(file => {
        const state = fileStates.get(file.name);
        const card = createPreviewCard(file, state);
        previewGrid.appendChild(card);
    });
}

// 미리보기 카드 생성
function createPreviewCard(file, state) {
    const card = document.createElement('div');
    card.className = 'preview-card';
    card.id = 'card-' + encodeURIComponent(file.name);

    const isImage = file.type.startsWith('image/');
    const fileIcon = getFileIcon(file.name);

    let imageContent = '';
    if (isImage && state.preview) {
        imageContent = '<img src="' + state.preview + '" alt="' + file.name + '">';
    } else if (isImage) {
        imageContent = '<div>IMG</div>';
    } else {
        imageContent = '<div>' + fileIcon + '</div>';
    }

    card.innerHTML =
        '<div class="preview-image">' + imageContent + '</div>' +
        '<div class="preview-info">' +
            '<span class="status-badge status-' + state.status + '">' + getStatusText(state.status) + '</span>' +
            '<div class="preview-name">' + file.name + '</div>' +
            '<div class="preview-size">' + (file.size / 1024).toFixed(1) + ' KB</div>' +
            (state.url
                ? '<div class="preview-url" title="' + state.url + '">' + state.url + '</div>' +
                  '<div class="preview-actions">' +
                      '<button class="btn-small" onclick="copyUrl(\'' + encodeURIComponent(file.name) + '\')">Copy URL</button>' +
                      '<button class="btn-small" onclick="openUrl(\'' + state.url + '\')">Open</button>' +
                  '</div>'
                : '') +
            (state.error
                ? '<div style="color:var(--red);font-size:0.82em;margin-top:8px;">' + state.error + '</div>'
                : '') +
        '</div>';

    return card;
}

// 파일 아이콘
function getFileIcon(filename) {
    var ext = filename.split('.').pop().toLowerCase();
    var icons = {
        'jpg': 'JPG', 'jpeg': 'JPG', 'png': 'PNG', 'gif': 'GIF', 'webp': 'WEBP',
        'pdf': 'PDF', 'doc': 'DOC', 'docx': 'DOCX', 'txt': 'TXT',
        'html': 'HTML', 'css': 'CSS', 'js': 'JS',
        'zip': 'ZIP', 'rar': 'RAR'
    };
    return icons[ext] || 'FILE';
}

// 상태 텍스트
function getStatusText(status) {
    var texts = {
        'pending': 'Pending',
        'uploading': 'Uploading',
        'success': 'Done',
        'error': 'Failed'
    };
    return texts[status] || status;
}

// 카드 상태 업데이트
function updateCardState(filename, updates) {
    var state = fileStates.get(filename);
    Object.assign(state, updates);

    var card = document.getElementById('card-' + encodeURIComponent(filename));
    if (card) {
        var newCard = createPreviewCard(state.file, state);
        card.replaceWith(newCard);
    }
}

// URL 복사
window.copyUrl = function(encodedFilename) {
    var filename = decodeURIComponent(encodedFilename);
    var state = fileStates.get(filename);
    if (state && state.url) {
        navigator.clipboard.writeText(state.url).then(function() {
            showToast('URL copied');
        }).catch(function(err) {
            showToast('Copy failed: ' + err.message, 'error');
        });
    }
};

// URL 열기
window.openUrl = function(url) {
    window.open(url, '_blank');
};

// Toast 표시
function showToast(message, type) {
    type = type || 'success';
    toast.textContent = message;
    toast.style.background = type === 'error' ? 'var(--red)' : 'var(--green)';
    toast.classList.add('show');
    setTimeout(function() {
        toast.classList.remove('show');
    }, 3000);
}

// 업로드 버튼
uploadBtn.addEventListener('click', async function() {
    if (selectedFiles.length === 0) return;

    uploadBtn.disabled = true;
    clearBtn.disabled = true;
    progressSection.classList.add('active');

    var uploaded = 0;
    var failed = 0;

    for (var i = 0; i < selectedFiles.length; i++) {
        var file = selectedFiles[i];
        var progress = ((i + 1) / selectedFiles.length * 100).toFixed(0);

        progressFill.style.width = progress + '%';
        progressPct.textContent = progress + '%';

        updateCardState(file.name, { status: 'uploading' });

        try {
            var result = await uploadToCloudinary(file);
            uploaded++;
            updateCardState(file.name, {
                status: 'success',
                url: result.secure_url
            });
        } catch (error) {
            failed++;
            updateCardState(file.name, {
                status: 'error',
                error: error.message
            });
        }

        uploadedFilesEl.textContent = uploaded;
        failedFilesEl.textContent = failed;
    }

    showToast('Upload complete — ' + uploaded + ' success, ' + failed + ' failed');
    uploadBtn.disabled = false;
    clearBtn.disabled = false;
});

// Cloudinary 업로드 (로컬 또는 Vercel)
async function uploadToCloudinary(file) {
    var formData = new FormData();
    formData.append('file', file);
    formData.append('folder', folderInput.value);

    // 로컬 개발: http://localhost:3000/upload
    // Vercel 배포: /api/upload
    var uploadUrl = window.location.hostname === 'localhost'
        ? 'http://localhost:3000/upload'
        : '/api/upload';

    var response = await fetch(uploadUrl, {
        method: 'POST',
        body: formData
    });

    if (!response.ok) {
        var errorText = await response.text();
        throw new Error('HTTP ' + response.status + ': ' + errorText);
    }

    var resultData = await response.json();

    if (!resultData.success) {
        throw new Error(resultData.error || 'Upload failed');
    }

    return {
        secure_url: resultData.url,
        public_id: resultData.public_id
    };
}

// 초기화
clearBtn.addEventListener('click', function() {
    selectedFiles = [];
    fileStates.clear();
    fileInput.value = '';
    updateStats();
    renderPreviews();
    uploadBtn.disabled = true;
    progressSection.classList.remove('active');
    uploadedFilesEl.textContent = '0';
    failedFilesEl.textContent = '0';
    progressFill.style.width = '0%';
    progressPct.textContent = '0%';
});
