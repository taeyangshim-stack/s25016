# RAPID Coding Standards - S25016 Project

**Project**: S25016 SpGantry 1200
**Last Updated**: 2026-01-04
**Purpose**: Prevent syntax errors and maintain code quality

---

## 🚨 Critical Rules (Must Follow)

### 1. **NO Korean Comments** ❌

**Rule**: All comments MUST be in English only

**Reason**: RAPID compiler does not support Unicode Korean characters

**Wrong** ❌:
```rapid
! 로봇1의 위치를 읽어옴  <- Syntax Error!
robot1_pos := CRobT();
```

**Correct** ✅:
```rapid
! Read Robot1 current position
robot1_pos := CRobT();
```

**Exception**:
- Korean allowed in CHANGELOG.md, README.md (non-RAPID files only)
- Korean allowed in TP messages if controller supports it (test first!)

---

### 2. **NO Unicode Special Characters** ❌

**Rule**: Use only ASCII characters (0-127)

**Forbidden Characters**:
- Greek letters: θ, α, β, γ, Δ, π
- Math symbols: ×, ÷, ≠, ≤, ≥, ±
- Quotes: " " ' ' (curly quotes)
- Dashes: — – (em dash, en dash)
- Arrows: →, ←, ↑, ↓

**Wrong** ❌:
```rapid
! Rotation matrix: [cos(θ) -sin(θ)] × [x]  <- Syntax Error!
```

**Correct** ✅:
```rapid
! Rotation matrix: [cos(T) -sin(T)] x [x]
! where T = total_r_deg
```

**Safe Alternatives**:
- θ → T, theta, angle
- × → x, *, multiply
- ± → +/-, plus/minus
- → → ->, ==>
- ≠ → !=, NOT equal

---

### 3. **Version History in Code** 📝

**Rule**: Maintain complete version history at top of each module

**Format**:
```rapid
MODULE MainModule
    !========================================
    ! TASK1 (Robot1) - MainModule
    ! Version History
    !========================================
    ! v1.0.0 (YYYY-MM-DD)
    !   - Initial release
    !   - Feature description
    !
    ! v1.1.0 (YYYY-MM-DD)
    !   - Added feature X
    !   - Fixed bug Y
    !   - Changed behavior Z
    !
    ! v1.2.0 (YYYY-MM-DD)
    !   - CRITICAL FIX: Description
    !   - BUGFIX: Description
    !========================================

    ! Version constant for logging (v1.2.0+)
    CONST string TASK1_VERSION := "v1.2.0";
```

**Required Elements**:
- Date in ISO format (YYYY-MM-DD)
- Brief description of changes
- Use prefixes: CRITICAL FIX, BUGFIX, Added, Changed, Removed
- Update version constant

---

## 📋 Recommended Practices

### 4. **Procedure Documentation**

**Format**:
```rapid
! ========================================
! Procedure Name and Purpose
! ========================================
! Version: v1.2.0
! Date: 2026-01-04
! Purpose: Brief description of what this procedure does
! Parameters:
!   - param1: Description
!   - param2: Description
! Returns: Description (if function)
! Changes in v1.2.0:
!   - Change description
! Output: /HOME/output_file.txt (if applicable)
PROC MyProcedure(num param1, num param2)
    ...
ENDPROC
```

---

### 5. **Variable Naming Conventions**

**Rules**:
- Use descriptive names (avoid `x`, `y`, `z` unless coordinates)
- Snake_case or camelCase (be consistent)
- Prefix global variables: `g_variable_name`
- Boolean variables: `is_`, `has_`, `enable_`

**Good** ✅:
```rapid
VAR num current_angle;
VAR bool is_initialized;
VAR robtarget home_position;
PERS bool enable_debug_logging;
```

**Bad** ❌:
```rapid
VAR num a;
VAR bool flag;
VAR robtarget p;
```

---

### 6. **Comment Density**

**Rule**: Comment complex logic, not obvious code

**Wrong** ❌:
```rapid
! Add 1 to counter
counter := counter + 1;
```

**Correct** ✅:
```rapid
! Apply rotation transformation matrix to convert wobj0 to Floor coords
! Rotation matrix: [cos(T) -sin(T); sin(T) cos(T)]
floor_x := wobj0_x * Cos(angle) - wobj0_y * Sin(angle);
floor_y := wobj0_x * Sin(angle) + wobj0_y * Cos(angle);
```

---

### 7. **Error Handling**

**Rule**: Always include ERROR handler for file operations and movements

