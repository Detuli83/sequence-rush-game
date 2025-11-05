# Sequence Rush - Game Assets & Design Specifications

**Version:** 1.0  
**Date:** November 5, 2025  
**For:** Designers, Developers, Artists  
**Game:** Sequence Rush  

---

## 1. ASSET OVERVIEW

This document provides complete specifications for all visual, audio, and UI assets required for Sequence Rush. All assets should maintain consistent quality, style, and optimization for mobile devices.

**Asset Categories:**
- UI/UX Elements
- Game Components
- Icons & Buttons
- Visual Effects
- Audio Assets
- Marketing Materials

**Design Philosophy:**
- Minimalist and modern
- High contrast for accessibility
- Smooth animations at 60 FPS
- Optimized file sizes for mobile
- Scalable vector graphics where possible

---

## 2. BRANDING ASSETS

### 2.1 Logo Specifications

**Primary Logo:**
- Type: Wordmark + Icon
- Icon: 4-color grid (Red, Blue, Green, Yellow)
- Font: Bold, rounded sans-serif (similar to Poppins Bold or Montserrat Bold)
- Colors: Gradient from #FF3B30 to #007AFF

**Logo Variations Required:**
- Full color on white background
- Full color on dark background
- Monochrome white (for dark backgrounds)
- Monochrome black (for light backgrounds)
- Icon only (square, for app icon)

**File Formats:**
- Vector: .SVG, .AI (master files)
- Raster: .PNG with transparency (multiple sizes)

**Sizes Needed:**
- 1024×1024 (App Store icon source)
- 512×512 (Play Store icon source)
- 256×256, 128×128, 64×64, 32×32 (various uses)

### 2.2 App Icon

**Design Elements:**
- 4 colorful squares in 2×2 grid
- Slight 3D effect (subtle shadow/gradient)
- Rounded corners per platform guidelines
- No text (icon must work at small sizes)

**Color Scheme:**
```
Top-left: #FF3B30 (Red)
Top-right: #007AFF (Blue)
Bottom-left: #34C759 (Green)
Bottom-right: #FFCC00 (Yellow)
Background: White or subtle gradient
```

**Platform-Specific Guidelines:**
- **iOS:** No rounded corners in source (iOS applies automatically)
- **Android:** Can include subtle shadow/depth
- **Both:** Ensure icon looks good at 40×40 pixels

**Deliverables:**
```
ios/
  AppIcon.appiconset/
    Icon-20@2x.png (40×40)
    Icon-20@3x.png (60×60)
    Icon-29@2x.png (58×58)
    Icon-29@3x.png (87×87)
    Icon-40@2x.png (80×80)
    Icon-40@3x.png (120×120)
    Icon-60@2x.png (120×120)
    Icon-60@3x.png (180×180)
    Icon-1024.png (1024×1024)

android/
  mipmap-mdpi/ (48×48)
  mipmap-hdpi/ (72×72)
  mipmap-xhdpi/ (96×96)
  mipmap-xxhdpi/ (144×144)
  mipmap-xxxhdpi/ (192×192)
  play-store-icon.png (512×512)
```

### 2.3 Typography

**Primary Font: Poppins**
- Headings: Poppins Bold (600-700 weight)
- Body text: Poppins Regular (400 weight)
- Buttons: Poppins SemiBold (600 weight)
- Numbers/Score: Poppins Bold (700 weight)

**Fallback Fonts:**
- iOS: San Francisco
- Android: Roboto

**Font Sizes (scaled for mobile):**
```
H1 (Main title): 32sp / 36pt
H2 (Section headers): 24sp / 28pt
H3 (Subsections): 20sp / 24pt
Body: 16sp / 18pt
Small text: 14sp / 16pt
Tiny (legal): 12sp / 14pt
Button text: 18sp / 20pt
```

### 2.4 Color System

**Primary Palette (Button Colors):**
```css
--color-red: #FF3B30
--color-blue: #007AFF
--color-green: #34C759
--color-yellow: #FFCC00
--color-orange: #FF9500
--color-purple: #AF52DE
--color-pink: #FF2D55
--color-cyan: #5AC8FA
```

