/**
 * S25016 펀치리스트 설정 로더
 *
 * JSON 설정 파일을 동적으로 로드하여 시스템 확장성을 제공합니다.
 */

class ConfigLoader {
  constructor(baseUrl = '/punchlist') {
    this.baseUrl = baseUrl;
    this.cache = {};
  }

  /**
   * 분류 체계 로드
   */
  async loadCategories() {
    if (this.cache.categories) {
      return this.cache.categories;
    }

    try {
      const response = await fetch(`${this.baseUrl}/config/categories.json`);
      const data = await response.json();
      this.cache.categories = data;
      return data;
    } catch (error) {
      console.error('분류 체계 로드 실패:', error);
      // 폴백: 기본 분류 체계
      return this.getDefaultCategories();
    }
  }

  /**
   * 커스텀 필드 정의 로드
   */
  async loadCustomFields() {
    if (this.cache.customFields) {
      return this.cache.customFields;
    }

    try {
      const response = await fetch(`${this.baseUrl}/config/custom-fields.json`);
      const data = await response.json();
      this.cache.customFields = data;
      return data;
    } catch (error) {
      console.error('커스텀 필드 로드 실패:', error);
      return { version: '1.0', fields: [] };
    }
  }

  /**
   * 템플릿 로드
   */
  async loadTemplate(templateId) {
    if (this.cache[`template_${templateId}`]) {
      return this.cache[`template_${templateId}`];
    }

    try {
      const response = await fetch(`${this.baseUrl}/templates/special-cases/${templateId}-template.json`);
      const data = await response.json();
      this.cache[`template_${templateId}`] = data;
      return data;
    } catch (error) {
      console.error(`템플릿 로드 실패 (${templateId}):`, error);
      return null;
    }
  }

  /**
   * 모든 템플릿 목록 로드
   */
  async loadAllTemplates() {
    const templateIds = [
      'vendor-issue',
      'emergency',
      'inspection',
      'quality-issue'
    ];

    const templates = await Promise.all(
      templateIds.map(id => this.loadTemplate(id))
    );

    return templates.filter(t => t !== null);
  }

  /**
   * 플러그인 설정 로드
   */
  async loadPluginConfig() {
    if (this.cache.plugins) {
      return this.cache.plugins;
    }

    try {
      const response = await fetch(`${this.baseUrl}/config/plugins.json`);
      const data = await response.json();
      this.cache.plugins = data;
      return data;
    } catch (error) {
      console.warn('플러그인 설정 파일 없음 (선택사항)');
      return { enabled: [] };
    }
  }

  /**
   * 분류 체계를 드롭다운 옵션 형식으로 변환
   */
  async getCategoryOptions() {
    const data = await this.loadCategories();
    return data.categories.map(cat => ({
      id: cat.id,
      name: cat.name,
      icon: cat.icon,
      color: cat.color
    }));
  }

  /**
   * 세부분류 옵션 가져오기
   */
  async getSubcategoryOptions(categoryId) {
    const data = await this.loadCategories();
    const category = data.categories.find(cat => cat.id === categoryId);

    if (!category) {
      return [];
    }

    return category.subcategories.map(sub => ({
      id: sub.id,
      name: sub.name,
      description: sub.description,
      allowCustomInput: sub.allowCustomInput || false
    }));
  }

  /**
   * 커스텀 필드를 표시 조건에 따라 필터링
   */
  async getVisibleCustomFields(issueData) {
    const config = await this.loadCustomFields();

    return config.fields.filter(field => {
      // 표시 조건이 없으면 항상 표시
      if (!field.displayCondition) {
        return true;
      }

      // 조건 평가
      for (const [key, values] of Object.entries(field.displayCondition)) {
        const issueValue = this.getNestedValue(issueData, key);

        if (!values.includes(issueValue)) {
          return false;
        }
      }

      return true;
    });
  }

  /**
   * 중첩된 객체 값 가져오기 (예: "customFields.vendor_name")
   */
  getNestedValue(obj, path) {
    return path.split('.').reduce((current, key) => {
      return current ? current[key] : undefined;
    }, obj);
  }

  /**
   * 템플릿의 기본값 적용
   */
  async applyTemplateDefaults(templateId, issueData = {}) {
    const template = await this.loadTemplate(templateId);

    if (!template) {
      return issueData;
    }

    // 템플릿 기본값 적용
    const result = {
      ...issueData,
      ...template.defaultValues,
      templateId: templateId
    };

    // 커스텀 필드 기본값 적용
    if (template.customFields) {
      result.customFields = result.customFields || {};

      for (const [fieldId, fieldConfig] of Object.entries(template.customFields)) {
        if (fieldConfig.enabled && fieldConfig.defaultValue !== undefined) {
          result.customFields[fieldId] = fieldConfig.defaultValue;
        }
      }
    }

    return result;
  }

  /**
   * 템플릿 필수 필드 검증
   */
  async validateRequiredFields(templateId, issueData) {
    const template = await this.loadTemplate(templateId);

    if (!template || !template.requiredFields) {
      return { valid: true, missingFields: [] };
    }

    const missingFields = [];

    for (const fieldPath of template.requiredFields) {
      const value = this.getNestedValue(issueData, fieldPath);

      if (value === undefined || value === null || value === '') {
        missingFields.push(fieldPath);
      }
    }

    return {
      valid: missingFields.length === 0,
      missingFields
    };
  }

  /**
   * 기본 분류 체계 (폴백용)
   */
  getDefaultCategories() {
    return {
      version: '1.0',
      categories: [
        {
          id: 'mechanical',
          name: '기계',
          icon: '🔧',
          color: '#3b82f6',
          subcategories: [
            { id: 'structure', name: '구조물' },
            { id: 'frame', name: '프레임' },
            { id: 'transport', name: '이송장치' },
            { id: 'custom', name: '기타', allowCustomInput: true }
          ]
        },
        {
          id: 'electrical',
          name: '전기',
          icon: '⚡',
          color: '#f59e0b',
          subcategories: [
            { id: 'wiring', name: '배선' },
            { id: 'sensor', name: '센서' },
            { id: 'motor', name: '모터' },
            { id: 'power', name: '전원' },
            { id: 'custom', name: '기타', allowCustomInput: true }
          ]
        },
        {
          id: 'control',
          name: '제어',
          icon: '💻',
          color: '#10b981',
          subcategories: [
            { id: 'robot', name: '로봇' },
            { id: 'ui_hmi', name: 'UI/HMI' },
            { id: 'measurement', name: '계측' },
            { id: 'plc', name: 'PLC' },
            { id: 'custom', name: '기타', allowCustomInput: true }
          ]
        }
      ]
    };
  }

  /**
   * 캐시 초기화
   */
  clearCache() {
    this.cache = {};
  }

  /**
   * 특정 설정 리로드
   */
  async reload(configType) {
    delete this.cache[configType];

    switch (configType) {
      case 'categories':
        return await this.loadCategories();
      case 'customFields':
        return await this.loadCustomFields();
      case 'plugins':
        return await this.loadPluginConfig();
      default:
        throw new Error(`Unknown config type: ${configType}`);
    }
  }
}

// 전역 인스턴스 생성
window.configLoader = new ConfigLoader();

// 편의 함수
window.loadCategories = () => window.configLoader.loadCategories();
window.loadCustomFields = () => window.configLoader.loadCustomFields();
window.loadTemplate = (id) => window.configLoader.loadTemplate(id);
window.loadAllTemplates = () => window.configLoader.loadAllTemplates();