**Format**:
```rapid
PROC MyProcedure()
    VAR iodev file;

    Open "HOME:/myfile.txt", file \Write;
    Write file, "Data";
    Close file;

ERROR
    IF ERRNO = ERR_FILEOPEN THEN
        TPWrite "ERROR: Cannot open file";
    ELSE
        TPWrite "ERROR in MyProcedure: " + NumToStr(ERRNO, 0);
    ENDIF
    Close file;
    STOP;
ENDPROC
```

---

### 8. **File Operations**

**Rules**:
- Always use `\RemoveCR` when reading config files
- Always close files (even in ERROR handler)
- Use descriptive file handles: `logfile`, `configfile`, not `f1`, `f2`

**Good** ✅:
```rapid
VAR iodev logfile;
VAR string line;

Open "HOME:/config.txt", configfile \Read;
line := ReadStr(configfile \RemoveCR);
Close configfile;
```

---

### 9. **Magic Numbers**

**Rule**: Use named constants instead of magic numbers

**Wrong** ❌:
```rapid
IF distance > 488 THEN
    ...
ENDIF
```

**Correct** ✅:
```rapid
CONST num ROBOT2_OFFSET_Y := 488;  ! mm from R-center

IF distance > ROBOT2_OFFSET_Y THEN
    ...
ENDIF
```

---

### 10. **Line Length**

**Rule**: Keep lines under 100 characters for readability

**Tool**: Use line continuation for long strings

**Good** ✅:
```rapid
TPWrite "Starting test with parameters: "
      + "X=" + NumToStr(x,0) + ", "
      + "Y=" + NumToStr(y,0) + ", "
      + "Z=" + NumToStr(z,0);
```

---

## 🔍 Before Committing Checklist

- [ ] **No Korean comments** (search for Hangul characters)
- [ ] **No Unicode special characters** (θ, ×, →, etc.)
- [ ] **Version history updated** at module top
- [ ] **Version constant updated** (TASK1_VERSION, TASK2_VERSION)
- [ ] **Procedure headers documented** with version and purpose
- [ ] **All files closed** in ERROR handlers
- [ ] **TPWrite messages in English** (or tested on actual controller)
- [ ] **Syntax check passed** in RobotStudio
- [ ] **CHANGELOG.md updated** with changes

---

## 🛠️ Syntax Check Process

### In RobotStudio:
1. Load module to T_ROB1 or T_ROB2
2. Menu → RAPID → Check Program
3. Fix all errors before committing
4. Test on actual controller if possible

### Common Syntax Errors:

| Error Code | Description | Common Cause |
|------------|-------------|--------------|
| 135 | Expected identifier | Unicode character or Korean |
| 150 | Unexpected unknown token | Special character (×, θ, etc.) |
| 40322 | Load error | Syntax error in module |

---

## 📁 File Naming Conventions

**RAPID Modules**:
- `MainModule.mod` (TASK1 main)
- `Rob2_MainModule.mod` (TASK2 main)
- Use descriptive names, avoid `Module1.mod`

**Documentation**:
- `CHANGELOG.md` - Version history
- `SYSTEM_CONFIG.md` - System architecture
- `CODING_STANDARDS.md` - This document
- `README.md` - Project overview

**Test Results**:
- Format: `vX.X.X_TestResults.html`
- Example: `v1.8.2_TestResults.html`

---

## 🚀 Git Commit Message Format

**Format**:
```
type(scope): Brief description

Detailed description (if needed)

- Bullet point 1
- Bullet point 2

Files Changed:
- File 1
- File 2
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `refactor`: Code refactoring
- `test`: Test related
- `chore`: Build/tool changes

**Examples**:
```
fix(rapid): Apply rotation transformation matrix for Robot2 TCP (v1.8.2)

docs: Add comprehensive system configuration documentation

feat(rapid): Implement v1.8.0 Phase 1 - R-axis rotation testing
```

---

## 🔄 Code Review Checklist

Before merging:
- [ ] Syntax check passed
- [ ] No Korean comments
- [ ] No Unicode special characters
- [ ] Version history updated
- [ ] CHANGELOG.md updated
- [ ] Tested on controller (if possible)
- [ ] Documentation updated
- [ ] No hardcoded values (use constants)
- [ ] Error handlers present
- [ ] Files properly closed

---

## 📚 References

**ABB RAPID Reference Manual**:
- Avoid Unicode in comments
- Use ASCII only for all code and comments
- Follow ABB naming conventions

**Project Documents**:
- `SYSTEM_CONFIG.md` - System architecture
- `CHANGELOG.md` - Version history
- `README.md` - Project setup

---

**Last Updated**: 2026-01-04
**Maintained By**: SP 심태양
**Project**: S25016 SpGantry 1200
