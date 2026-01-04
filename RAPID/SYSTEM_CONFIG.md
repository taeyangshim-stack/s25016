# System Configuration - SpGantry 1200 Dual Robot System

**Project**: S25016
**Last Updated**: 2026-01-04
**Version**: v1.8.5

---

## 🎯 Critical System Configuration

This document describes the **fundamental system architecture** that must be understood for all coordinate calculations.

> ⚠️ **IMPORTANT**: This configuration explains why Robot2 Floor TCP calculation requires rotation transformation matrix in v1.8.5.

---

## 🤖 Robot Configuration

### Robot1 (TASK1)

| Parameter | Value | Description |
|-----------|-------|-------------|
| **Gantry Config** | ✅ **YES** | Configured with gantry external axes |
| **wobj0 Location** | R-center | Robot1 wobj0 is at gantry rotation center |
| **Physical Base** | R-center + [0, **+488**, 0] | Robot1 base is **+488mm** from R-center in Floor Y direction |
| **TCP HOME** | wobj0 [0, 0, 1000] | Tool0 at [0, 0, 1000] in wobj0 coordinates |
| **TCP at R-center** | ✅ YES | When at HOME, tool0 is at rotation center |

**Why it works:**
- Robot1 wobj0 = R-center
- Robot1 base = wobj0 + [0, 488, 0]
- tool0 = wobj0 + [0, 0, 1000]
- **Result**: tool0 is at R-center + [0, 0, 1000] = **R-center in XY plane**

---

### Robot2 (TASK2)

| Parameter | Value | Description |
|-----------|-------|-------------|
| **Gantry Config** | ❌ **NO** | **NOT** configured with gantry |
| **wobj0 Location** | Robot2 base | Robot2 wobj0 is at physical Robot2 base |
| **Physical Base** | R-center + [0, **-488**, 0] | Robot2 base is **-488mm** from R-center in Floor Y direction |
| **TCP HOME** | wobj0 [0, **+488**, -1000] | Tool0 at [0, **+488**, -1000] in wobj0 coordinates |
| **TCP at R-center** | ✅ YES | When at HOME, tool0 is at rotation center |

**Why it works:**
- Robot2 wobj0 = Robot2 base
- Robot2 base = R-center + [0, -488, 0]
- tool0 = wobj0 + [0, **+488**, -1000]
- **Result**: tool0 = R-center + [0, -488, 0] + [0, +488, -1000] = **R-center + [0, 0, -1000]**

---

## 📐 Coordinate Systems

### Floor Coordinate System

```
Floor (Absolute reference):
  Origin: Physical floor at shop location
  X+ = Right (material flow direction)
  Y+ = Up (vertical)
  Z+ = Vertical up
  R=0: Gantry parallel to Y-axis (perpendicular to X-axis)
```

### Gantry Physical vs Floor Coordinates

| Physical | Floor | Transformation |
|----------|-------|----------------|
| [0, 0, 0, 0] | [9500, 5300, 2100, 0] | Floor = Physical + HOME_offset |
| eax_a | Floor_X - 9500 | Physical_X = Floor_X - 9500 |
| eax_b | 5300 - Floor_Y | Physical_Y = 5300 - Floor_Y |
| eax_c | 2100 - Floor_Z | Physical_Z = 2100 - Floor_Z |
| eax_d | 0 - Floor_R | Physical_R = -Floor_R |

### R-axis Rotation Center

```
R-center (Floor coordinates):
  X = 9500 mm (Physical X = 0)
  Y = 5300 mm (Physical Y = 0)
  Z = 2100 mm (Physical Z = 0)

  Robot1 base: R-center + [0, +488, 0]
  Robot2 base: R-center + [0, -488, 0]

  Distance between bases: 976mm (488 × 2)
```

---

## 🔄 Why Rotation Transformation is Required

### Robot1: No transformation needed ✅

- **Reason**: Configured with gantry
- **Behavior**: ABB controller knows gantry position
- `CRobT(\Tool:=tool0\WObj:=WobjFloor)` **automatically handles rotation**
- Simple direct reading works perfectly

### Robot2: Rotation transformation required ⚠️

- **Reason**: **NOT** configured with gantry
- **Behavior**: ABB controller thinks Robot2 base is fixed
- `CRobT(\Tool:=tool0\WObj:=WobjFloor)` gives **WRONG values** during rotation
- **Must calculate manually**

#### The Problem (v1.8.1 and earlier)

```rapid
! WRONG! Simple addition without rotation transformation
robot2_floor_pos.trans.x := base_floor_x + robot2_tcp_wobj0.trans.x;
robot2_floor_pos.trans.y := base_floor_y + robot2_tcp_wobj0.trans.y;
```

**Why it fails:**
- `robot2_tcp_wobj0` is in wobj0 coordinates (Robot2 base frame)
- **wobj0 rotates with gantry** but ABB controller doesn't know this!
- At R=0°: wobj0 Y-axis = Floor Y-axis ✅
- At R=90°: wobj0 Y-axis = Floor **X-axis** ❌
- **Cannot simply add!** Must rotate first!