**UI Colors (Dark Theme):**
```css
--bg-primary: #1C1C1E
--bg-secondary: #2C2C2E
--bg-tertiary: #3A3A3C
--text-primary: #FFFFFF
--text-secondary: #EBEBF5
--text-tertiary: #AEAEB2
--accent: #007AFF
--success: #34C759
--warning: #FF9500
--error: #FF3B30
```

**UI Colors (Light Theme):**
```css
--bg-primary: #FFFFFF
--bg-secondary: #F2F2F7
--bg-tertiary: #E5E5EA
--text-primary: #000000
--text-secondary: #3C3C43
--text-tertiary: #8E8E93
--accent: #007AFF
--success: #34C759
--warning: #FF9500
--error: #FF3B30
```

---

## 3. UI COMPONENTS

### 3.1 Buttons

**Primary Button (Call-to-Action):**
```
Style: Filled, rounded corners (12px radius)
Height: 50dp / 56pt
Padding: 16dp horizontal
Background: Linear gradient (#007AFF to #0051D5)
Text: White, Poppins SemiBold, 18sp
Shadow: 0 4px 12px rgba(0,122,255,0.3)
States: Normal, Pressed (90% opacity), Disabled (50% opacity)
```

**Secondary Button:**
```
Style: Outlined, rounded corners (12px radius)
Height: 50dp / 56pt
Padding: 16dp horizontal
Border: 2px solid #007AFF
Background: Transparent
Text: #007AFF, Poppins SemiBold, 18sp
States: Normal, Pressed (10% blue background), Disabled
```

**Icon Button (Power-ups, Settings):**
```
Size: 44×44dp (minimum touch target)
Shape: Circle or rounded square
Background: Semi-transparent white/black
Icon: 24×24dp
Shadow: 0 2px 8px rgba(0,0,0,0.2)
```

**Button States Animation:**
- Press: Scale to 0.95 over 100ms
- Release: Scale to 1.0 over 100ms
- Success: Brief green glow (200ms)
- Error: Shake animation (300ms)

### 3.2 Game Buttons (Color Tiles)

**Default State:**
```
Size: Dynamic (fills grid with spacing)
Minimum: 80×80dp
Shape: Rounded square (16px radius)
Background: Solid color from palette
Border: None
Shadow: 0 4px 8px rgba(0,0,0,0.15)
```

**Memorize Phase (Highlighting):**
```
Transform: Scale 1.1
Glow effect: 0 0 20px [button-color]
Duration: 300ms
Sound: Unique tone per color
```

**Execute Phase - Correct Tap:**
```
Background: Briefly flash white
Border: 3px solid #34C759 (green)
Duration: 200ms
Sound: Pleasant chime
```

**Execute Phase - Wrong Tap:**
```
Shake animation: ±5px horizontal
Background: Brief red overlay
Duration: 300ms
Sound: Error buzz
```

**Visual Feedback:**
- Ripple effect on tap (Material Design style)
- Haptic feedback on tap (if enabled)
- Color desaturation when disabled

### 3.3 Progress Indicators

**Level Progress Bar:**
```
Height: 8dp
Border radius: 4dp
Background: #E5E5EA (light) / #3A3A3C (dark)
Fill: Linear gradient (#34C759 to #30D158)
Animation: Smooth fill over 300ms
```

**Timer (Circular):**
```
Size: 60×60dp
Stroke width: 6dp
Background stroke: #E5E5EA (20% opacity)
Progress stroke: #FF3B30 (red for urgency)
Text: Remaining seconds, center aligned
Animation: Smooth countdown, pulse when <3 seconds
```

**Loading Spinner:**
```
Size: 40×40dp
Type: Circular, indeterminate
Color: #007AFF
Duration: 1 second per rotation
```

### 3.4 Cards & Containers

**Info Card:**
```
Background: White (light) / #2C2C2E (dark)
Border radius: 16px
Padding: 16dp
Shadow: 0 4px 12px rgba(0,0,0,0.08)
```

