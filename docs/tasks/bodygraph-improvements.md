# Bodygraph Chart Improvements

## Overview

Improve the bodygraph visualization to match professional Human Design chart standards.

## Reference

![Reference Chart](https://images.squarespace-cdn.com/content/v1/618f2fcb56b4c6279895259b/e66c2f2f-902b-4c53-8625-a0fbeb9a528e/human+design+chart+black+and+red+conscious+and+unconscious)

## Current Issues

1. **Missing inactive channels**: Only active/defined channels are displayed. All 36 channels should be visible at all times.
2. **No human silhouette**: The chart lacks the characteristic human body outline that gives context to center positions.

## Requirements

### 1. Show All Channels (Paths)

**Current behavior:** Only channels that are defined (both gates active) are drawn.

**Desired behavior:**
- All 36 channels should always be visible
- Inactive channels: Light gray or faded stroke
- Active channels: Full color (red for unconscious, black for conscious, striped for both)

**Implementation:**
- Modify `bodygraph_painter.dart` or channel widgets
- Draw all channels from `HumanDesignConstants.channels`
- Apply different styling based on activation state

### 2. Human Silhouette Background

**Current behavior:** Centers and channels float without body context.

**Desired behavior:**
- Human figure silhouette behind the chart elements
- Subtle/faded so it doesn't compete with chart data
- Anatomically positions centers correctly (Head at top, Root at bottom, etc.)

**Implementation options:**

**Option A: SVG Asset**
- Create/obtain SVG silhouette
- Add to `assets/images/bodygraph_silhouette.svg`
- Render as background layer in bodygraph widget

**Option B: Custom Paint**
- Draw silhouette path in `CustomPainter`
- More control but more complex

**Option C: PNG Asset with Transparency**
- Simpler implementation
- Add to `assets/images/bodygraph_silhouette.png`
- Use as `Image` widget behind chart

**Recommendation:** Option A (SVG) for scalability and crisp rendering at any size.

## Files to Modify

```
lib/features/chart/presentation/widgets/bodygraph/bodygraph_widget.dart
lib/features/chart/presentation/widgets/bodygraph/bodygraph_painter.dart
lib/features/chart/presentation/widgets/bodygraph/channel_painter.dart (if exists)
```

## Files to Create

```
assets/images/bodygraph_silhouette.svg (or .png)
```

## Task Checklist

- [x] Show all 36 channels in bodygraph (active and inactive)
- [x] Style inactive channels with faded/gray appearance
- [x] Style active channels with proper coloring (conscious/unconscious/both)
- [x] Create or obtain human silhouette asset
- [x] Add silhouette as background layer in bodygraph widget
- [x] Ensure silhouette scales correctly with chart
- [x] Test on various screen sizes
- [x] Verify chart accuracy against reference
- [x] Update color scheme to match style guide (purple theme)
- [x] Fix gate positions (Sacral bottom: 42, 3, 9)

## Color Scheme (Style Guide - Purple Theme)

| Element | Fill Color | Border Color | Hex Values |
|---------|------------|--------------|------------|
| Defined Centers | Light purple | Dark purple | #DDD6FE / #7C3AED |
| Undefined Centers | White | Light purple | #FFFFFF / #C4B5FD |
| Conscious Channels/Gates | Dark indigo | - | #3730A3 |
| Unconscious Channels/Gates | Pink/magenta | - | #DB2777 |
| Both (Conscious + Unconscious) | Violet | - | #7C3AED |
| Inactive Channels/Gates | Light purple tint | - | #E9D5FF |
| Transit Overlay | Cyan | - | #0891B2 |

## Channel Styling Guide

| State | Description | Color/Style |
|-------|-------------|-------------|
| Inactive | Neither gate defined | Light purple tint (#E9D5FF), thin stroke |
| Conscious only | Both gates from personality | Dark indigo (#3730A3) solid |
| Unconscious only | Both gates from design | Pink/magenta (#DB2777) solid |
| Mixed | One gate conscious, one unconscious | Striped (indigo + pink) |
| Full | Both gates have both conscious + unconscious | Violet (#7C3AED) bold |

## Visual Hierarchy

1. **Background layer**: Human silhouette (very subtle, ~10-20% opacity)
2. **Channel layer**: All 36 channels (inactive gray, active colored)
3. **Center layer**: 9 centers (undefined white/open, defined colored)
4. **Gate layer**: Gate numbers/indicators (optional overlay)
5. **Interaction layer**: Touch targets for details

## Notes

- The silhouette should be gender-neutral or offer options
- Consider dark mode compatibility (silhouette may need inverted version)
- Maintain current touch/tap interactions for gate/channel details

---

## Planets Tab (Completed)

Added a new "Planets" tab in the Chart screen to display Design and Personality planetary activations.

### Layout

```
┌──────────────────────┬──────────────────────┐
│       DESIGN         │     PERSONALITY      │
│    (Unconscious)     │     (Conscious)      │
│                      │                      │
│  ☉ Sun  19.2         │  ☉ Sun  41.3         │
│  ⊕ Earth 33.1        │  ⊕ Earth 31.4        │
│  ☽ Moon  6.5         │  ☽ Moon 28.2         │
│  ☊ N.Node 44.2       │  ☊ N.Node 15.6       │
│  ☋ S.Node 26.4       │  ☋ S.Node 10.1       │
│  ☿ Mercury 47.3      │  ☿ Mercury 64.5      │
│  ♀ Venus 12.1        │  ♀ Venus 47.2        │
│  ♂ Mars 35.6         │  ♂ Mars 36.3         │
│  ♃ Jupiter 22.4      │  ♃ Jupiter 59.1      │
│  ♄ Saturn 57.2       │  ♄ Saturn 44.6       │
│  ♅ Uranus 20.1       │  ♅ Uranus  3.4       │
│  ♆ Neptune 55.3      │  ♆ Neptune 22.5      │
│  ♇ Pluto 30.2        │  ♇ Pluto 41.1        │
└──────────────────────┴──────────────────────┘
       LEFT (Pink)           RIGHT (Indigo)
```

### Files Created

| File | Purpose |
|------|---------|
| `lib/features/chart/presentation/widgets/bodygraph/planetary_panel.dart` | Panel widget with header and planet rows |
| `lib/features/chart/presentation/widgets/bodygraph/planet_activation_row.dart` | Individual planet row (symbol, name, gate.line) |

### Files Modified

| File | Changes |
|------|---------|
| `lib/features/chart/presentation/chart_screen.dart` | Added Planets tab with `_PlanetsTab` widget |
| `lib/l10n/app_en.arb` | Added `chart_planets`, `planetary_personality`, `planetary_design`, `planetary_consciousBirth`, `planetary_unconsciousPrenatal` |

### Features

- **Design Panel (Left)** - Shows unconscious/prenatal activations in pink (#DB2777)
- **Personality Panel (Right)** - Shows conscious/birth activations in indigo (#3730A3)
- **HD Standard Planet Order** - Sun, Earth, Moon, North/South Node, Mercury, Venus, Mars, Jupiter, Saturn, Uranus, Neptune, Pluto
- **Gate.Line Notation** - Displays gate and line (e.g., "41.3") from `GateActivation.notation`
- **Tappable Rows** - Tap any planet row to view gate details in bottom sheet
- **Responsive** - Shows planet names when screen width >= 500px
- **Centered Layout** - Panels are centered on screen with explicit width (120px compact, 160px with names)

### Bug Fixes Applied

1. **Blank Screen Fix** - Added explicit `SizedBox` width constraints to panels (was blank due to `Row` with `mainAxisSize: MainAxisSize.min` and no intrinsic width)
2. **Panel Width** - Set panel width to 120px (compact) or 160px (with names) for consistent display
