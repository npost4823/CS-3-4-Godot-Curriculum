# Godot Resources Curriculum - Teacher Guide

## Project Overview

This is a **Vampire Survivors-style game** designed to teach high school students (Year 2 CS) about **Godot Resources** through a 6-8 week unit. The curriculum uses a tiered approach where students progressively learn to use, create, and write Resources.

---

## Learning Philosophy: Productive Struggle

This curriculum is designed for **self-directed learning** where students:
- Read documentation that is **similar but not identical** to their problems
- Adapt solutions from related contexts (Mario Bros examples → Top-down shooter)
- Struggle productively without copy-paste solutions
- Learn to read API documentation and forums independently

**This takes time**, but builds real problem-solving skills.

---

## Project Structure

```
CS-3-4-Godot-Curriculum/
│
├── lessons/                          # Curriculum documentation
│   ├── tier_1_using_resources.md    # Using existing .tres files
│   ├── tier_2_creating_resource_files.md  # Creating .tres from scripts
│   └── tier_3_writing_resource_scripts.md # Writing .gd and .tres
│
├── scripts/
│   ├── resources/                    # Resource class definitions
│   │   ├── item_resource.gd         # Base class for all items
│   │   ├── material_resource.gd     # Crafting materials
│   │   ├── weapon_resource.gd       # Base weapon class
│   │   ├── projectile_weapon_resource.gd  # Shooting weapons
│   │   ├── enemy_resource.gd        # Enemy stats/behavior
│   │   └── recipe_resource.gd       # Crafting recipes
│   │
│   ├── player.gd                     # Player with stats system
│   ├── projectile.gd                 # Bullet/projectile logic
│   ├── weapon_system.gd              # Auto-attack system
│   ├── enemies/enemy_base.gd        # Enemy AI
│   ├── xp_drop.gd                    # XP pickup
│   ├── wave_spawner.gd               # Wave-based spawning
│   ├── inventory_system.gd           # Inventory management
│   ├── crafting_system.gd            # Recipe crafting
│   └── ui/                           # User interfaces
│       ├── hud.gd                    # Health/XP/stats display
│       └── level_up_ui.gd            # Stat upgrade selection
│
├── resources/                        # Example Resource files
│   ├── weapons/                      # Student examples
│   │   ├── basic_pistol.tres        # Starter weapon
│   │   └── rapid_pistol.tres        # Upgraded weapon
│   ├── materials/                    # Crafting ingredients
│   │   ├── iron_ore.tres
│   │   └── magic_essence.tres
│   ├── recipes/                      # Crafting recipes
│   │   └── craft_rapid_pistol.tres
│   └── enemies/                      # Enemy types
│       └── basic_slime.tres
│
└── scenes/                           # Game scenes
    ├── player.tscn
    ├── projectile.tscn
    ├── weapon_system.tscn
    ├── xp_drop.tscn
    └── ui/
        ├── hud.tscn
        └── level_up_ui.tscn
```

---

## Game Systems Implemented

### ✅ Core Gameplay
- **Player**: Movement, health, XP, leveling system
- **Auto-Attack**: Weapon rotates toward enemies and fires automatically
- **Enemies**: Chase player, deal contact damage, die when health reaches 0
- **Wave Spawning**: Enemies spawn in increasing waves with scaled difficulty
- **XP System**: Enemies drop XP, player levels up, chooses stat upgrades

### ✅ Resource Systems (Teaching Focus)
1. **ItemResource** → Base class for all items
2. **WeaponResource** → Extends ItemResource
3. **ProjectileWeaponResource** → Extends WeaponResource (full example)
4. **MaterialResource** → Crafting ingredients
5. **RecipeResource** → Defines crafting recipes
6. **EnemyResource** → Enemy stats and behavior

### ✅ Progression Systems
- **Leveling**: XP requirements increase, player gets stronger
- **Stat Upgrades**: Speed, Health, Carry Capacity, Crafting Efficiency, Accuracy
- **Crafting**: Combine materials to create upgraded weapons
- **Inventory**: Track materials and weapons

### ✅ UI Systems
- **HUD**: Health bar, XP bar, level display, current stats
- **Level Up UI**: Pause game, choose 1 of 3 random stat upgrades
- **Inventory System**: Backend for tracking items (UI to be built by students)
- **Crafting System**: Backend for recipes (UI to be built by students)

---

## Three-Tier Curriculum

### **Tier 1: Using Resources** (2-3 periods)
**Goal**: Students use existing .tres files

**Activities**:
- Examine `basic_pistol.tres`
- Duplicate and modify to create variations (sniper, shotgun, etc.)
- Test different stat combinations
- Create enemy variants

**Skills Learned**:
- What Resources are and why they're useful
- How to modify .tres files in the Inspector
- The relationship between .gd scripts and .tres files

**Mario Bros Analogy**: Students see how Goomba/Koopa use the same `EnemyStats` script with different .tres files

---

### **Tier 2: Creating Resource Files** (2-3 periods)
**Goal**: Students create new .tres files from existing scripts

**Activities**:
- Create recipes for weapon upgrades
- Create new boss enemies from `EnemyResource`
- Create new materials from `MaterialResource`
- Work with Dictionaries and Arrays in the Inspector

**Skills Learned**:
- Creating Resources in Godot
- Understanding script-defined properties
- Working with complex data types
- Linking related Resources (recipe → weapon)

**Mario Bros Analogy**: Students create Fire Flower, Star power-ups from a `PowerUpResource` script

---

### **Tier 3: Writing Resource Scripts** (3-4 periods)
**Goal**: Students write both .gd scripts and .tres files

**Activities**:
- Create `StatusEffectResource` from scratch
- Create `WeaponUpgradeResource`
- Create `AchievementResource`
- Design and implement a loot drop system
- Advanced: Create `MeleeWeaponResource` (inheritance)