**Achievement Card:**
```
Background: Gradient based on achievement tier
Border: 2px solid gold/silver/bronze
Icon: 64×64dp
Title: H3 style
Description: Body style
Border radius: 12px
```

### 3.5 Modal Dialogs

**Standard Modal:**
```
Width: 90% of screen (max 400dp)
Background: White (light) / #2C2C2E (dark)
Border radius: 20px
Padding: 24dp
Shadow: 0 8px 24px rgba(0,0,0,0.3)
Backdrop: 50% black overlay
Animation: Slide up from bottom (300ms)
```

**Modal Types Needed:**
- Level Complete
- Game Over
- Power-up Selection
- Settings
- Shop
- Achievement Unlocked
- Daily Challenge

---

## 4. GAME SCREEN LAYOUTS

### 4.1 Main Menu

**Layout Structure:**
```
┌─────────────────────────────────┐
│  [⚙️]              [🛒]         │ 40dp top bar
│                                  │
│                                  │ 60dp spacer
│       🎮 SEQUENCE RUSH          │ Logo area
│                                  │
│                                  │ 40dp spacer
│  ┌──────────────────────────┐  │
│  │      PLAY NOW            │  │ Primary button
│  └──────────────────────────┘  │
│                                  │ 20dp spacer
│  ┌──────────────────────────┐  │
│  │    DAILY CHALLENGE       │  │ Secondary button
│  └──────────────────────────┘  │
│                                  │ 40dp spacer
│  Level: 15    Lives: ♥♥♥♥♥    │ Status bar
│  Coins: 250   Gems: 10         │
│                                  │ 20dp spacer
│  ┌──────┐ ┌──────┐ ┌──────┐   │
│  │ 🏆   │ │ 📊   │ │ 👥   │   │ Quick access
│  └──────┘ └──────┘ └──────┘   │
│                                  │
└─────────────────────────────────┘
```

**Assets Needed:**
- Background (solid color or subtle gradient)
- Logo (centered, animated on load)
- Settings icon (top-left)
- Shop icon (top-right)
- Heart icons (lives indicator)
- Coin icon
- Gem icon
- Achievement, stats, friends icons

### 4.2 Game Screen

**Layout Structure:**
```
┌─────────────────────────────────┐
│ Lvl 15  ⏱️ 00:12  ♥♥♥        │ Top bar (40dp)
├─────────────────────────────────┤
│                                  │
│  ┌─────┐     ┌─────┐           │
│  │  🔴 │     │  🔵 │           │ 2×2 grid
│  └─────┘     └─────┘           │ (or 2×3, 3×3)
│                                  │
│  ┌─────┐     ┌─────┐           │
│  │  🟢 │     │  🟡 │           │
│  └─────┘     └─────┘           │
│                                  │
├─────────────────────────────────┤
│  [💡] [⏰] [🐌]      Score: 450 │ Bottom bar (60dp)
└─────────────────────────────────┘
```

**Grid Variations:**
- 2×2 grid: Levels 1-20 (4 colors)
- 2×3 grid: Levels 21-40 (6 colors)
- 3×3 grid: Levels 41+ (8-9 colors)

**Assets Needed:**
- Top bar background (slight transparency)
- Timer icon and display
- Lives hearts (filled/empty states)
- Color buttons (8 colors, each with multiple states)
- Power-up icons (hint, extra time, slow-mo)
- Score display
- Bottom bar background

### 4.3 Level Complete Screen

**Layout Structure:**
```
┌─────────────────────────────────┐
│                                  │
│        ✨ LEVEL 15 ✨          │ Title
│         COMPLETE!               │
│                                  │
│  ⭐ ⭐ ⭐                       │ Stars (3-star rating)
│                                  │
│  Score: 450                     │ Stats
│  Time: 7.2s                     │
│  Combo: 5x                      │
│                                  │
│  + 50 coins                     │ Rewards
│  + 10 gems                      │
│                                  │
│  ┌──────────────────────────┐  │
│  │      CONTINUE            │  │ Primary CTA
│  └──────────────────────────┘  │
│                                  │
│  [🔁 Replay]  [📤 Share]       │ Secondary actions
│                                  │
└─────────────────────────────────┘
```

