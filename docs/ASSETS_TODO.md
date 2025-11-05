# Sequence Rush - Assets Creation Checklist

**Priority: HIGH - These assets are needed before development starts**

---

## 🎨 IMMEDIATE NEEDS (Week 1)

### 1. App Icon (CRITICAL)
**Due: Day 1-2**

Create a 1024×1024 pixel icon with:
- 2×2 grid of colored squares
- Colors: Red, Blue, Green, Yellow (top-left, top-right, bottom-left, bottom-right)
- Slight 3D effect or gradient
- Clean, modern look
- Works at small sizes

**Deliverables:**
- [ ] iOS sizes (20pt to 1024pt - multiple sizes)
- [ ] Android sizes (48dp to 512dp - multiple sizes)
- [ ] Source file (PSD/AI/Figma)

**Tools:** Figma, Adobe Illustrator, Sketch, or Canva

---

### 2. Color Button Assets
**Due: Day 3-5**

8 colored buttons in 3 states each = 24 total assets

**Colors:**
- Red (#FF3B30)
- Blue (#007AFF)
- Green (#34C759)
- Yellow (#FFCC00)
- Orange (#FF9500)
- Purple (#AF52DE)
- Pink (#FF2D55)
- Cyan (#5AC8FA)

**States:**
- Normal (solid color)
- Highlighted (brighter/glowing)
- Pressed (slightly darker)

**Specs:**
- Size: 200×200 pixels @3x (exports to 1x, 2x, 3x)
- Format: PNG with transparency
- Border radius: 32px
- Subtle shadow

**Deliverables:**
- [ ] 8 colors × 3 states = 24 PNG files
- [ ] Named: `button_[color]_[state].png`
- [ ] Source file

---

### 3. UI Icons (Basic Set)
**Due: Day 5-7**

20 essential icons at 24×24dp:

**Navigation & Actions:**
- [ ] Settings (gear icon)
- [ ] Close (X icon)
- [ ] Back (left arrow)
- [ ] Play (triangle)
- [ ] Pause (two bars)

**Game Elements:**
- [ ] Heart filled (lives)
- [ ] Heart empty
- [ ] Coin
- [ ] Gem/diamond
- [ ] Star filled
- [ ] Star empty
- [ ] Timer/clock

**Power-ups:**
- [ ] Light bulb (hint)
- [ ] Clock with plus (extra time)
- [ ] Snail (slow motion)

**Social:**
- [ ] Share arrow
- [ ] Trophy
- [ ] Lock
- [ ] Unlock

**Specs:**
- Size: 24×24dp base, export 1x, 2x, 3x
- Format: SVG (preferred) + PNG
- Style: Minimalist, line icons
- Single color (will be tinted in code)

---

## 🎵 AUDIO ASSETS (Week 2)

### 1. Button Sounds (CRITICAL)
**Due: Week 2, Day 1-2**

8 unique tones, one for each color:

**Musical Notes:**
- Red: C4 (261.63 Hz)
- Blue: E4 (329.63 Hz)
- Green: G4 (392.00 Hz)
- Yellow: C5 (523.25 Hz)
- Orange: D4 (293.66 Hz)
- Purple: F4 (349.23 Hz)
- Pink: A4 (440.00 Hz)
- Cyan: B4 (493.88 Hz)

**Specs:**
- Duration: 200ms
- Format: OGG
- Sample rate: 44.1 kHz
- Mono channel
- Target size: <50KB each

**Tools:** Audacity, GarageBand, or online tone generators

**Deliverables:**
- [ ] 8 button sound files
- [ ] Named: `button_[color].ogg`

---

### 2. UI Sound Effects
**Due: Week 2, Day 3-4**

Essential SFX:
- [ ] Success chime (ascending arpeggio, 500ms)
- [ ] Error buzz (low tone, 300ms)
- [ ] Click (short, 50ms)
- [ ] Coin pickup (bright ding, 200ms)
- [ ] Level complete (fanfare, 2-3s)
- [ ] Power-up activate (swoosh, 400ms)

**Specs:** Same as button sounds

---

### 3. Background Music (Optional - Week 3)
**Due: Week 3**

Two tracks:
- [ ] Main menu music (upbeat, 2 min loop, 120 BPM)
- [ ] Gameplay music (ambient, 3 min loop, 100 BPM)

**Specs:**
- Format: OGG
- Stereo
- 128-192 kbps
- Seamless loop

**Note:** Can use royalty-free music initially

---

## 📱 MARKETING ASSETS (Week 3-4)

### 1. App Store Screenshots
**Due: Week 3**

5-10 screenshots showing:
- [ ] Hero shot: Gameplay with overlay text
- [ ] Memorize phase
- [ ] Execute phase with timer
- [ ] Level complete celebration
- [ ] Daily challenges screen
- [ ] Themes showcase
- [ ] Leaderboard

**Sizes:**
- iPhone 6.7": 1290 × 2796
- iPhone 6.5": 1242 × 2688
- Android: 1080 × 1920

---

### 2. App Preview Video
**Due: Week 4**

15-30 second video:
- [ ] 0-3s: Logo reveal
- [ ] 3-13s: Gameplay demonstration
- [ ] 13-18s: Success animation
- [ ] 18-23s: Feature showcase
- [ ] 23-30s: CTA

**Specs:**
- Resolution: 1080 × 1920 (vertical)
- Format: MP4
- 30 fps

---

### 3. Social Media Assets
**Due: Week 4**

- [ ] Profile picture (400×400, circle crop)
- [ ] Cover images (platform-specific sizes)
- [ ] Post template (1080×1080 square)
- [ ] Story template (1080×1920 vertical)

---

## 🎨 OPTIONAL ASSETS (Post-MVP)

### Theme Variants (8 themes)
Can be created post-launch:
- Classic (default)
- Dark Mode
- Pastel Dreams
- Neon Nights
- Ocean Breeze
- Sunset Vibes
- Forest Fresh
- Galaxy (premium)

Each theme = color palette only, no new assets needed!

---

### Achievement Badges (30+ achievements)
Can be simple icon + border:
- Bronze/Silver/Gold/Platinum tiers
- 128×128 pixels
- Reuse existing icons with decorative borders

---

## 💡 ASSET CREATION TIPS

### DIY (Free) Options:
1. **Icons:** Use Heroicons, Feather Icons, or Font Awesome
2. **Buttons:** Create in Figma (free tier)
3. **Sounds:** Use Audacity (free) or online generators
4. **Music:** Epidemic Sound, Artlist, or royalty-free sites

### Budget Options ($100-500):
1. **Fiverr:** Hire designers for $50-100 per asset set
2. **Asset packs:** Buy pre-made mobile game UI kits
3. **Sound libraries:** Purchase SFX packs ($20-50)

### Professional ($500-2000):
1. **Upwork:** Hire experienced mobile game designer
2. **Full asset package:** Custom designed everything
3. **Audio professional:** Original music and SFX

---

## 📋 ASSET ORGANIZATION

Create this folder structure:

```
assets/
├── images/
│   ├── buttons/
│   │   ├── button_red_normal@1x.png
│   │   ├── button_red_normal@2x.png
│   │   ├── button_red_normal@3x.png
│   │   └── ... (all colors and states)
│   ├── icons/
│   │   ├── icon_settings.svg
│   │   └── ... (all UI icons)
│   └── backgrounds/
│       └── ... (optional backgrounds)
├── audio/
│   ├── sfx/
│   │   ├── button_red.ogg
│   │   └── ... (all sounds)
│   └── music/
│       ├── main_menu.ogg
│       └── gameplay.ogg
└── fonts/
    ├── Poppins-Regular.ttf
    ├── Poppins-SemiBold.ttf
    └── Poppins-Bold.ttf
```

---

## ✅ QUALITY CHECKLIST

Before considering assets "done":

**Visual Assets:**
- [ ] Multiple sizes exported (1x, 2x, 3x)
- [ ] Optimized file sizes
- [ ] Consistent style across all assets
- [ ] Transparent backgrounds where needed
- [ ] Named correctly and organized

**Audio Assets:**
- [ ] Correct format (OGG)
- [ ] Normalized volume levels
- [ ] No clipping or distortion
- [ ] Proper loop points (for music)
- [ ] File sizes under target

**Marketing Assets:**
- [ ] All required sizes
- [ ] High quality renders
- [ ] Text is readable
- [ ] Consistent branding
- [ ] Exported in correct formats

---

## 🚀 MVP MINIMUM ASSETS

**Absolute minimum to start development:**

1. ✅ App icon (1 version for testing)
2. ✅ 4 color buttons (red, blue, green, yellow - normal state only)
3. ✅ 4 button sounds
4. ✅ Basic UI icons (settings, close, heart, coin)
5. ✅ Success/error sounds

**Everything else can be added during development!**

Start with placeholders and improve as you go.

---

## 📞 ASSET RESOURCES

### Free Tools:
- **Figma:** UI design (free tier)
- **Audacity:** Audio editing (free)
- **GIMP:** Image editing (free)
- **Inkscape:** Vector graphics (free)
- **Canva:** Quick designs (free tier)

### Asset Libraries:
- **Icons:** icons8.com, flaticon.com, feathericons.com
- **Sounds:** freesound.org, zapsplat.com
- **Music:** incompetech.com, bensound.com
- **Fonts:** Google Fonts

### Where to Hire:
- **Fiverr:** $50-200 per asset set
- **Upwork:** $25-100/hour
- **99designs:** Contest-based ($299-999)
- **Behance:** Find and reach out to designers

---

**Start with MVP assets and iterate! Don't let perfect assets delay your launch.**

---

*Priority: Create app icon and 4 color buttons FIRST*  
*Timeline: Week 1-2 for critical assets*  
*Budget: $0-500 depending on DIY vs. hired*
