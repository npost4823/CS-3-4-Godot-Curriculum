# Setup Guide - Getting the Project Running

## What's Been Created

This project now has a complete **Vampire Survivors-style game foundation** with a **three-tier Resources curriculum**. Here's what exists:

---

## ✅ Fully Implemented Systems

### Resource Architecture
- `ItemResource` - Base class for all items
- `MaterialResource` - Crafting materials
- `WeaponResource` - Base weapon class
- `ProjectileWeaponResource` - Projectile weapons (fully functional)
- `EnemyResource` - Enemy configuration
- `RecipeResource` - Crafting recipes

### Game Systems
- **Player**: Movement, health, XP, leveling, stat upgrades
- **Weapon System**: Auto-attacking, rotating gun node
- **Projectile System**: Bullets that damage enemies
- **Enemy AI**: Chase player, deal contact damage, separation
- **Wave Spawning**: Continuous enemy spawns with difficulty scaling
- **XP Drops**: Magnetic pickup that grants experience
- **Leveling**: XP requirements, level-up with stat choice
- **Inventory System**: Backend for materials and weapons
- **Crafting System**: Backend for recipes

### UI Systems
- **HUD**: Health bar, XP bar, level display, stats
- **Level Up UI**: Pause on level up, choose stat upgrade (3 random options)

### Example Resources
- `basic_pistol.tres` - Starter weapon
- `rapid_pistol.tres` - Upgraded weapon example
- `iron_ore.tres` - Common material
- `magic_essence.tres` - Rare material
- `craft_rapid_pistol.tres` - Recipe example
- `basic_slime.tres` - Enemy example

### Documentation
- **Tier 1 Lesson**: Using existing Resources
- **Tier 2 Lesson**: Creating Resource files
- **Tier 3 Lesson**: Writing Resource scripts
- **Teacher README**: Full curriculum guide
- **Student README**: Project introduction

---

## ⚠️ What Needs Setup

To make this playable, you need to:

### 1. Update the Main Scene

Open `scenes/main.tscn` and restructure it:

```
Main (Node2D)
├── TileMap (use existing dungeon tileset)
├── Player (instance of player.tscn)
│   └── WeaponSystem (instance of weapon_system.tscn) - CHILD OF PLAYER
├── WaveSpawner (Node2D)
├── HUD (instance of ui/hud.tscn)
└── LevelUpUI (instance of ui/level_up_ui.tscn)
```

### 2. Create Arena Level

The current dungeon level is small and maze-like. You need an **open arena**:

**Option A - Quick**:
- Open `scenes/main.tscn`
- Clear the existing maze tiles
- Paint a large open area (at least 1500x1500 pixels)
- Add some walls around the perimeter
- Keep the dungeon aesthetic (existing tileset)

**Option B - New Scene**:
- Create `scenes/arena.tscn`
- Use the existing `tilesets/dungeon.tres`
- Paint a large circular or square arena
- Add atmospheric elements (torches, pillars)

### 3. Setup Wave Spawner

Create the wave spawner node setup:

**Create** `scenes/wave_spawner.tscn`:
```
WaveSpawner (Node2D)
└── [script: wave_spawner.gd]
```

**In Inspector, set**:
- `enemy_scene`: Link to `scenes/enemies/slime.tscn`
- `spawn_radius_min`: 400
- `spawn_radius_max`: 600
- `spawn_interval`: 2.0

### 4. Update Enemy Scenes

The enemy scenes need to be updated from `StaticBody2D` to `CharacterBody2D`:

Open `scenes/enemies/slime.tscn`:
1. Change root node from `StaticBody2D` to `CharacterBody2D`
2. Ensure script is `enemy_base.gd`
3. In Inspector, link `enemy_data` to `resources/enemies/basic_slime.tres`
4. Link `xp_drop_scene` to `scenes/xp_drop.tscn`
5. Add signal connection: `body_entered` → `_on_body_entered`

Repeat for `skeleton.tscn` and `mage.tscn`.

### 5. Update Global Autoload

Open `scripts/global.gd` and ensure:

```gdscript
extends Node

var game_world = null
```

Then in `game_world.gd`, add at the top:

```gdscript
func _ready():
    Global.game_world = self
```