**Assets Needed:**
- Celebration background (confetti particles)
- Star icons (filled/unfilled)
- Stat icons
- Coin and gem icons
- Button assets

---

## 5. VISUAL EFFECTS

### 5.1 Particle Effects

**Success Confetti:**
```
Particle count: 30-50
Colors: Random from color palette
Size: 4-8dp
Duration: 1.5 seconds
Physics: Gravity + random velocity
Spawn: Center of screen, burst outward
```

**Button Tap Ripple:**
```
Type: Expanding circle
Color: White with fade
Duration: 400ms
Max radius: 1.5× button size
Opacity: Start 0.4, end 0
```

**Glow Effect (Sequence Highlight):**
```
Type: Soft glow around button
Color: Same as button, 50% brighter
Blur radius: 20px
Duration: 300ms fade in/out
Pulsing: Optional for emphasis
```

**Coin Collection:**
```
Particle: Spinning coin sprite
Duration: 800ms
Path: Curved trajectory to coin counter
Scale: Start 1.0, end 0.5
Sound: Coin pickup sound
```

### 5.2 Screen Transitions

**Page Transitions:**
```
Type: Slide + fade
Duration: 300ms
Easing: Ease-out cubic
Direction: Left/right for horizontal nav, up/down for modals
```

**Modal Transitions:**
```
In: Slide up from bottom + fade in backdrop
Out: Slide down + fade out backdrop
Duration: 250ms
Backdrop: Fade to 50% black over 200ms
```

### 5.3 Animation Specifications

**Button Press Animation:**
```dart
AnimationController(
  duration: Duration(milliseconds: 100),
  vsync: this,
)..forward().then((_) => controller.reverse());

Tween<double>(begin: 1.0, end: 0.95)
```

**Sequence Highlight Animation:**
```dart
AnimationController(
  duration: Duration(milliseconds: 300),
  vsync: this,
);

ColorTween(
  begin: buttonColor,
  end: buttonColor.withBrightness(1.5),
)

ScaleTween(begin: 1.0, end: 1.1)
```

**Shake Animation (Error):**
```dart
AnimationController(
  duration: Duration(milliseconds: 300),
  vsync: this,
);

// Oscillate horizontally
Tween<Offset>(
  begin: Offset(-0.05, 0),
  end: Offset(0.05, 0),
).chain(CurveTween(curve: Curves.elasticIn))
```

---

## 6. AUDIO ASSETS

### 6.1 Sound Effects

**Button Sounds (8 unique tones):**
```
Red Button: C4 (261.63 Hz) - 200ms duration
Blue Button: E4 (329.63 Hz) - 200ms duration
Green Button: G4 (392.00 Hz) - 200ms duration
Yellow Button: C5 (523.25 Hz) - 200ms duration
Orange Button: D4 (293.66 Hz) - 200ms duration
Purple Button: F4 (349.23 Hz) - 200ms duration
Pink Button: A4 (440.00 Hz) - 200ms duration
Cyan Button: B4 (493.88 Hz) - 200ms duration

Format: .wav or .ogg
Bitrate: 192 kbps
File size: <50KB each
```

**UI Sounds:**
```
Success chime: Ascending arpeggio (C-E-G-C), 500ms
Error buzz: Low discordant tone, 300ms
Button click: Short click, 50ms
Coin pickup: Bright "ding", 200ms
Level complete: Victory fanfare, 2-3 seconds
Power-up activate: Magical swoosh, 400ms
Countdown warning: Urgent beep (last 3 seconds)
```

**Format Specifications:**
```
Format: .ogg (Android), .caf (iOS)
Sample rate: 44.1 kHz
Bit depth: 16-bit
Channels: Mono (for SFX), Stereo (for music)
```

### 6.2 Background Music