**Skills Learned**:
- Writing Resource classes
- Proper use of @export
- Documentation with ##comments
- Resource inheritance patterns
- Data architecture design

**Mario Bros Analogy**: Students design pipe warp system with `PipeResource`

---

## What's NOT Fully Implemented (Student Tasks)

These are intentionally incomplete for students to build:

### **Student Assignments**:
1. **Material Drop Visuals**: XP drops work, but material pickups need scenes
2. **Inventory UI**: Backend exists, but visual grid UI needs building
3. **Crafting UI**: Backend exists, but recipe selection UI needs building
4. **Weapon Switching**: Mechanics exist, UI for switching doesn't
5. **Status Effects**: Resource type will be created by students
6. **Achievements**: Full system created by students
7. **Boss Mechanics**: Advanced enemy behaviors

---

## How to Use This Curriculum

### Week 1-2: Tier 1
- Day 1: Introduce Resources concept, show existing system
- Day 2-3: Students create weapon variants
- Day 4-5: Students create enemy variants, test balance

### Week 3-4: Tier 2
- Day 1: Demonstrate creating .tres from scripts
- Day 2-3: Students create recipes and materials
- Day 4-5: Students create boss enemies, test progression

### Week 5-6: Tier 3
- Day 1-2: Teach Resource script writing
- Day 3-4: Students create StatusEffectResource
- Day 5: Students create UpgradeResource or AchievementResource

### Week 7-8: Final Project
- Students design and implement their own Resource system
- Examples: Loot tables, Quests, Abilities, Perks
- OR: Begin card game project using Resource knowledge

---

## Testing the Game

### Current Setup Needed:
1. Open `scenes/main.tscn`
2. Add these as children:
   - `player.tscn` - Player character
   - `weapon_system.tscn` (child of player) - Auto-attack
   - `ui/hud.tscn` - Health/XP display
   - `ui/level_up_ui.tscn` - Level up screen
   - `wave_spawner.tscn` - Enemy spawning (needs creation)

3. In `Global.gd` (autoload), set reference to game_world

### Manual Testing Checklist:
- ✅ Player moves with WASD/arrows
- ✅ Weapon rotates toward enemies
- ✅ Weapon fires automatically
- ✅ Projectiles damage enemies
- ✅ Enemies chase and damage player
- ✅ Enemies drop XP on death
- ✅ XP fills bar and triggers level up
- ✅ Level up screen shows 3 random upgrades
- ✅ Selecting upgrade applies stat bonus

---

## Common Student Questions (FAQ)

### "Why do we use Resources instead of just variables?"
**Answer**: Resources are **data files** that can be created without coding. Imagine if every weapon required editing code - game designers couldn't work! Resources separate data from logic.

### "When should I use a Resource vs a regular class?"
**Answer**: Use Resources for **data that defines "things"** (weapons, enemies, items). Use classes for **behavior and logic** (how enemies move, how combat works).

### "My .tres file doesn't show up in the dropdown!"
**Answer**: Check:
1. Did you save the .gd script?
2. Does the script have `class_name`?
3. Does it `extend Resource`?
4. Did you restart Godot? (Sometimes needed)

### "How do I know what properties to add?"
**Answer**: Think about what **varies** between instances. All weapons deal damage (property!), but each has different amounts (values!).

---

## Extension Ideas

### For Advanced Students:
1. **Networked Multiplayer**: Resources make this easier (sync resource IDs)
2. **Mod Support**: Players can add custom .tres files
3. **Save/Load System**: Serialize Resource properties
4. **Procedural Generation**: Randomize Resource properties
5. **Resource Database**: JSON/CSV → Auto-generate .tres files

### Card Game Transition:
After this unit, students create a card game:
- `CardResource` (Tier 1: Use example cards)
- `DeckResource` (Tier 2: Create custom decks)
- `CardEffectResource` (Tier 3: Design new effects)

---

## Troubleshooting

### "Game crashes on start"
- Check that Global autoload is configured
- Verify player scene exists in main scene
- Check for circular Resource dependencies

### "Enemies don't spawn"
- Verify WaveSpawner has enemy_scene assigned
- Check enemy has collision layers set correctly
- Ensure player reference is valid

### "Weapons don't fire"
- Check weapon_system has projectile_scene assigned
- Verify equipped_weapon Resource is set
- Ensure enemies group exists

### "Level up UI doesn't appear"
- Check that level_up signal is connected
- Verify player has leveling system initialized
- Ensure CanvasLayer process_mode is set to "Always"

---

## Assessment Rubric

### Tier 1 Mastery:
- [ ] Can identify Resource files (.tres) vs scripts (.gd)
- [ ] Successfully modifies .tres properties
- [ ] Tests changes in game
- [ ] Explains purpose of Resources

### Tier 2 Mastery:
- [ ] Creates new .tres from existing scripts
- [ ] Understands all @export property types
- [ ] Works with complex types (Dictionary, Array)
- [ ] Makes connections between related Resources

### Tier 3 Mastery:
- [ ] Writes complete Resource scripts
- [ ] Uses proper inheritance
- [ ] Adds meaningful methods
- [ ] Documents code effectively
- [ ] Designs data architecture

---

## Additional Resources

### Godot Documentation:
- [Resources (Official Docs)](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html)
- [Exporting Properties](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html)

### Similar Projects:
- Vampire Survivors (inspiration)
- Brotato (similar top-down survivor)
- Slay the Spire (card game using Resources pattern)

---

## Contact & Contributions

Students who complete Tier 3 can contribute to the project:
- Create new example Resources
- Write tutorials for classmates
- Design balanced weapons/enemies
- Build missing UI components

**This is a living curriculum** - improve it as you teach it!
