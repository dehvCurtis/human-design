# Human Design Reference

## Types (5)

| Type | Strategy | Population |
|------|----------|------------|
| Generator | To Respond | 37% |
| Manifesting Generator | To Respond | 33% |
| Projector | Wait for Invitation | 20% |
| Manifestor | To Inform | 9% |
| Reflector | Wait Lunar Cycle | 1% |

## Authority (7)

1. Emotional (Solar Plexus)
2. Sacral
3. Splenic
4. Ego/Heart
5. Self-Projected
6. Mental/Environment
7. Lunar (Reflectors only)

## Centers (9)

Head, Ajna, Throat, G/Identity, Heart/Ego, Sacral, Solar Plexus, Spleen, Root

### Center Shapes (Bodygraph Visualization)

| Center | Shape | Position |
|--------|-------|----------|
| Head | Triangle (up) | Top |
| Ajna | Triangle (down) | Below Head |
| Throat | Square | Center-top |
| G/Identity | Heart | Center |
| Heart/Ego | Circle | Right of G |
| Sacral | Square | Center-bottom |
| Solar Plexus | Triangle (left) | Lower right |
| Spleen | Triangle (right) | Lower left |
| Root | Square | Bottom |

## Chart Calculation

### Overview

1. Convert birth datetime to UTC
2. Calculate Julian Day number
3. Calculate planetary positions using Swiss Ephemeris (conscious)
4. Find 88° prenatal date (unconscious/Design)
5. **Apply 58° HD wheel offset** to convert tropical longitude to HD gate position
6. Map degrees → gates → lines
7. Determine channels (both gates active)
8. Determine defined centers
9. Calculate Type, Authority, Profile, Definition

### HD Wheel Offset (Critical)

The Human Design wheel is **NOT** aligned with 0° Aries. The HD mandala has a 58° offset from the tropical zodiac:

| Reference Point | Tropical Longitude | HD Gate |
|----------------|-------------------|---------|
| 0° Aries (Spring Equinox) | 0° | Gate 25 |
| Gate 41 start | 302° (2° Aquarius) | Gate 41 |

**Implementation:**
```dart
// Add 58° to tropical longitude before looking up gate
double hdWheelPosition = (tropicalLongitude + 58.0) % 360;
int gateIndex = (hdWheelPosition / 5.625).floor();
int gateNumber = gateWheelSequence[gateIndex];
```

Without this offset, all gates will be wrong by approximately 10 positions.

### Gate Mapping

- 360° ÷ 64 gates = **5.625° per gate**
- 5.625° ÷ 6 lines = **0.9375° per line**
- Gates follow a specific sequence around the wheel (not 1, 2, 3...)
- The sequence starts with Gate 41 at 0° of the HD wheel (302° tropical)

### Planetary Bodies (13)

| Planet | Symbol | Notes |
|--------|--------|-------|
| Sun | ☉ | Primary, determines Incarnation Cross |
| Earth | ⊕ | Always opposite Sun (180°) |
| Moon | ☽ | Emotional/intuitive |
| North Node | ☊ | Life direction |
| South Node | ☋ | Always opposite North Node |
| Mercury | ☿ | Communication |
| Venus | ♀ | Values/relationships |
| Mars | ♂ | Action/drive |
| Jupiter | ♃ | Expansion |
| Saturn | ♄ | Structure/discipline |
| Uranus | ♅ | Innovation |
| Neptune | ♆ | Spirituality |
| Pluto | ♇ | Transformation |

### Conscious vs Unconscious

- **Conscious (Personality)**: Calculated at birth moment
- **Unconscious (Design)**: Calculated when Sun was 88° earlier (~88 days before birth)

### Profile Calculation

Profile comes from the **line numbers** of the Conscious and Unconscious Sun:
- Conscious Sun Line / Unconscious Sun Line
- Example: Sun in Gate 25.**2** / Design Sun in Gate 10.**5** = Profile **2/5**

### Incarnation Cross

Formed by the Sun/Earth gates at both conscious and unconscious positions:
- Format: Conscious Sun/Conscious Earth | Design Sun/Design Earth
- Example: 25/46 | 10/15 = "Right Angle Cross of the Vessel of Love"

## Gates & Channels

- 64 gates (mapped to I Ching hexagrams)
- 36 channels (connect 2 centers)
- Each gate has 6 lines (plus color, tone, base for advanced analysis)
- A channel is "defined" when both of its gates are activated (either conscious or unconscious)

### Channel Activation States

| State | Visual | Description |
|-------|--------|-------------|
| **Full Channel** | Full line | Both gates active (channel is defined) |
| **Hanging Gate** | Half line | Only one gate active (channel not defined) |
| **Inactive** | Gray line | Neither gate active |

### Hanging Gates

When only one gate of a channel is activated, it creates a "hanging gate" or "open gate":
- Displayed as a half-line extending from the center to the channel midpoint
- Represents potential for connection if the other gate becomes activated (through transit or relationship)
- Color indicates activation type:
  - **Black** - Conscious (Personality) activation
  - **Red** - Unconscious (Design) activation
  - **Striped** - Both conscious and unconscious

## Verifying Chart Accuracy

To verify calculations match reference sites:

1. Go to https://www.humdes.com/en/ravechart/
2. Enter the same birth data
3. Compare key values:
   - Conscious Sun gate.line
   - Design Sun gate.line
   - Type, Profile, Authority
   - Incarnation Cross