#### The Solution (v1.8.5)

```rapid
! Convert gantry position to Floor coordinates
gantry_floor_x := current_gantry.extax.eax_a + 9500;
gantry_floor_y := 5300 - current_gantry.extax.eax_b;

! Robot2 base offset at R=0 is [0, -488] in Floor coordinates
! Rotate base offset with r_deg (no 90 deg offset)
base_floor_x := gantry_floor_x + 488 * Sin(r_deg);
base_floor_y := gantry_floor_y - 488 * Cos(r_deg);

! Apply 2D rotation transformation matrix
floor_x_offset := robot2_tcp_wobj0.trans.x * Cos(total_r_deg)
                - robot2_tcp_wobj0.trans.y * Sin(total_r_deg);
floor_y_offset := robot2_tcp_wobj0.trans.x * Sin(total_r_deg)
                + robot2_tcp_wobj0.trans.y * Cos(total_r_deg);

robot2_floor_pos.trans.x := base_floor_x + floor_x_offset;
robot2_floor_pos.trans.y := base_floor_y + floor_y_offset;
```

**Rotation matrix:**
```
[cos(θ)  -sin(θ)]   [x_wobj0]   [x_floor]
[sin(θ)   cos(θ)] × [y_wobj0] = [y_floor]

where θ = total_r_deg = r_deg
```

---

## 🧪 Expected Test Results (v1.8.5)

With both TCP at R-center, **rotation should NOT change TCP coordinates**:

| R Angle | Robot1 Floor TCP | Robot2 Floor TCP | Match? |
|---------|------------------|------------------|--------|
| -90° | [9500, 5300, 1100] | [9500, 5300, 1100] | ✅ |
| -45° | [9500, 5300, 1100] | [9500, 5300, 1100] | ✅ |
| 0° | [9500, 5300, 1100] | [9500, 5300, 1100] | ✅ |
| +45° | [9500, 5300, 1100] | [9500, 5300, 1100] | ✅ |
| +90° | [9500, 5300, 1100] | [9500, 5300, 1100] | ✅ |

**All Z = 1100mm** (1000mm below R-center at Z=2100mm)

---

## 📊 Previous Test Results (v1.8.1 - WRONG)

| R Angle | Robot1 Floor TCP | Robot2 Floor TCP | Error |
|---------|------------------|------------------|-------|
| 0° | [9500, 5300, 1100] | [9500, 5300, 1100] | ✅ 0mm |
| -45° | [9500, 5300, 1100] | [9845, 5443, 1100] | ❌ 488mm |
| -90° | [9500, 5300, 1100] | [9988, 5788, 1100] | ❌ 690mm |
| +45° | [9500, 5300, 1100] | [9155, 5443, 1100] | ❌ 488mm |
| +90° | [9500, 5300, 1100] | [9012, 5788, 1100] | ❌ 690mm |

**Pattern**: Error increases with rotation angle (simple addition error)

---

## 🔧 Code Reference

**File**: `RAPID/SpGantry_1200_526406_BACKUP_2025-12-18/RAPID/TASK1/PROGMOD/MainModule.mod`

**Procedure**: `UpdateRobot2BaseDynamicWobj()`

**Critical Lines**:
- Lines 1159-1161: Variable declarations (floor_x_offset, floor_y_offset, floor_z_offset)
- Lines 1230-1232: **Rotation transformation matrix** (v1.8.2 fix)
- Lines 1234-1236: Final Floor TCP calculation

---

## 📝 Key Takeaways

1. **Robot1 configured with gantry**: Simple, ABB handles everything ✅
2. **Robot2 NOT configured with gantry**: Must manually calculate with rotation ⚠️
3. **wobj0 rotates with robot base**: Cannot ignore rotation transformation! 🔄
4. **Both TCP at R-center**: Coordinates should match for all R angles 🎯
5. **This configuration must be documented**: Prevents future bugs! 📋

---

## 🚨 Common Mistakes to Avoid

1. ❌ **Assuming Robot2 can use WobjFloor directly**
   - Robot2 is NOT configured with gantry
   - ABB controller doesn't know Robot2 moved with gantry

2. ❌ **Simple addition of wobj0 coordinates to base**
   - wobj0 rotates with R-axis
   - Must apply rotation transformation

3. ❌ **Applying an extra 90 deg offset**
   - total_r_deg must equal r_deg
   - wobj0 aligns with Floor at R=0, so no 90 deg shift

4. ❌ **Modifying Robot2 HOME TCP to [0, 0, -1000]**
   - Robot2 base is **NOT at R-center**
   - Robot2 base is at R-center + [0, **-488**, 0]
   - TCP must be [0, **+488**, -1000] to reach R-center

---

**Last verified**: 2026-01-04 (v1.8.5)
**Maintainer**: SP 심태양
**Project**: S25016 SpGantry 1200