---

## 🎮 Testing Checklist

Once setup is complete, test these features:

### Basic Movement
- [ ] Player moves with WASD/arrows
- [ ] Camera follows player
- [ ] Player has animations (idle/walk)

### Combat
- [ ] Weapon rotates toward enemies
- [ ] Weapon fires automatically when enemies are near
- [ ] Projectiles spawn and travel
- [ ] Projectiles damage enemies
- [ ] Enemies flash red when hit

### Enemy AI
- [ ] Enemies spawn around player
- [ ] Enemies chase player
- [ ] Enemies damage player on contact
- [ ] Enemies die when health reaches 0
- [ ] XP drops spawn on enemy death

### Progression
- [ ] XP bar fills when collecting XP
- [ ] Player levels up at XP threshold
- [ ] Level up UI appears and pauses game
- [ ] Selecting upgrade applies stat bonus
- [ ] Game unpauses after selection

### UI
- [ ] Health bar displays correctly
- [ ] XP bar displays correctly
- [ ] Level number updates
- [ ] Stats display shows current values

---

## 🔧 Quick Start Commands

### If starting from scratch:

1. **Clone/Open project in Godot 4.5+**

2. **Verify autoload is set**:
   - Project → Project Settings → Autoload
   - Ensure `Global` points to `scripts/global.gd`

3. **Create main scene structure** (see section 1 above)

4. **Run project** and test

---

## 🐛 Common Issues

### "Cannot find player reference"
**Fix**: Ensure `Global.game_world.player` is set in `game_world.gd`

### "Enemies don't spawn"
**Fix**:
- Check WaveSpawner has enemy_scene assigned
- Verify enemy_scene path is correct
- Check console for errors

### "Projectiles don't damage enemies"
**Fix**:
- Verify projectile collision layer = 4
- Verify enemy collision layer = 2
- Check enemy has `take_damage()` method

### "Level up UI doesn't show"
**Fix**:
- Ensure LevelUpUI has process_mode = "Always"
- Check player.level_up signal is emitted
- Verify UI is connected to player

### "Weapon doesn't fire"
**Fix**:
- Check weapon_system has projectile_scene assigned
- Check equipped_weapon Resource is set
- Verify enemies are in "enemies" group

---

## 📚 Next Steps for Students

Once the game is running:

1. **Week 1-2**: Students complete Tier 1 assignments
   - Modify existing weapons
   - Create enemy variants
   - Test balance

2. **Week 3-4**: Students complete Tier 2 assignments
   - Create recipes
   - Create boss enemies
   - Create new materials

3. **Week 5-6**: Students complete Tier 3 assignments
   - Write StatusEffectResource
   - Write UpgradeResource
   - Build loot system

4. **Week 7-8**: Final projects
   - Student-designed systems
   - OR begin card game project

---

## 🎯 Student Learning Outcomes

By the end of this unit, students will:

✅ Understand what Resources are and why they're useful
✅ Read and modify existing Resource files (.tres)
✅ Create new Resource files from existing scripts
✅ Write complete Resource scripts (.gd)
✅ Use Resource inheritance effectively
✅ Design data-driven game systems
✅ Work with complex data types (Dictionary, Array)
✅ Think architecturally about data vs logic separation

---

## 🚀 Extensions & Improvements

### For You (Teacher):
- Add more weapon examples (melee, explosives)
- Create more enemy variants
- Build inventory UI (currently backend only)
- Build crafting UI (currently backend only)
- Add boss fights with unique mechanics

### For Advanced Students:
- Implement status effects system
- Create achievement system
- Build loot table system
- Add weapon mod/attachment system
- Create procedural weapon generation

---

## 📞 Getting Help

If you encounter issues:

1. Check console for error messages
2. Verify all file paths are correct
3. Ensure Godot version is 4.5+
4. Check that autoload (Global) is configured
5. Refer to `TEACHER_README.md` for detailed explanations

---

## Summary

**What works**: All core systems, documentation, examples
**What needs setup**: Scene hierarchy, enemy scene updates, wave spawner instance
**Time to setup**: ~30-60 minutes
**Time to test**: ~15 minutes

Once setup is complete, you have a fully functional teaching project for 6-8 weeks of curriculum!
