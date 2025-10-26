(function() {
  const state = {
    allIssues: [],
    filteredIssues: [],
    categoryMap: {},
    owners: [],
    currentWeekStart: getWeekStart(new Date()),
    filters: {
      search: '',
      category: 'all',
      subcategory: 'all',
      status: 'all',
      priority: 'all',
      owner: 'all',
      line: 'all'
    }
  };

  let searchDebounce = null;

  document.addEventListener('DOMContentLoaded', initSchedule);

  async function initSchedule() {
    if (!window.PunchListAPI) {
      console.error('PunchListAPI가 로드되지 않았습니다.');
      return;
    }

    toggleLoadingState(true);

    try {
      await Promise.all([
        PunchListAPI.ensureCategoriesLoaded(),
        PunchListAPI.ensureOwnersLoaded()
      ]);

      state.categoryMap = PunchListAPI.getCategoryMap();
      state.owners = PunchListAPI.getOwnerNames();

      populateFilterOptions();
      bindFilterEvents();
      bindWeekControls();

      state.allIssues = await PunchListAPI.loadAllIssues();
      state.filteredIssues = [...state.allIssues];

      applyFilters();
    } catch (error) {
      console.error('일정 데이터를 로드하지 못했습니다.', error);
      showMessage('ganttLoading', '데이터를 불러오지 못했습니다. 새로고침 후 다시 시도해주세요.');
      showMessage('weekLoading', '데이터를 불러오지 못했습니다.');
    } finally {
      toggleLoadingState(false);
    }
  }

  function toggleLoadingState(isLoading) {
    const ganttLoading = document.getElementById('ganttLoading');
    const weekLoading = document.getElementById('weekLoading');

    if (ganttLoading) {
      ganttLoading.classList.toggle('hidden', !isLoading);
    }

    if (weekLoading) {
      weekLoading.classList.toggle('hidden', !isLoading);
    }
  }

  function populateFilterOptions() {
    populateSelect('statusFilter', PunchListAPI.STATUSES);
    populateSelect('priorityFilter', PunchListAPI.PRIORITIES);
    populateSelect('ownerFilter', state.owners);
    populateSelect('lineFilter', PunchListAPI.LINE_TYPES);

    const categorySelect = document.getElementById('categoryFilter');
    Object.keys(state.categoryMap).forEach(category => {
      const option = document.createElement('option');
      option.value = category;
      option.textContent = category;
      categorySelect.appendChild(option);
    });

    updateSubcategoryOptions();
  }

  function populateSelect(selectId, values = []) {
    const select = document.getElementById(selectId);
    if (!select) return;

    const current = select.value;
    select.innerHTML = '<option value="all">전체</option>';

    values.forEach(value => {
      if (!value) return;
      const option = document.createElement('option');
      option.value = value;
      option.textContent = value;
      select.appendChild(option);
    });

    select.value = current || 'all';
  }

  function updateSubcategoryOptions() {
    const subcategorySelect = document.getElementById('subcategoryFilter');
    const categorySelect = document.getElementById('categoryFilter');
    if (!subcategorySelect || !categorySelect) return;

    const category = categorySelect.value;
    const subcategories = category !== 'all'
      ? state.categoryMap[category] || []
      : [];

    subcategorySelect.innerHTML = '<option value="all">전체</option>';
    subcategorySelect.disabled = category === 'all';

    subcategories.forEach(sub => {
      const option = document.createElement('option');
      option.value = sub;
      option.textContent = sub;
      subcategorySelect.appendChild(option);
    });

    if (category === 'all') {
      subcategorySelect.value = 'all';
      state.filters.subcategory = 'all';
    }
  }

  function bindFilterEvents() {
    const filterIds = [
      'categoryFilter',
      'subcategoryFilter',
      'statusFilter',
      'priorityFilter',
      'ownerFilter',
      'lineFilter'
    ];

    filterIds.forEach(id => {
      const el = document.getElementById(id);
      if (!el) return;

      el.addEventListener('change', () => {
        if (id === 'categoryFilter') {
          updateSubcategoryOptions();
        }
        state.filters[id.replace('Filter', '')] = el.value;
        applyFilters();
      });
    });

    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
      searchInput.addEventListener('input', event => {
        const value = event.target.value.trim();
        if (searchDebounce) {
          clearTimeout(searchDebounce);
        }
        searchDebounce = setTimeout(() => {
          state.filters.search = value;
          applyFilters();
        }, 250);
      });
    }

    const resetBtn = document.getElementById('resetFilters');
    if (resetBtn) {
      resetBtn.addEventListener('click', () => {
        state.filters = {
          search: '',
          category: 'all',
          subcategory: 'all',
          status: 'all',
          priority: 'all',
          owner: 'all',
          line: 'all'
        };

        document.getElementById('searchInput').value = '';
        ['categoryFilter', 'subcategoryFilter', 'statusFilter', 'priorityFilter', 'ownerFilter', 'lineFilter']
          .forEach(id => {
            const el = document.getElementById(id);
            if (el) el.value = 'all';
          });
        updateSubcategoryOptions();
        applyFilters();
      });
    }
  }

  function bindWeekControls() {
    const prevWeekBtn = document.getElementById('prevWeek');
    const nextWeekBtn = document.getElementById('nextWeek');
    const resetWeekBtn = document.getElementById('resetWeek');

    if (prevWeekBtn) {
      prevWeekBtn.addEventListener('click', () => {
        state.currentWeekStart = addDays(state.currentWeekStart, -7);
        renderWeekView();
      });
    }

    if (nextWeekBtn) {
      nextWeekBtn.addEventListener('click', () => {
        state.currentWeekStart = addDays(state.currentWeekStart, 7);
        renderWeekView();
      });
    }

    if (resetWeekBtn) {
      resetWeekBtn.addEventListener('click', () => {
        state.currentWeekStart = getWeekStart(new Date());
        renderWeekView();
      });
    }
  }

  function applyFilters() {
    const filters = {
      search: state.filters.search,
      category: document.getElementById('categoryFilter').value,
      subcategory: document.getElementById('subcategoryFilter').value,
      status: document.getElementById('statusFilter').value,
      priority: document.getElementById('priorityFilter').value,
      owner: document.getElementById('ownerFilter').value,
      line: document.getElementById('lineFilter').value
    };

    state.filteredIssues = PunchListAPI.filterIssues(state.allIssues, filters);
    updateSummary();
    renderGanttView();
    renderWeekView();
  }

  function updateSummary() {
    const countEl = document.getElementById('issueCount');
    const overdueEl = document.getElementById('overdueCount');
    const timelineLabel = document.getElementById('timelineRangeLabel');

    if (countEl) {
      countEl.textContent = state.filteredIssues.length;
    }

    if (overdueEl) {
      const overdueCount = state.filteredIssues.filter(issue => PunchListAPI.isOverdue(issue)).length;
      overdueEl.textContent = overdueCount;
    }

    if (timelineLabel) {
      const { startDate, endDate } = getTimelineBounds(state.filteredIssues);
      if (!startDate || !endDate) {
        timelineLabel.textContent = '표시할 일정이 없습니다.';
        return;
      }

      timelineLabel.textContent = `${formatDisplayDate(startDate)} ~ ${formatDisplayDate(endDate)}`;
    }
  }

  function renderGanttView() {
    const axisEl = document.getElementById('ganttAxis');
    const bodyEl = document.getElementById('ganttBody');
    const emptyEl = document.getElementById('ganttEmpty');

    if (!axisEl || !bodyEl || !emptyEl) {
      return;
    }

    bodyEl.innerHTML = '';
    axisEl.innerHTML = '';

    if (state.filteredIssues.length === 0) {
      emptyEl.classList.remove('hidden');
      return;
    }

    emptyEl.classList.add('hidden');

    const { startDate, endDate } = getTimelineBounds(state.filteredIssues);
    if (!startDate || !endDate) {
      emptyEl.classList.remove('hidden');
      return;
    }

    const totalDays = Math.max(1, diffInDays(startDate, endDate));
    const weekCount = Math.max(1, Math.ceil(totalDays / 7));
    axisEl.style.gridTemplateColumns = `repeat(${weekCount}, 1fr)`;

    for (let i = 0; i < weekCount; i++) {
      const tickStart = addDays(startDate, i * 7);
      const tickEnd = addDays(tickStart, 6);
      const label = `${formatMonthDay(tickStart)} ~ ${formatMonthDay(minDate(tickEnd, endDate))}`;
      const span = document.createElement('span');
      span.textContent = label;
      axisEl.appendChild(span);
    }

    const sortedIssues = [...state.filteredIssues].sort((a, b) => {
      const aDate = getIssueSortDate(a) || startDate;
      const bDate = getIssueSortDate(b) || startDate;
      return aDate - bDate;
    });

    sortedIssues.forEach(issue => {
      const row = document.createElement('div');
      row.className = 'gantt-row';

      const info = document.createElement('div');
      info.className = 'gantt-row-info';

      const lineBadge = PunchListAPI.getLineBadge(issue.line_classification || issue.customFields?.line_classification || '');
      const priorityBadge = PunchListAPI.getPriorityBadge(issue.priority || '');
      const statusBadge = PunchListAPI.getStatusBadge(issue.status || '');

      info.innerHTML = `
        <h3>
          <span>${issue.id}</span>
          <span>·</span>
          <span>${issue.title}</span>
        </h3>
        <div class="meta">
          ${lineBadge || ''}
          ${priorityBadge || ''}
          ${statusBadge || ''}
        </div>
        <div class="meta">
          <span>담당: ${issue.owner || '-'}</span>
          <span>설비/세부: ${issue.subcategory || '-'}</span>
        </div>
      `;

      const track = document.createElement('div');
      track.className = 'gantt-bar-track';

      const { start, end } = getIssueRange(issue, startDate);
      const offsetDays = Math.max(0, (start.getTime() - startDate.getTime()) / DAY_MS);
      const durationDays = Math.max(1, Math.round((end.getTime() - start.getTime()) / DAY_MS) || 1);

      const bar = document.createElement('div');
      bar.className = 'gantt-bar';
      bar.style.background = PunchListAPI.getStatusColor(issue.status);
      const leftPercent = Math.min(100, Math.max(0, (offsetDays / totalDays) * 100));
      let widthPercent = (durationDays / totalDays) * 100;
      widthPercent = Math.max(2, Math.min(100 - leftPercent, widthPercent));
      bar.style.left = `${leftPercent}%`;
      bar.style.width = `${widthPercent}%`;
      bar.dataset.range = `${formatMonthDay(start)} ~ ${formatMonthDay(end)}`;
      bar.title = `${issue.title}\n${bar.dataset.range}`;
      bar.textContent = issue.line_classification || issue.subcategory || issue.owner || '';
      bar.setAttribute('tabindex', '0');
      bar.addEventListener('click', () => openIssueDetail(issue.id));
      bar.addEventListener('keypress', event => {
        if (event.key === 'Enter') {
          openIssueDetail(issue.id);
        }
      });

      track.appendChild(bar);
      row.appendChild(info);
      row.appendChild(track);
      bodyEl.appendChild(row);
    });
  }

  function renderWeekView() {
    const weekGrid = document.getElementById('weekGrid');
    const weekLabel = document.getElementById('weekRangeLabel');
    const weekEmpty = document.getElementById('weekEmpty');

    if (!weekGrid || !weekLabel) {
      return;
    }

    weekGrid.innerHTML = '';

    const weekDays = [];
    for (let i = 0; i < 7; i++) {
      weekDays.push(addDays(state.currentWeekStart, i));
    }

    weekLabel.textContent = `${formatDisplayDate(weekDays[0])} ~ ${formatDisplayDate(weekDays[6])}`;

    const weeklyIssues = weekDays.map(date => ({
      date,
      issues: state.filteredIssues.filter(issue => isIssueActiveOnDate(issue, date))
    }));

    const hasIssues = weeklyIssues.some(day => day.issues.length > 0);
    if (weekEmpty) {
      weekEmpty.classList.toggle('hidden', hasIssues);
    }

    weeklyIssues.forEach(({ date, issues }) => {
      const column = document.createElement('div');
      column.className = 'day-column';

      if (isSameDay(date, new Date())) {
        column.classList.add('today');
      }

      const header = document.createElement('div');
      header.className = 'day-header';
      header.innerHTML = `
        <strong>${formatWeekday(date)}</strong>
        <span>${formatMonthDay(date)}</span>
      `;

      const list = document.createElement('div');
      list.className = 'day-list';

      if (issues.length === 0) {
        const empty = document.createElement('div');
        empty.className = 'day-card day-card-empty';
        empty.innerHTML = '<p class="day-card-meta">등록된 일정 없음</p>';
        list.appendChild(empty);
      } else {
        issues.forEach(issue => {
          const card = document.createElement('div');
          card.className = 'day-card';
          card.style.borderLeftColor = PunchListAPI.getPriorityColor(issue.priority);
          const statusColor = PunchListAPI.getStatusColor(issue.status);
          const lineLabel = issue.line_classification || issue.subcategory || '라인 미정';
          const summaryLine = [issue.owner || '담당 미정', lineLabel].join(' · ');
          const targetDate = parseDateValue(issue.target_date);
          const secondaryLine = targetDate
            ? `목표 ${formatMonthDay(targetDate)}`
            : (issue.subcategory ? `설비 ${issue.subcategory}` : '');

          card.innerHTML = `
            <div class="day-card-header">
              <span class="status-pill" style="border-color:${statusColor};color:${statusColor};">${issue.status || '-'}</span>
              <span class="day-card-title">${issue.title}</span>
            </div>
            <p class="day-card-meta">${summaryLine}</p>
            ${secondaryLine ? `<p class="day-card-meta subtle">${secondaryLine}</p>` : ''}
          `;
          card.setAttribute('tabindex', '0');
          card.addEventListener('click', () => openIssueDetail(issue.id));
          card.addEventListener('keypress', event => {
            if (event.key === 'Enter') {
              openIssueDetail(issue.id);
            }
          });
          list.appendChild(card);
        });
      }

      column.appendChild(header);
      column.appendChild(list);
      weekGrid.appendChild(column);
    });
  }

  function getTimelineBounds(issues) {
    if (!issues || issues.length === 0) {
      return { startDate: null, endDate: null };
    }

    const dates = [];
    issues.forEach(issue => {
      ['request_date', 'target_date', 'complete_date'].forEach(key => {
        const parsed = parseDateValue(issue[key]);
        if (parsed) {
          dates.push(parsed);
        }
      });
    });

    if (dates.length === 0) {
      return { startDate: null, endDate: null };
    }

    dates.sort((a, b) => a - b);

    const startDate = dates[0];
    const endDate = dates[dates.length - 1];

    return { startDate, endDate };
  }

  function getIssueRange(issue, fallbackStart) {
    const start = parseDateValue(issue.request_date)
      || parseDateValue(issue.target_date)
      || fallbackStart
      || new Date();

    const end = parseDateValue(issue.complete_date)
      || parseDateValue(issue.target_date)
      || start;

    const normalizedEnd = end < start ? start : end;

    return { start, end: normalizedEnd };
  }

  function isIssueActiveOnDate(issue, date) {
    const { start, end } = getIssueRange(issue, date);
    const target = new Date(date);
    target.setHours(0, 0, 0, 0);

    const startDay = new Date(start);
    startDay.setHours(0, 0, 0, 0);

    const endDay = new Date(end);
    endDay.setHours(0, 0, 0, 0);

    return target >= startDay && target <= endDay;
  }

  function parseDateValue(value) {
    if (!value) return null;
    const date = new Date(value);
    return Number.isNaN(date.getTime()) ? null : date;
  }

  function diffInDays(start, end) {
    const ms = end.getTime() - start.getTime();
    const days = Math.round(ms / DAY_MS);
    return Math.max(1, days || 1);
  }

  function addDays(date, days) {
    const result = new Date(date);
    result.setDate(result.getDate() + days);
    return result;
  }

  function getWeekStart(date) {
    const result = new Date(date);
    const day = result.getDay();
    const diff = day === 0 ? -6 : 1 - day; // Monday start
    return addDays(result, diff);
  }

  function minDate(a, b) {
    return a < b ? a : b;
  }

  function formatDisplayDate(date) {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}.${month}.${day}`;
  }

  function formatMonthDay(date) {
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${month}/${day}`;
  }

  function formatWeekday(date) {
    const options = { weekday: 'short' };
    return date.toLocaleDateString('ko-KR', options);
  }

  function isSameDay(a, b) {
    return a.getFullYear() === b.getFullYear()
      && a.getMonth() === b.getMonth()
      && a.getDate() === b.getDate();
  }

  function showMessage(elementId, message) {
    const el = document.getElementById(elementId);
    if (el) {
      el.textContent = message;
      el.classList.remove('hidden');
    }
  }

  function getIssueSortDate(issue) {
    return parseDateValue(issue.request_date)
      || parseDateValue(issue.target_date)
      || parseDateValue(issue.complete_date);
  }

  function openIssueDetail(issueId) {
    if (!issueId) {
      return;
    }
    const detailUrl = `detail.html?id=${encodeURIComponent(issueId)}`;
    window.open(detailUrl, '_blank');
  }

  const DAY_MS = 24 * 60 * 60 * 1000;
})();