**Main Menu Music:**
```
Style: Upbeat, motivational
Tempo: 120 BPM
Length: 2 minutes (seamless loop)
Instruments: Synth, light percussion
Volume: -20dB (background level)
```

**Gameplay Music:**
```
Style: Minimal, focused, electronic ambient
Tempo: 100 BPM
Length: 3 minutes (seamless loop)
Instruments: Soft pads, subtle bass
Volume: -25dB (very background)
Note: Should not distract from button sound cues
```

**Victory Jingle:**
```
Style: Celebratory, short
Length: 3 seconds
Instruments: Bright synth, chimes
Volume: -15dB
```

### 6.3 Audio Implementation

**Flutter Audio Setup:**
```yaml
dependencies:
  flame_audio: ^2.1.0
  audioplayers: ^5.0.0
```

**Audio File Organization:**
```
assets/
  audio/
    sfx/
      button_red.ogg
      button_blue.ogg
      ...
      success.ogg
      error.ogg
      click.ogg
      coin.ogg
      level_complete.ogg
      powerup.ogg
    music/
      main_menu.ogg
      gameplay.ogg
      victory.ogg
```

---

## 7. ICONS & GRAPHICS

### 7.1 UI Icons

**Required Icons (24×24dp base):**
```
Settings: ⚙️ gear icon
Shop: 🛒 shopping cart
Close: ✕ cross
Back: ← arrow
Info: ℹ️ information circle
Heart (life): ♥ filled heart
Heart empty: ♡ outline heart
Coin: 🪙 circular coin
Gem: 💎 diamond shape
Star: ⭐ five-point star
Star empty: ☆ outline star
Lock: 🔒 padlock
Trophy: 🏆 award cup
Share: 📤 share arrow
Replay: 🔁 circular arrows
Play: ▶️ right triangle
Pause: ⏸ double bars
Volume on: 🔊 speaker with waves
Volume off: 🔇 muted speaker
```

**Format:**
- Vector: .SVG (preferred for Flutter)
- Raster: .PNG @1x, @2x, @3x for each icon
- Color: Single color (will be tinted via code)
- Style: Minimalist, rounded, consistent stroke width

### 7.2 Power-Up Icons

```
Hint: 💡 light bulb (64×64dp)
Extra Time: ⏰ clock with plus (64×64dp)
Slow Motion: 🐌 snail (64×64dp)
Skip Level: ⏭️ fast forward (64×64dp)
```

**Style:**
- Colorful, easily distinguishable
- Clear even at small sizes
- Consistent style with UI icons

### 7.3 Achievement Badges

**Tiers:**
```
Bronze: #CD7F32
Silver: #C0C0C0
Gold: #FFD700
Platinum: #E5E4E2 with rainbow effect
```

**Badge Template:**
- Size: 128×128dp
- Shape: Circle with decorative border
- Icon: Achievement-specific icon in center
- Style: 3D effect with subtle shadow

**Achievement Categories:**
- Progression (levels completed)
- Mastery (perfect levels, combos)
- Collection (themes unlocked)
- Social (friends, sharing)
- Daily (login streaks, challenges)

---

## 8. THEMES (VISUAL VARIANTS)

### 8.1 Classic Theme (Default)

**Colors:**
```
Background: #1C1C1E (dark) or #FFFFFF (light)
Buttons: Standard palette (red, blue, green, yellow)
UI: Default colors
```

### 8.2 Dark Mode Theme

**Colors:**
```
Background: Pure black #000000
Buttons: Slightly desaturated colors
UI: High contrast white text
```

### 8.3 Pastel Dreams Theme

**Colors:**
```
Background: Soft cream #FFF8F0
Buttons: Pastel variants
  Red → #FFB3BA
  Blue → #BAE1FF
  Green → #BAFFC9
  Yellow → #FFFFBA
```

### 8.4 Neon Nights Theme

**Colors:**
```
Background: Deep purple #1A0033
Buttons: Neon bright colors with glow
  Red → #FF006E
  Blue → #00F5FF
  Green → #39FF14
  Yellow → #FFFF00
```

