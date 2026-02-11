/**
 * S25016 Gantt Chart Rendering Engine
 * Reads window.GANTT_DATA and renders the full gantt chart into #gantt-root
 *
 * @version 2.0.0 (2026-02-11) - 모듈 분리 리팩토링
 *   - gantt.html (264KB 단일파일) → 4파일 분리 (html/css/js/data)
 *   - 데이터 기반 동적 렌더링 (gantt-data.js)
 *   - TODAY 자동 계산 (하드코딩 제거)
 *   - 이벤트 위임 패턴 적용 (인라인 onclick 제거)
 */
var GanttChart = (function() {
    'use strict';

    var _data = null;
    var _root = null;
    var _todayIndex = -1; // 0-based index into days[]

    // ─── DOM Helpers ─────────────────────────────────────────────
    function _el(tag, cls, attrs) {
        var el = document.createElement(tag);
        if (cls) el.className = cls;
        if (attrs) {
            Object.keys(attrs).forEach(function(k) {
                if (k === 'html') { el.innerHTML = attrs[k]; }
                else if (k === 'text') { el.textContent = attrs[k]; }
                else if (k === 'style') { el.style.cssText = attrs[k]; }
                else { el.setAttribute(k, attrs[k]); }
            });
        }
        return el;
    }

    function _text(tag, text, cls) {
        return _el(tag, cls, { text: text });
    }

    function _append(parent) {
        for (var i = 1; i < arguments.length; i++) {
            if (arguments[i]) parent.appendChild(arguments[i]);
        }
        return parent;
    }

    // ─── Date Utilities ──────────────────────────────────────────
    function _computeTodayIndex() {
        var today = new Date();
        today.setHours(0, 0, 0, 0);
        for (var i = 0; i < _data.days.length; i++) {
            var d = new Date(_data.days[i].date);
            d.setHours(0, 0, 0, 0);
            if (d.getTime() === today.getTime()) return i;
        }
        // If today is beyond the range, return -1
        return -1;
    }

    function _isBeforeToday(dayIndex) {
        return _todayIndex >= 0 && dayIndex < _todayIndex;
    }

    // ─── Render: Header ──────────────────────────────────────────
    function _renderHeader() {
        var m = _data.meta;
        var header = _el('div', 'header');
        _append(header, _text('h1', m.title));

        var info = _el('div', 'header-info');
        _append(info, _text('span', m.totalTasks));
        _append(info, _text('span', m.ownerCount));
        _append(info, _text('span', m.dateRange));

        var badge = _el('span', null, {
            text: 'Updated: ' + m.updated,
            style: 'background:#fbbf24;color:#1e40af;padding:2px 8px;border-radius:10px;font-size:0.8rem;'
        });
        _append(info, badge);
        _append(header, info);
        _append(_root, header);
    }

    // ─── Render: Legend ──────────────────────────────────────────
    function _renderLegend() {
        var container = _el('div', 'legend');
        _data.legends.forEach(function(leg) {
            var item = _el('div', 'legend-item');
            var dot = _el('div', 'legend-dot');
            if (leg.type === 'delayed') {
                dot.style.cssText = 'background:repeating-linear-gradient(45deg,#dc2626,#dc2626 3px,#fff 3px,#fff 6px);border:1px dashed #991b1b';
            } else if (leg.type === 'pending') {
                dot.style.cssText = 'background:#9ca3af;border:2px dotted #4b5563;opacity:0.7';
            } else {
                dot.style.background = leg.color;
            }
            _append(item, dot);
            _append(item, document.createTextNode(' ' + leg.label));
            _append(container, item);
        });
        _append(_root, container);
    }

    // ─── Render: Filters ─────────────────────────────────────────
    function _renderFilters() {
        var container = _el('div', 'filters');
        _data.filters.forEach(function(f) {
            var cls = 'filter-btn' + (f.active ? ' active' : '') + (f.cssClass ? ' ' + f.cssClass : '');
            var btn = _el('button', cls, { text: f.label, 'data-filter': f.value });
            _append(container, btn);
        });
        _append(_root, container);
    }

    // ─── Render: Week Header ─────────────────────────────────────
    function _renderWeekHeader(ganttContainer) {
        var row = _el('div', 'week-header');
        _append(row, _el('div', 'week-header-cell'));
        _data.weeks.forEach(function(w) {
            var cell = _el('div', 'week-header-cell ' + w.cssClass, {
                text: w.label,
                style: 'grid-column: span ' + w.span + ';'
            });
            _append(row, cell);
        });
        _append(ganttContainer, row);
    }

    // ─── Render: Date Header ─────────────────────────────────────
    function _renderDateHeader(ganttContainer) {
        var row = _el('div', 'gantt-header');
        _append(row, _el('div', 'gantt-header-cell label', { text: '담당자' }));

        _data.days.forEach(function(day, idx) {
            var cls = 'gantt-header-cell';
            if (day.isWeekend) cls += ' weekend';
            if (day.weekStart) cls += ' week-start';

            var isToday = idx === _todayIndex;
            var cell = _el('div', cls);

            // Apply special cell styles
            if (isToday) {
                cell.style.cssText = 'background:rgba(59,130,246,0.3);border:2px solid #3b82f6;';
            } else if (day.cellStyle === 'completed-bg') {
                cell.style.background = 'rgba(5,150,105,0.2)';
            }

            var dayDiv = _el('div', 'day');
            dayDiv.textContent = day.dayOfWeek;
            var dateDiv = _el('div', 'date');
            dateDiv.textContent = day.label;

            if (isToday) {
                dayDiv.style.cssText = 'color:#3b82f6;font-weight:bold;';
                dateDiv.style.cssText = 'color:#3b82f6;font-weight:bold;';
            }

            _append(cell, dayDiv, dateDiv);

            // Annotation (TODAY, ✓9완료, etc.)
            if (day.annotation) {
                var anno = _el('div', null, {
                    text: day.annotation,
                    style: 'font-size:' + (isToday ? '0.6rem' : '0.55rem') + ';color:' + (isToday ? '#3b82f6' : '#059669') + ';' + (isToday ? 'font-weight:bold;' : '')
                });
                _append(cell, anno);
            }

            _append(row, cell);
        });
        _append(ganttContainer, row);
    }

    // ─── Render: Task Bar ────────────────────────────────────────
    function _renderTaskBar(bar) {
        var cls = 'task-bar';
        if (bar.priority) cls += ' ' + bar.priority;
        if (bar.status) cls += ' ' + bar.status;

        var el = _el('div', cls);

        // Font size
        if (bar.fontSize) {
            el.style.fontSize = bar.fontSize;
        }

        // Extra inline style
        if (bar.style) {
            el.style.cssText = (el.style.cssText || '') + bar.style;
        }

        // Content: extraHtml + label
        if (bar.extraHtml) {
            el.innerHTML = bar.extraHtml + (bar.label || '');
        } else {
            el.textContent = bar.label || '';
        }

        // Tooltip
        if (bar.tooltip) {
            var tt = _el('div', 'task-tooltip');
            var t = bar.tooltip;

            // Title
            var titleEl = _el('div', 'tt-title');
            if (t.titleLink) {
                titleEl.innerHTML = '<a href="' + t.titleLink + '" target="_blank">' + _escHtml(t.title) + '</a>';
            } else if (t.titleHtml) {
                titleEl.innerHTML = t.titleHtml;
            } else {
                titleEl.textContent = t.title;
            }
            _append(tt, titleEl);

            // Description
            if (t.description) {
                _append(tt, _el('div', null, { text: t.description }));
            }

            // Rows
            if (t.rows) {
                t.rows.forEach(function(r) {
                    var row = _el('div', 'tt-row');
                    row.innerHTML = '<span class="tt-label">' + _escHtml(r.label) + ':</span> ' + _escHtml(r.value);
                    _append(tt, row);
                });
            }

            _append(el, tt);
        }

        return el;
    }

    function _escHtml(str) {
        if (!str) return '';
        return String(str).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
    }

    // ─── Render: Gantt Cell ──────────────────────────────────────
    function _renderGanttCell(cellData, dayIndex) {
        var day = _data.days[dayIndex];
        var cls = 'gantt-cell';
        if (day.isWeekend) cls += ' weekend';
        if (day.weekStart) cls += ' week-start';

        var cell = _el('div', cls);

        // Cell-level style
        if (cellData.style) {
            cell.style.cssText = cellData.style;
        }

        // Task bars
        if (cellData.bars) {
            cellData.bars.forEach(function(bar) {
                _append(cell, _renderTaskBar(bar));
            });
        }

        // Extra HTML content (annotations, notes)
        if (cellData.extraHtml) {
            var wrapper = _el('div');
            wrapper.innerHTML = cellData.extraHtml;
            while (wrapper.firstChild) {
                cell.appendChild(wrapper.firstChild);
            }
        }

        return cell;
    }

    // ─── Render: Owner Section ───────────────────────────────────
    function _renderOwnerSection(owner) {
        var section = _el('div', 'owner-section');
        if (owner.sectionStyle) {
            section.style.cssText = owner.sectionStyle;
        }

        var row = _el('div', 'owner-row');

        // Owner name cell
        var nameCell = _el('div', 'owner-name');
        var avatar = _el('div', 'owner-avatar', {
            text: owner.avatar,
            style: 'background:linear-gradient(135deg,' + owner.gradient[0] + ',' + owner.gradient[1] + ');'
        });
        var info = _el('div', 'owner-info');
        _append(info, _el('div', 'name', { text: owner.name }));

        // Count with optional badges
        var countEl = _el('div', 'count');
        if (owner.badges) {
            var countHtml = _escHtml(owner.taskCount);
            if (owner.badges.completed) {
                countHtml += ' <span style="font-size:0.6rem;color:#10b981;">✓' + owner.badges.completed + '</span>';
            }
            if (owner.badges.delayed) {
                countHtml += ' <span style="font-size:0.6rem;color:#dc2626;">⚠' + owner.badges.delayed + '</span>';
            }
            countEl.innerHTML = countHtml;
        } else {
            countEl.textContent = owner.taskCount;
        }
        _append(info, countEl);
        _append(nameCell, avatar, info);
        _append(row, nameCell);

        // 27 cells
        owner.cells.forEach(function(cellData, idx) {
            _append(row, _renderGanttCell(cellData, idx));
        });

        _append(section, row);
        return section;
    }

    // ─── Render: Summary Row ─────────────────────────────────────
    function _renderSummaryRow(ganttContainer) {
        var row = _el('div', 'summary-row');
        _append(row, _el('div', 'summary-cell label', { text: '일별 업무량' }));

        _data.dailySummary.forEach(function(s, idx) {
            var day = _data.days[idx];
            var cls = 'summary-cell';
            if (day.isWeekend) cls += ' weekend';
            if (day.weekStart) cls += ' week-start';

            var cell = _el('div', cls);

            // Special cell styling
            if (s.cellStyle) {
                cell.style.cssText = s.cellStyle;
            }

            if (s.value === '-' || !s.value) {
                cell.textContent = '-';
            } else {
                var num = _el('div', 'num');
                if (s.html) {
                    num.innerHTML = s.html;
                } else {
                    num.textContent = s.value;
                }
                if (s.color) num.style.color = s.color;
                _append(cell, num);
            }

            _append(row, cell);
        });
        _append(ganttContainer, row);
    }

    // ─── Render: Detail Section ──────────────────────────────────
    function _renderDetailSection() {
        var section = _el('div', 'detail-section');

        _data.dayCards.forEach(function(group) {
            // Week heading
            if (group.heading) {
                _append(section, _el('h2', null, { text: group.heading }));
            }

            // Summary boxes (between headings)
            if (group.summaryHtml) {
                var wrapper = _el('div');
                wrapper.innerHTML = group.summaryHtml;
                while (wrapper.firstChild) {
                    section.appendChild(wrapper.firstChild);
                }
            }

            // Day cards grid
            if (group.cards && group.cards.length > 0) {
                var grid = _el('div', 'day-schedule');
                group.cards.forEach(function(card) {
                    var dayCard = _el('div', 'day-card');
                    if (card.cardStyle) dayCard.style.cssText = card.cardStyle;

                    // Header
                    var headerCls = 'day-card-header' + (card.weekClass ? ' ' + card.weekClass : '');
                    var header = _el('div', headerCls);
                    if (card.headerStyle) header.style.cssText = card.headerStyle;

                    var headerLeft = _el('div');
                    headerLeft.innerHTML = '<span class="day-name">' + _escHtml(card.dayName) + '</span> <span class="day-date">' + _escHtml(card.date) + '</span>' + (card.headerBadge || '');
                    _append(header, headerLeft);

                    var countSpan = _el('span', 'task-count', { text: card.taskCount });
                    if (card.taskCountStyle) countSpan.style.cssText = card.taskCountStyle;
                    _append(header, countSpan);

                    _append(dayCard, header);

                    // Content
                    var content = _el('div', 'day-task-list');
                    content.innerHTML = card.contentHtml;
                    _append(dayCard, content);

                    _append(grid, dayCard);
                });
                _append(section, grid);
            }
        });

        _append(_root, section);
    }

    // ─── Render: Footer ──────────────────────────────────────────
    function _renderFooter() {
        var footer = _el('div', 'footer');
        _append(footer, _text('p', _data.footer.line1));
        _append(footer, _text('p', _data.footer.line2));
        _append(_root, footer);
    }

    // ─── Post-processing ─────────────────────────────────────────
    function _applyTodayHighlight() {
        if (_todayIndex < 0) return;
        // The date header already handles TODAY styling in _renderDateHeader
        // Highlight the column in all owner rows
        var colIdx = _todayIndex + 1; // +1 for the label column
        _root.querySelectorAll('.owner-row, .summary-row').forEach(function(row) {
            var cells = row.children;
            if (cells[colIdx]) {
                cells[colIdx].style.borderLeft = '2px solid rgba(59,130,246,0.4)';
                cells[colIdx].style.borderRight = '2px solid rgba(59,130,246,0.4)';
            }
        });
    }

    function _applyPastCompletedGhost() {
        if (_todayIndex < 0) return;
        _root.querySelectorAll('.owner-row').forEach(function(row) {
            var cells = row.querySelectorAll('.gantt-cell');
            cells.forEach(function(cell, idx) {
                if (idx < _todayIndex) {
                    cell.querySelectorAll('.task-bar.completed').forEach(function(bar) {
                        if (!bar.classList.contains('completed-past')) {
                            bar.classList.add('completed-past');
                        }
                    });
                    if (cell.style.background === 'rgb(236, 253, 245)' ||
                        cell.style.background === '#ecfdf5') {
                        cell.classList.add('past-completed');
                    }
                }
            });
        });
    }

    // ─── Event Delegation ────────────────────────────────────────
    function _setupEventDelegation() {
        _root.addEventListener('click', function(e) {
            // Filter buttons
            var btn = e.target.closest('.filter-btn');
            if (btn) {
                var filter = btn.getAttribute('data-filter');
                if (filter) _filterTasks(filter, btn);
                return;
            }

            // Task bar click → navigate to detail
            var bar = e.target.closest('.task-bar');
            if (bar) {
                var link = bar.querySelector('.task-tooltip a[href]');
                if (link) {
                    window.open(link.href, '_blank');
                    return;
                }
                // Fallback: parse ID from text
                var text = bar.textContent.trim();
                var numMatch = text.match(/^(\d{3})/);
                if (numMatch) {
                    var num = numMatch[1];
                    var year = (_data.year2026Ids && _data.year2026Ids.indexOf(num) >= 0) ? '2026' : '2025';
                    var id = 'PL-' + year + '-' + num;
                    window.open(_data.meta.baseUrl + '?id=' + id, '_blank');
                    return;
                }
                // B-line items
                var bMatch = text.match(/^#(\d+)/);
                if (bMatch && _data.bLineIdMapping) {
                    var bId = _data.bLineIdMapping[bMatch[1]];
                    if (bId) {
                        window.open(_data.meta.baseUrl + '?id=' + bId, '_blank');
                    }
                }
            }
        });
    }

    function _filterTasks(priority, clickedBtn) {
        // Update active button
        _root.querySelectorAll('.filter-btn').forEach(function(b) {
            b.classList.remove('active');
        });
        if (clickedBtn) clickedBtn.classList.add('active');

        // Filter task bars
        _root.querySelectorAll('.task-bar').forEach(function(bar) {
            if (priority === 'all') {
                bar.classList.remove('hidden');
            } else if (bar.classList.contains(priority)) {
                bar.classList.remove('hidden');
            } else {
                bar.classList.add('hidden');
            }
        });

        // Filter day task items
        _root.querySelectorAll('.day-task-item').forEach(function(item) {
            if (priority === 'all') {
                item.classList.remove('hidden');
            } else if (item.classList.contains(priority)) {
                item.classList.remove('hidden');
            } else {
                item.classList.add('hidden');
            }
        });
    }

    // ─── Title tooltips for task bars ────────────────────────────
    function _applyBarTitles() {
        _root.querySelectorAll('.task-bar').forEach(function(bar) {
            var text = bar.textContent.trim();
            var numMatch = text.match(/^(\d{3})/);
            if (numMatch) {
                var num = numMatch[1];
                var year = (_data.year2026Ids && _data.year2026Ids.indexOf(num) >= 0) ? '2026' : '2025';
                var id = 'PL-' + year + '-' + num;
                var fullName = (_data.issueNames && _data.issueNames[num]) || text;
                bar.title = '[' + id + '] ' + fullName + '\n(클릭하여 상세 보기)';
                bar.style.cursor = 'pointer';
                return;
            }
            var bMatch = text.match(/^#(\d+)/);
            if (bMatch) {
                var bNum = bMatch[1];
                var bId = _data.bLineIdMapping && _data.bLineIdMapping[bNum];
                var bName = (_data.bLineNames && _data.bLineNames[bNum]) || text;
                bar.title = (bId ? '[' + bId + '] ' : '[B라인 #' + bNum + '] ') + bName + (bId ? '\n(클릭하여 상세 보기)' : '');
                if (bId) bar.style.cursor = 'pointer';
            }
        });
    }

    // ─── Public API ──────────────────────────────────────────────
    function init(data) {
        _data = data;
        _root = document.getElementById('gantt-root');
        if (!_root || !_data) {
            console.error('GanttChart: missing #gantt-root or GANTT_DATA');
            return;
        }

        // Compute today's column index dynamically
        _todayIndex = _computeTodayIndex();

        // Render all sections
        _renderHeader();
        _renderLegend();
        _renderFilters();

        // Gantt chart container
        var ganttContainer = _el('div', 'gantt-container');
        _renderWeekHeader(ganttContainer);
        _renderDateHeader(ganttContainer);

        // Owner sections
        _data.owners.forEach(function(owner) {
            _append(ganttContainer, _renderOwnerSection(owner));
        });

        // Summary row
        _renderSummaryRow(ganttContainer);

        _append(_root, ganttContainer);

        // Detail section (day cards)
        _renderDetailSection();

        // Footer
        _renderFooter();

        // Post-processing
        _applyTodayHighlight();
        _applyPastCompletedGhost();
        _applyBarTitles();

        // Event delegation
        _setupEventDelegation();

        console.log('✓ GanttChart initialized (todayIndex=' + _todayIndex + ')');
    }

    return { init: init, filterTasks: _filterTasks };
})();
