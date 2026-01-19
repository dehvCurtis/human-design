# Bodygraph Chart Fix Plan

**Created:** 2026-01-17
**Status:** Ready for Implementation

## Overview

Fix three issues with the Human Design bodygraph chart visualization:
1. Weird silhouette shape - replace with proper SVG
2. Inactive channels not showing - fix channel data and path matching
3. Chart organization - verify all 36 channels exist and display correctly

---

## Issue 1: Body Silhouette

### Current Problem
The silhouette in `bodygraph_painter.dart` (lines 45-192) uses programmatic Bezier curves with unnatural proportions:
- Head too high at y=42
- Arms drawn with complex curves creating odd shapes
- Feet as simple line segments

### Solution: Create SVG Asset + Simplify Painter

**Step 1: Create SVG file**
Create `assets/svg/body_silhouette.svg` with:
- Viewbox: `0 0 400 600` (matching canvas)
- Minimalist human outline
- Semi-transparent (10-20% opacity)
- No internal details

**Step 2: Update bodygraph_widget.dart**
```dart
// Use Stack to layer SVG behind CustomPaint
Stack(
  children: [
    SvgPicture.asset(
      'assets/svg/body_silhouette.svg',
      width: constraints.maxWidth,
      height: constraints.maxHeight,
      fit: BoxFit.contain,
      colorFilter: ColorFilter.mode(
        AppColors.primary.withAlpha(20),
        BlendMode.srcIn,
      ),
    ),
    CustomPaint(
      painter: BodygraphPainter(
        chart: widget.chart,
        drawBody: false,  // Skip programmatic body
        ...
      ),
    ),
  ],
)
```

**Step 3: Add drawBody parameter to BodygraphPainter**
```dart
final bool drawBody;

void paint(Canvas canvas, Size size) {
  if (drawBody) {
    _drawBodySilhouette(canvas);
  }
  _drawChannels(canvas);
  ...
}
```

---

## Issue 2: Missing Inactive Channels

### Root Cause Analysis
1. `channels` list has 32 entries, should have 36
2. Some duplicate entries with different names
3. Channel paths may not match channel IDs

### Missing Channels
Based on audit against standard 36 Human Design channels:

| Gates | Name | Type | Status |
|-------|------|------|--------|
| 24-61 | Awareness | Individual | **MISSING** |
| 42-53 | Maturation | Collective | Path exists, entry missing |

### Duplicate Entries to Remove
- `57-20` "The Brain Wave" (Individual) - duplicate of `20-57` (Integration)

### Solution

**Step 1: Fix human_design_constants.dart (lines 189-232)**

Add missing channels:
```dart
ChannelData(gate1: 24, gate2: 61, name: 'Awareness', type: 'Individual'),
ChannelData(gate1: 42, gate2: 53, name: 'Maturation', type: 'Collective'),
```

Remove duplicate:
```dart
// Delete: ChannelData(gate1: 57, gate2: 20, name: 'The Brain Wave', type: 'Individual'),
```

Add to channelCenters map:
```dart
'24-61': [HumanDesignCenter.ajna, HumanDesignCenter.head],
'42-53': [HumanDesignCenter.sacral, HumanDesignCenter.root],
```

**Step 2: Fix bodygraph_data.dart channelPaths**

Add missing path:
```dart
'24-61': [Offset(200, 35), Offset(195, 90)],
```

Normalize all keys to smaller-gate-first format and remove duplicates.

---

## Issue 3: All 36 Channels Verification

### Complete Channel List

| # | Gates | Name | Has Entry | Has Path |
|---|-------|------|:---------:|:--------:|
| 1 | 1-8 | Inspiration | ✅ | ✅ |
| 2 | 2-14 | The Beat | ✅ | ✅ |
| 3 | 3-60 | Mutation | ✅ | ✅ |
| 4 | 4-63 | Logic | ✅ | ✅ |
| 5 | 5-15 | Rhythm | ✅ | ✅ |
| 6 | 6-59 | Intimacy | ✅ | ✅ |
| 7 | 7-31 | The Alpha | ✅ | ✅ |
| 8 | 9-52 | Concentration | ✅ | ✅ |
| 9 | 10-20 | Awakening | ✅ | ✅ |
| 10 | 10-34 | Exploration | ✅ | ✅ |
| 11 | 10-57 | Perfected Form | ✅ | ✅ |
| 12 | 11-56 | Curiosity | ✅ | ✅ |
| 13 | 12-22 | Openness | ✅ | ✅ |
| 14 | 13-33 | The Prodigal | ✅ | ✅ |
| 15 | 16-48 | The Wavelength | ✅ | ✅ |
| 16 | 17-62 | Acceptance | ✅ | ✅ |
| 17 | 18-58 | Judgment | ✅ | ✅ |
| 18 | 19-49 | Synthesis | ✅ | ✅ |
| 19 | 20-34 | Charisma | ✅ | ✅ |
| 20 | 20-57 | The Brainwave | ✅ | ✅ |
| 21 | 21-45 | Money | ✅ | ✅ |
| 22 | 23-43 | Structuring | ✅ | ✅ |
| 23 | 24-61 | Awareness | ❌ | ❌ |
| 24 | 25-51 | Initiation | ✅ | ✅ |
| 25 | 26-44 | Surrender | ✅ | ✅ |
| 26 | 27-50 | Preservation | ✅ | ✅ |
| 27 | 28-38 | Struggle | ✅ | ✅ |
| 28 | 29-46 | Discovery | ✅ | ✅ |
| 29 | 30-41 | Recognition | ✅ | ✅ |
| 30 | 32-54 | Transformation | ✅ | ✅ |
| 31 | 34-57 | Power | ✅ | ✅ |
| 32 | 35-36 | Transitoriness | ✅ | ✅ |
| 33 | 37-40 | Community | ✅ | ✅ |
| 34 | 39-55 | Emoting | ✅ | ✅ |
| 35 | 42-53 | Maturation | ❌ | ✅ |
| 36 | 47-64 | Abstraction | ✅ | ✅ |