### 8.5 Ocean Breeze Theme

**Colors:**
```
Background: Light blue gradient #E0F7FA to #B2EBF2
Buttons: Ocean-inspired blues and teals
  Red → #00ACC1
  Blue → #0288D1
  Green → #26A69A
  Yellow → #FFA726
```

### 8.6 Sunset Vibes Theme

**Colors:**
```
Background: Orange-pink gradient #FF6B6B to #FFE66D
Buttons: Warm sunset colors
  Red → #FF6B6B
  Blue → #A8E6CF
  Green → #FECA57
  Yellow → #FF9FF3
```

### 8.7 Forest Fresh Theme

**Colors:**
```
Background: Soft green #E8F5E9
Buttons: Nature-inspired greens and browns
  Red → #8D6E63
  Blue → #4DB6AC
  Green → #66BB6A
  Yellow → #FDD835
```

### 8.8 Galaxy Theme (Premium)

**Colors:**
```
Background: Deep space with stars (animated particles)
Buttons: Cosmic colors with shimmer effect
  Red → #E91E63 (pink)
  Blue → #3F51B5 (indigo)
  Green → #00BCD4 (cyan)
  Yellow → #FFC107 (amber)
```

**Implementation:**
- Each theme is a JSON color configuration
- Applied via ThemeManager class
- Smooth transitions when switching (300ms fade)

---

## 9. MARKETING ASSETS

### 9.1 App Store Screenshots

**Required Sizes (iOS):**
```
iPhone 6.7" (1290 × 2796 pixels)
iPhone 6.5" (1242 × 2688 pixels)
iPhone 5.5" (1242 × 2208 pixels)
iPad Pro 12.9" (2048 × 2732 pixels)
```

**Required Sizes (Android):**
```
Phone: 1080 × 1920 pixels
7" Tablet: 1200 × 1920 pixels
10" Tablet: 1600 × 2560 pixels
```

**Screenshot Set (5-10 screens):**
1. Hero shot: Gameplay with title overlay
2. Memorize phase: Sequence being shown
3. Execute phase: Timer counting down
4. Success: Level complete celebration
5. Features: Daily challenges screen
6. Social: Leaderboard view
7. Themes: Theme selection showcase
8. Progression: Level map overview

**Text Overlays:**
- Large, bold headlines
- Concise benefit statements
- High contrast for readability
- Consistent branding

### 9.2 App Preview Video

**Specifications:**
```
Resolution: 1080 × 1920 (portrait)
Duration: 15-30 seconds
Format: .mp4
Framerate: 30 fps
Bitrate: 8 Mbps
Audio: Background music + SFX
```

**Video Structure:**
```
0-3s: Logo reveal + tagline
3-8s: Gameplay demonstration (memorize)
8-13s: Gameplay demonstration (execute)
13-18s: Success animation + level complete
18-23s: Feature showcase (themes, challenges)
23-30s: CTA with app icon and title
```

### 9.3 Social Media Assets

**Profile Pictures (Circle crop):**
- 400×400 pixels (for all platforms)
- App icon or logo icon only
- No text (must work small)

**Cover/Banner Images:**
- Facebook: 820×312 pixels
- Twitter: 1500×500 pixels
- YouTube: 2560×1440 pixels
- Instagram: No banner, use highlights

**Post Templates (1080×1080 square):**
- Gameplay screenshot + text overlay
- Daily challenge announcement
- New level release
- Achievement spotlight
- Tips & tricks

**Story Templates (1080×1920 portrait):**
- Vertical gameplay clips
- User testimonials
- Behind-the-scenes
- Countdown to launch

---

## 10. ASSET DELIVERY FORMAT

### 10.1 Folder Structure

