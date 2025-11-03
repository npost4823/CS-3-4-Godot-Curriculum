# Quick Reference: Creating Stat Upgrades

## The 5-Minute Guide

### Step 1: Duplicate an Upgrade (30 seconds)
```
1. Go to resources/upgrades/
2. Right-click health_upgrade.tres
3. Select "Duplicate"
4. Name it (e.g., my_upgrade.tres)
```

### Step 2: Edit Properties (1 minute)
```
1. Double-click your new .tres file
2. In Inspector, change:
   - upgrade_id: "my_unique_id"
   - upgrade_name: "What Player Sees"
   - description: "What it does"
   - stat_type: Choose from dropdown
   - amount: How much to increase
3. Save (Ctrl+S)
```

### Step 3: Add to Game (2 minutes)
```
1. Open scenes/arena.tscn
2. Select LevelUpUI node
3. In Inspector, find "Available Upgrades"
4. Increase array size by 1
5. Drag your .tres file into the new slot
6. Save scene (Ctrl+S)
```

### Step 4: Test (1 minute)
```
1. Press F5 to run game
2. Press Enter twice to level up (debug command)
3. Look for your upgrade in the menu
4. Click it and check the HUD stats
```

---

## Stat Types Reference

| Stat Type | What It Does | Suggested Amounts | Example Name |
|-----------|--------------|-------------------|--------------|
| `health` | Increases max HP | 10-50 | "Max Health +20" |
| `speed` | Increases movement speed | 20-50 | "Movement Speed +30" |
| `accuracy` | Reduces weapon spread | 0.1-0.3 | "Accuracy +0.2x" |
| `carry` | Carry heavier weapons | 1 | "Carry Capacity +1" |

---

## Common Values

### Health Upgrades
- Small: 10-20
- Medium: 30-40
- Large: 50+

### Speed Upgrades
- Small: 20-30
- Medium: 40-50
- Large: 60+

### Accuracy Upgrades
- Small: 0.1
- Medium: 0.2
- Large: 0.3+

### Carry Upgrades
- Always: 1 (it's a counter, not a multiplier)

---

## Example Upgrades

### Health Boost
```
upgrade_id: "health_boost"
upgrade_name: "Max Health +20"
description: "Increases your maximum health"
stat_type: "health"
amount: 20.0
```

### Speed Demon
```
upgrade_id: "speed_demon"
upgrade_name: "Movement Speed +40"
description: "Move much faster to dodge enemies"
stat_type: "speed"
amount: 40.0
```

### Sharpshooter
```
upgrade_id: "sharpshooter"
upgrade_name: "Accuracy +0.3x"
description: "Greatly reduces weapon spread"
stat_type: "accuracy"
amount: 0.3
```

### Heavy Weapons Training
```
upgrade_id: "heavy_weapons"
upgrade_name: "Carry Capacity +1"
description: "Equip heavier weapons or dual wield"
stat_type: "carry"
amount: 1.0
```

---

## Troubleshooting Checklist

### Upgrade doesn't appear:
- [ ] Added to Available Upgrades array?
- [ ] Saved arena.tscn?
- [ ] Array size increased?

### Upgrade does nothing:
- [ ] stat_type spelled correctly?
- [ ] amount > 0?
- [ ] Saved the .tres file?

### Error messages:
- [ ] Close and reopen Godot project
- [ ] Check spelling in stat_type
- [ ] Make sure script path is correct

---

## Quick Commands

- **Run Game**: F5
- **Stop Game**: F8
- **Save Scene**: Ctrl+S (Cmd+S on Mac)
- **Debug XP**: Press Enter in game (gives 50 XP)
- **Level Up**: Need 100 XP (press Enter twice)

---

## File Locations

- **Upgrade Script**: `scripts/resources/stat_upgrade_resource.gd`
- **Upgrade Resources**: `resources/upgrades/*.tres`
- **Level Up UI**: `scripts/ui/level_up_ui.gd`
- **Arena Scene**: `scenes/arena.tscn`

---

## Pro Tips

1. **Name Clearly**: Use descriptive names so you remember what each upgrade does
2. **Test Often**: Run the game after every upgrade you create
3. **Start Small**: Begin with small numbers and increase if too weak
4. **Keep Notes**: Write down which values feel balanced
5. **Duplicate, Don't Create**: Always duplicate an existing upgrade - it's faster!

---

## Challenge Ideas

- [ ] Create 5 different upgrades
- [ ] Create a "legendary" upgrade with huge stats
- [ ] Create 3 variants of health upgrades (small, medium, large)
- [ ] Balance upgrades so all are equally useful
- [ ] Create an upgrade for each stat type

---

## Remember

**Resources = Reusable Data Containers**

They make it easy to:
- Create game content without coding
- Edit properties visually
- Test different values quickly
- Share data across your game

Happy upgrading! 🚀
