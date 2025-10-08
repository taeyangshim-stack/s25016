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

// 파일 처리
function handleFiles(files) {
    selectedFiles = files;
    files.forEach(file => {
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
                state.preview = e.target.result;
                renderPreviews();
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
    fileCountDisplay.value = `${selectedFiles.length}개`;

    const totalBytes = selectedFiles.reduce((sum, file) => sum + file.size, 0);
    const totalMB = (totalBytes / 1024 / 1024).toFixed(2);
    totalSizeEl.textContent = `${totalMB} MB`;
}

// 미리보기 렌더링
function renderPreviews() {
    if (selectedFiles.length === 0) {
        previewGrid.innerHTML = '<p style="grid-column: 1/-1; text-align: center; color: #7f8c8d; padding: 40px;">파일을 선택해주세요</p>';
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
    card.id = `card-${encodeURIComponent(file.name)}`;

    const isImage = file.type.startsWith('image/');
    const fileIcon = getFileIcon(file.name);

    let imageContent = '';
    if (isImage && state.preview) {
        imageContent = `<img src="${state.preview}" alt="${file.name}">`;
    } else if (isImage) {
        imageContent = '<div>🖼️</div>';
    } else {
        imageContent = `<div>${fileIcon}</div>`;
    }

    card.innerHTML = `
        <div class="preview-image">
            ${imageContent}
        </div>
        <div class="preview-info">
            <span class="status-badge status-${state.status}">${getStatusText(state.status)}</span>
            <div class="preview-name">${file.name}</div>
            <div class="preview-size">${(file.size / 1024).toFixed(2)} KB</div>
            ${state.url ? `
                <div class="preview-url" title="${state.url}">${state.url}</div>
                <div class="preview-actions">
                    <button class="btn-small" onclick="copyUrl('${encodeURIComponent(file.name)}')">📋 복사</button>
                    <button class="btn-small" onclick="openUrl('${state.url}')">🔗 열기</button>
                </div>
            ` : ''}
            ${state.error ? `<div style="color: #e74c3c; font-size: 0.9em; margin-top: 10px;">❌ ${state.error}</div>` : ''}
        </div>
    `;

    return card;
}

// 파일 아이콘
function getFileIcon(filename) {
    const ext = filename.split('.').pop().toLowerCase();
    const icons = {
        'jpg': '🖼️', 'jpeg': '🖼️', 'png': '🖼️', 'gif': '🖼️', 'webp': '🖼️',
        'pdf': '📄', 'doc': '📝', 'docx': '📝', 'txt': '📝',
        'html': '🌐', 'css': '🎨', 'js': '⚙️',
        'zip': '📦', 'rar': '📦'
    };
    return icons[ext] || '📄';
}

// 상태 텍스트
function getStatusText(status) {
    const texts = {
        'pending': '⏳ 대기',
        'uploading': '📤 업로드 중',
        'success': '✅ 완료',
        'error': '❌ 실패'
    };
    return texts[status] || status;
}

// 카드 상태 업데이트
function updateCardState(filename, updates) {
    const state = fileStates.get(filename);
    Object.assign(state, updates);

    const card = document.getElementById(`card-${encodeURIComponent(filename)}`);
    if (card) {
        const newCard = createPreviewCard(state.file, state);
        card.replaceWith(newCard);
    }
}

// URL 복사
window.copyUrl = function(encodedFilename) {
    const filename = decodeURIComponent(encodedFilename);
    const state = fileStates.get(filename);
    if (state && state.url) {
        navigator.clipboard.writeText(state.url).then(() => {
            showToast('📋 URL이 복사되었습니다!');
        }).catch(err => {
            showToast('❌ 복사 실패: ' + err.message, 'error');
        });
    }
};

// URL 열기
window.openUrl = function(url) {
    window.open(url, '_blank');
};

// Toast 표시
function showToast(message, type = 'success') {
    toast.textContent = message;
    toast.style.background = type === 'error' ? '#e74c3c' : '#27ae60';
    toast.classList.add('show');
    setTimeout(() => {
        toast.classList.remove('show');
    }, 3000);
}

// 업로드 버튼
uploadBtn.addEventListener('click', async () => {
    if (selectedFiles.length === 0) return;

    uploadBtn.disabled = true;
    clearBtn.disabled = true;
    progressSection.classList.add('active');

    let uploaded = 0;
    let failed = 0;

    for (let i = 0; i < selectedFiles.length; i++) {
        const file = selectedFiles[i];
        const progress = ((i + 1) / selectedFiles.length * 100).toFixed(0);

        progressFill.style.width = `${progress}%`;
        progressFill.textContent = `${progress}%`;

        updateCardState(file.name, { status: 'uploading' });

        try {
            const result = await uploadToCloudinary(file);
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

    showToast(`✅ 업로드 완료! (성공: ${uploaded}, 실패: ${failed})`);
    uploadBtn.disabled = false;
    clearBtn.disabled = false;
});

// Cloudinary 업로드 (Vercel serverless function)
async function uploadToCloudinary(file) {
    const formData = new FormData();
    formData.append('file', file);
    formData.append('folder', folderInput.value);

    const response = await fetch('/api/upload', {
        method: 'POST',
        body: formData
    });

    if (!response.ok) {
        const errorText = await response.text();
        throw new Error(`HTTP ${response.status}: ${errorText}`);
    }

    const result = await response.json();

    if (!result.success) {
        throw new Error(result.error || '업로드 실패');
    }

    return {
        secure_url: result.url,
        public_id: result.public_id
    };
}

// 초기화
clearBtn.addEventListener('click', () => {
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
    progressFill.textContent = '0%';
});