```
sequence_rush_assets/
├── branding/
│   ├── logo/
│   │   ├── logo_full_color.svg
│   │   ├── logo_white.svg
│   │   ├── logo_black.svg
│   │   └── icon_only.svg
│   └── app_icons/
│       ├── ios/
│       └── android/
├── ui/
│   ├── buttons/
│   ├── icons/
│   └── backgrounds/
├── game/
│   ├── color_buttons/
│   ├── particles/
│   └── effects/
├── audio/
│   ├── sfx/
│   └── music/
├── marketing/
│   ├── screenshots/
│   ├── video/
│   └── social_media/
└── documentation/
    └── asset_specifications.pdf
```

### 10.2 File Naming Conventions

```
Format: category_descriptor_variant_size.extension

Examples:
button_primary_normal_2x.png
icon_settings_white_24dp.svg
audio_button_red.ogg
screenshot_gameplay_iphone_1.png
logo_full_color.svg
```

### 10.3 Quality Checklist

**Before Delivery:**
- [ ] All assets in correct formats
- [ ] Multiple sizes provided where needed
- [ ] Consistent naming convention
- [ ] Organized folder structure
- [ ] No missing assets
- [ ] Optimized file sizes
- [ ] Vector formats for scalable assets
- [ ] Transparent backgrounds where appropriate
- [ ] Color profiles embedded (sRGB)
- [ ] Audio files normalized
- [ ] Test all assets in-game

---

## 11. OPTIMIZATION GUIDELINES

### 11.1 Image Optimization

**PNG Files:**
- Use PNG-8 for simple graphics (icons)
- PNG-24 for photos/gradients
- Compress with TinyPNG or similar (50-70% reduction)
- Remove metadata

**SVG Files:**
- Optimize with SVGO
- Remove unnecessary paths
- Simplify complex shapes
- Embed only necessary fonts

**Target Sizes:**
- Icons: <10KB each
- Buttons: <20KB each
- Backgrounds: <100KB
- Screenshots: <500KB

### 11.2 Audio Optimization

**Sound Effects:**
- Mono channel (stereo not needed)
- 44.1kHz sample rate
- 16-bit depth
- OGG format (better compression)
- Target: <50KB per SFX

**Music:**
- Stereo if needed
- 44.1kHz sample rate
- 128-192 kbps bitrate
- OGG format
- Loop points marked
- Target: <3MB per track

### 11.3 Performance Considerations

**Texture Atlases:**
- Combine small UI icons into single atlas
- Reduce draw calls
- Use Flutter's AssetImage caching

**Loading Strategy:**
- Preload critical assets (main menu)
- Lazy load themes and non-essential content
- Cache frequently used assets
- Unload unused assets

**Memory Budget:**
- Total assets in memory: <100MB
- Prioritize assets by screen
- Release assets when navigating away

---

## 12. ACCESSIBILITY REQUIREMENTS

### 12.1 Color Accessibility

**Contrast Ratios (WCAG AA):**
- Text on background: 4.5:1 minimum
- Large text: 3:1 minimum
- Interactive elements: 3:1 minimum

**Color Blindness Considerations:**
- Don't rely solely on color
- Add patterns/shapes as secondary cues
- Test with color blindness simulators
- Provide high contrast mode

### 12.2 Visual Accessibility

**Text:**
- Minimum font size: 14sp
- Clear, sans-serif fonts
- Adequate line spacing (1.5×)
- High contrast

**Touch Targets:**
- Minimum: 44×44dp (iOS), 48×48dp (Android)
- Adequate spacing between targets
- Clear visual feedback on tap

**Animations:**
- Respect "Reduce Motion" settings
- Provide option to disable animations
- Avoid rapid flashing (seizure risk)

---

## CONCLUSION

This asset specification document provides complete guidelines for all visual, audio, and UI elements needed for Sequence Rush. Following these specifications ensures:

- **Consistency** across all screens and platforms
- **Quality** that meets professional mobile game standards
- **Performance** optimized for mobile devices
- **Accessibility** for all users
- **Scalability** for future updates

**Next Steps:**
1. Review specifications with design team
2. Create asset production schedule
3. Set up asset management system
4. Begin asset creation
5. Regular review and iteration

---

**Document Status:** Complete  
**Owner:** Art Director / Lead Designer  
**Last Updated:** November 5, 2025
