# Lesson: Creating Your Own Stat Upgrade

## Objective
By the end of this lesson, you will:
- Understand what Godot Resources are and why they're useful
- Create your own custom stat upgrade
- Add your upgrade to the level-up system
- Test your upgrade in the game

## Estimated Time: 30-45 minutes

---

## Part 1: Understanding Resources (10 minutes)

### What is a Resource?

In Godot, a **Resource** is a special type of object that stores data. Think of it like a template or blueprint that you can:
- Save as a file (`.tres` or `.res`)
- Edit in the Inspector
- Reuse across your project
- Load dynamically during gameplay

### Why Use Resources?

**Without Resources (Dictionary/Array approach):**
```gdscript
var upgrades = [
    {"name": "Health +20", "stat": "health", "amount": 20.0},
    {"name": "Speed +30", "stat": "speed", "amount": 30.0}
]
```
❌ Hard to edit - must change code
❌ Error-prone - typos in dictionary keys
❌ No validation - can put wrong data types

**With Resources:**
```gdscript
@export var upgrades: Array = []  # Drag .tres files here!
```
✅ Edit in Inspector - no code changes needed
✅ Type-safe - Godot validates your data
✅ Reusable - same resource in multiple places
✅ Visual - see all properties at a glance

### Example: Our StatUpgradeResource

Open `scripts/resources/stat_upgrade_resource.gd` and let's examine it:

```gdscript
extends Resource
class_name StatUpgradeResource

@export var upgrade_name: String = "Unknown Upgrade"
@export var description: String = ""
@export_enum("health", "speed", "accuracy", "carry") var stat_type: String = "health"
@export var amount: float = 0.0

func apply_to_player(player: Player) -> bool:
    match stat_type:
        "health":
            player.upgrade_health(amount)
        "speed":
            player.upgrade_speed(amount)
        # ... etc
```

**Key Points:**
- `extends Resource` - This is a Resource class
- `class_name StatUpgradeResource` - Gives it a name we can reference
- `@export` - Makes properties visible in the Inspector
- `@export_enum` - Creates a dropdown with specific choices
- `apply_to_player()` - Method that applies the upgrade effect

---

## Part 2: Examining Existing Upgrades (5 minutes)

### Step 1: Open an Existing Upgrade

1. In the **FileSystem** panel, navigate to `resources/upgrades/`
2. Double-click on `health_upgrade.tres`

You should see these properties in the Inspector:
- **upgrade_id**: "health_boost"
- **upgrade_name**: "Max Health +20"
- **description**: "Increases your maximum health"
- **icon**: (empty)
- **stat_type**: "health"
- **amount**: 20.0

### Step 2: Understand Each Property