---

## Files to Modify

| File | Changes |
|------|---------|
| `lib/core/constants/human_design_constants.dart` | Add 24-61, 42-53 channels; remove duplicate 57-20; update channelCenters |
| `lib/features/chart/presentation/widgets/bodygraph/bodygraph_data.dart` | Add 24-61 path; normalize key format; remove duplicate paths |
| `lib/features/chart/presentation/widgets/bodygraph/bodygraph_painter.dart` | Add `drawBody` parameter |
| `lib/features/chart/presentation/widgets/bodygraph/bodygraph_widget.dart` | Add Stack with SVG layer |
| `assets/svg/body_silhouette.svg` | **CREATE** - new SVG asset |
| `pubspec.yaml` | Add `assets/svg/` to assets list if not present |

---

## Implementation Order

1. **Channel Data Fixes** (Priority: High)
   - Add missing channels to constants
   - Add missing path for 24-61
   - Remove duplicates

2. **Body Silhouette** (Priority: Medium)
   - Create SVG asset
   - Update widget to use Stack
   - Add drawBody parameter

3. **Verification** (Priority: High)
   - Test all 36 channels render
   - Compare against reference chart

---

## SVG Template

```svg
<?xml version="1.0" encoding="UTF-8"?>
<svg viewBox="0 0 400 600" xmlns="http://www.w3.org/2000/svg">
  <!-- Minimalist human silhouette -->
  <defs>
    <linearGradient id="bodyGrad" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" style="stop-color:#6366f1;stop-opacity:0.1"/>
      <stop offset="50%" style="stop-color:#6366f1;stop-opacity:0.15"/>
      <stop offset="100%" style="stop-color:#6366f1;stop-opacity:0.1"/>
    </linearGradient>
  </defs>

  <!-- Head -->
  <ellipse cx="200" cy="50" rx="28" ry="32" fill="url(#bodyGrad)" stroke="#6366f1" stroke-opacity="0.3" stroke-width="1"/>

  <!-- Neck -->
  <rect x="185" y="78" width="30" height="20" fill="url(#bodyGrad)"/>

  <!-- Body (torso) -->
  <path d="M145 98 Q140 200 150 350 L160 480 Q180 510 200 510 Q220 510 240 480 L250 350 Q260 200 255 98 Q230 85 200 85 Q170 85 145 98 Z"
        fill="url(#bodyGrad)" stroke="#6366f1" stroke-opacity="0.3" stroke-width="1"/>

  <!-- Legs simplified -->
  <path d="M160 480 L155 580 L165 585 L175 500 L180 510" fill="url(#bodyGrad)"/>
  <path d="M240 480 L245 580 L235 585 L225 500 L220 510" fill="url(#bodyGrad)"/>
</svg>
```

---

## Verification

1. Run the app and navigate to chart screen
2. Verify silhouette appears as subtle background
3. Verify ALL 36 channels display (gray when inactive)
4. Verify active channels display in correct colors:
   - Black: conscious only
   - Red: unconscious only
   - Striped: both
5. Compare layout against reference: https://images.squarespace-cdn.com/content/v1/618f2fcb56b4c6279895259b/e66c2f2f-902b-4c53-8625-a0fbeb9a528e/human+design+chart+black+and+red+conscious+and+unconscious

---

## Notes

- The channel ID format uses smaller gate first: `1-8` not `8-1`
- The `_getChannelPath()` method tries both orderings for lookup
- SVG approach allows easier visual refinement without code changes
- Consider adding channel labels for educational features later
