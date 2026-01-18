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

- [ ] Show all 36 channels in bodygraph (active and inactive)
- [ ] Style inactive channels with faded/gray appearance
- [ ] Style active channels with proper coloring (conscious/unconscious/both)
- [ ] Create or obtain human silhouette asset
- [ ] Add silhouette as background layer in bodygraph widget
- [ ] Ensure silhouette scales correctly with chart
- [ ] Test on various screen sizes
- [ ] Verify chart accuracy against reference

## Channel Styling Guide

| State | Description | Color/Style |
|-------|-------------|-------------|
| Inactive | Neither gate defined | Light gray, thin stroke |
| Conscious only | Both gates from personality (black) | Black/dark solid |
| Unconscious only | Both gates from design (red) | Red solid |
| Mixed | One gate conscious, one unconscious | Striped or split color |
| Full | Both gates have both conscious + unconscious | Bold, possibly outlined |

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