| Property | Purpose | Example |
|----------|---------|---------|
| `upgrade_id` | Unique identifier (for future features) | "health_boost" |
| `upgrade_name` | Shown to player in level-up menu | "Max Health +20" |
| `description` | Explains what the upgrade does | "Increases your maximum health" |
| `icon` | Optional image (we'll skip for now) | null |
| `stat_type` | Which stat to upgrade | "health", "speed", "accuracy", or "carry" |
| `amount` | How much to increase | 20.0 for health, 30.0 for speed, etc. |

### Step 3: Check the Other Upgrade

Now open `speed_upgrade.tres` and compare:
- Notice how `stat_type` is set to "speed"
- The `amount` is 30.0 (movement speed increase)
- The name and description are different

---

## Part 3: Creating Your Own Upgrade (15 minutes)

Now let's create an **Accuracy Upgrade** that reduces weapon spread!

### Step 1: Duplicate an Existing Upgrade

1. In the FileSystem panel, navigate to `resources/upgrades/`
2. **Right-click** on `health_upgrade.tres`
3. Select **Duplicate...**
4. Name it `accuracy_upgrade.tres`
5. Press Enter

### Step 2: Configure Your New Upgrade

1. **Double-click** on `accuracy_upgrade.tres` to open it
2. In the **Inspector**, modify these properties:

| Property | Change To | Why |
|----------|-----------|-----|
| `upgrade_id` | "accuracy_boost" | Unique identifier |
| `upgrade_name` | "Accuracy +0.2x" | What player sees |
| `description` | "Reduces weapon spread" | Explains the effect |
| `stat_type` | "accuracy" | Which stat to modify |
| `amount` | 0.2 | Accuracy is a multiplier |

3. **Save** your changes (Ctrl+S or Cmd+S)

### Step 3: Verify Your Resource

Your `accuracy_upgrade.tres` file should now look like this:

```
[resource]
script = ExtResource("1_...")
upgrade_id = "accuracy_boost"
upgrade_name = "Accuracy +0.2x"
description = "Reduces weapon spread"
icon = null
stat_type = "accuracy"
amount = 0.2
```

---

## Part 4: Adding Your Upgrade to the Game (10 minutes)

### Step 1: Open the Arena Scene

1. In the FileSystem, navigate to `scenes/`
2. Double-click `arena.tscn` to open it

### Step 2: Find the LevelUpUI Node

1. In the **Scene** panel (usually top-left), look for the node hierarchy
2. Find the `LevelUpUI` node (it might be under `CanvasLayer` or at the root)
3. **Click** on `LevelUpUI` to select it

### Step 3: Add Your Upgrade to the Array

1. In the **Inspector** (usually right side), scroll down to find **Available Upgrades**
2. Click the **dropdown arrow** to expand it
3. You should see:
   ```
   Available Upgrades: Array[StatUpgradeResource] (size 2)
   ```
   Or it might just show `Array (size 0)` - that's okay!

4. **Change the size**:
   - If size is 0: Set to **3**
   - If size is 2: Change to **3** (add one more)

5. **Drag your upgrade**:
   - Find `resources/upgrades/accuracy_upgrade.tres` in the FileSystem
   - **Drag and drop** it into one of the empty slots in the Available Upgrades array
   - You should see: `[0]: accuracy_upgrade.tres` (or similar)

6. If the other slots are empty, add the other upgrades:
   - Drag `health_upgrade.tres` to another slot
   - Drag `speed_upgrade.tres` to the last slot

### Step 4: Verify the Array

Your Available Upgrades array should now look like:
```
Available Upgrades: Array (size 3)
[0]: health_upgrade.tres
[1]: speed_upgrade.tres
[2]: accuracy_upgrade.tres
```

The order doesn't matter - the system shuffles them randomly!

### Step 5: Save the Scene

1. Press **Ctrl+S** (or **Cmd+S** on Mac)
2. Or go to **Scene → Save Scene**

---

## Part 5: Testing Your Upgrade (5 minutes)

### Step 1: Run the Game

1. Press **F5** (or click the **Play** button at the top-right)
2. The game should start

### Step 2: Level Up

You need to gain XP to level up. There are two ways:

**Method 1: Kill Enemies**
- Move around with arrow keys
- Collect XP orbs that enemies drop
- Wait until you level up (need 100 XP)

**Method 2: Debug Command (Faster!)**
- Press **Enter** key
- This gives you 50 XP instantly (debug feature)
- Press Enter twice to level up

### Step 3: Check Your Upgrade

When you level up:
1. The game should **pause**
2. A menu should appear with upgrade choices
3. **Look for your accuracy upgrade!**
   - You should see: "Accuracy +0.2x"
   - With the description: "Reduces weapon spread"

4. **Click your upgrade** to select it
5. The menu closes and game resumes

### Step 4: Verify It Works

1. Open the **HUD** (top-left of screen)
2. Look at the stats display
3. You should see: `Accuracy: 1.2x` (started at 1.0x, gained 0.2x)

### Step 5: Level Up Again

1. Press **Enter** twice more to level up again
2. Select the accuracy upgrade again (if it appears)
3. Check the HUD: `Accuracy: 1.4x` (1.0 + 0.2 + 0.2)

**Success!** Your upgrade is working! 🎉

---

## Part 6: Challenge Exercises

Now that you understand the system, try these challenges:

### Challenge 1: Create a Different Health Upgrade
- Create `big_health_upgrade.tres`
- Set amount to **50.0** instead of 20
- Name it "Max Health +50"
- Test it in the game

### Challenge 2: Create a Carry Capacity Upgrade
- Create `carry_upgrade.tres`
- Set stat_type to "carry"
- Set amount to **1** (carry is an integer)
- Name it "Carry Capacity +1"
- Description: "Equip heavier weapons or dual wield"
- Test it in the game
- Check the HUD to see: `Carry: 2` (started at 1)

### Challenge 3: Create a "Super Speed" Upgrade
- Create `super_speed_upgrade.tres`
- Set stat_type to "speed"
- Set amount to **50.0**
- Name it "Movement Speed +50"
- Test and compare to the regular speed upgrade (+30)

### Challenge 4: Balance Your Upgrades
Think about game balance:
- Should health increase by 20 or 30?
- Should speed increase by 20 or 50?
- Is 0.2 accuracy too much or too little?
- Experiment with different values!

---

## Part 7: Understanding the Code (Optional - Advanced)

### How Does It All Connect?

1. **Player.gd** - Has upgrade methods:
   ```gdscript
   func upgrade_health(amount: float):
       max_health += amount
       current_health += amount  # Also heals!
   ```

2. **StatUpgradeResource.gd** - Calls player methods:
   ```gdscript
   func apply_to_player(player: Player) -> bool:
       match stat_type:
           "health":
               player.upgrade_health(amount)
   ```

3. **LevelUpUI.gd** - Shows upgrades and applies them:
   ```gdscript
   @export var available_upgrades: Array = []  # You fill this!

   func show_upgrade_options(level: int):
       # Shuffles and shows 3 random upgrades

   func _on_upgrade_selected(upgrade):
       upgrade.apply_to_player(player)  # Applies it!
   ```

### Data Flow:
```
1. Player levels up
   ↓
2. LevelUpUI.show_upgrade_options() is called
   ↓
3. Picks 3 random upgrades from available_upgrades array
   ↓
4. Creates buttons showing upgrade.get_display_text()
   ↓
5. Player clicks a button
   ↓
6. _on_upgrade_selected(upgrade) is called
   ↓
7. upgrade.apply_to_player(player) modifies player stats
   ↓
8. Game unpauses and continues
```

---

## Part 8: Troubleshooting

### Problem: My upgrade doesn't appear in the level-up menu

**Check:**
- ✅ Did you add your .tres file to the `Available Upgrades` array?
- ✅ Did you save the arena.tscn scene?
- ✅ Is the array size at least 1?

### Problem: Error: "Could not find type StatUpgradeResource"

**Solution:**
- Close and reopen the Godot project
- Godot needs to rescan the project to recognize new classes

### Problem: My upgrade appears but does nothing

**Check:**
- ✅ Is the `stat_type` spelled correctly? ("health", "speed", "accuracy", "carry")
- ✅ Is the `amount` greater than 0?
- ✅ Did you save the .tres file after editing?

### Problem: The level-up menu never appears

**Check:**
- ✅ Did you gain enough XP? (Need 100 XP for level 2)
- ✅ Is the LevelUpUI node in the arena scene?
- ✅ Try pressing Enter to give yourself XP

---

## Reflection Questions

After completing this lesson, answer these questions:

1. **What is a Resource in Godot?**
   - A: A data container that can be saved as a file and edited in the Inspector

2. **Why are Resources better than dictionaries for game data?**
   - A: Type-safe, visual editing, no typos, reusable, no code changes needed

3. **What does the `@export` keyword do?**
   - A: Makes a variable visible and editable in the Inspector

4. **What are the four stat types you can upgrade?**
   - A: health, speed, accuracy, carry

5. **How would you create an upgrade that gives +100 health instead of +20?**
   - A: Duplicate an upgrade, change the amount to 100.0, keep stat_type as "health"

---

## Extension Activities

### For Advanced Students:

1. **Add Icons to Upgrades**
   - Find or create small 32x32 pixel images
   - Import them into the project
   - Assign them to the `icon` property
   - Modify LevelUpUI.gd to display icons

2. **Create a "Rare" Upgrade System**
   - Add a `rarity` property to StatUpgradeResource
   - Make some upgrades more powerful but rare
   - Modify the selection code to weight rare upgrades

3. **Add Sound Effects**
   - Add an `upgrade_sound` property
   - Play a sound when upgrade is selected
   - Different sounds for different upgrade types

4. **Create Compound Upgrades**
   - Design an upgrade that affects multiple stats
   - Example: "Warrior's Strength" - +10 health AND +10 speed
   - Hint: You'll need to modify StatUpgradeResource.gd

---

## Congratulations!

You've learned:
- ✅ What Resources are and why they're useful
- ✅ How to create and configure Resource files
- ✅ How to add Resources to exported arrays
- ✅ How the stat upgrade system works
- ✅ How to test and debug your upgrades

**Next Steps:**
- Create 3-5 unique upgrades
- Experiment with different values
- Think about game balance
- Share your upgrades with classmates!

---

## Teacher Notes

### Learning Objectives:
- Understand Resource-oriented design patterns
- Practice using Godot's Inspector interface
- Learn to modify exported properties
- Understand how scripts and resources interact

### Common Student Mistakes:
1. Forgetting to save the .tres file after editing
2. Not adding the upgrade to the Available Upgrades array
3. Using the wrong stat_type name (typo)
4. Setting amount to 0 or negative values

### Assessment Ideas:
- Have students create 3 balanced upgrades
- Ask students to explain Resources vs dictionaries
- Challenge: Create an upgrade system for enemies
- Group activity: Design upgrade progression for 10 levels

### Differentiation:
- **Struggling students**: Provide pre-filled templates, focus on just changing numbers
- **Advanced students**: Challenge exercises, add new stat types, modify the system
- **Visual learners**: Draw diagrams of data flow
- **Kinesthetic learners**: Physical cards representing upgrades, arrange by power level
