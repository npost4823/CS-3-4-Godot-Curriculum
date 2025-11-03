# Teacher Guide: Stat Upgrade Lesson

## Overview

This lesson teaches students how to create game content using Godot's Resource system. Students will create custom stat upgrades for the level-up system, learning data-driven design principles without writing code.

**Estimated Duration:** 45 minutes (can be extended to 60-90 for challenges)

---

## Learning Objectives

By the end of this lesson, students will be able to:

1. **Define** what a Resource is in Godot and explain its benefits
2. **Create** new Resource files by duplicating and modifying existing ones
3. **Configure** Resource properties using the Inspector interface
4. **Integrate** Resources into the game by populating exported arrays
5. **Test** their changes and debug common issues
6. **Evaluate** game balance through playtesting

---

## Standards Alignment

### Computer Science Standards
- **Variables and Data Types**: Understanding properties and data structures
- **Object-Oriented Programming**: Working with class instances (Resources)
- **Data-Driven Design**: Separating data from code logic
- **Testing and Debugging**: Iterative testing and problem-solving

### Math Standards
- **Numbers and Operations**: Understanding multipliers (accuracy bonus)
- **Variables**: Assigning and modifying values
- **Problem Solving**: Balancing gameplay values

---

## Prerequisites

Students should:
- Have basic Godot interface familiarity
- Understand file system navigation
- Know how to run/stop the game (F5/F8)
- Have completed basic GDScript introduction (helpful but not required)

---

## Materials Needed

### For Each Student:
- Computer with Godot 4.x installed
- This project opened in Godot
- Printed worksheet (optional but recommended)
- Notebook for notes

### For Teacher:
- Projector/screen for demonstrations
- Teacher guide (this document)
- Example solutions prepared
- Assessment rubric

---

## Lesson Structure

### 1. Introduction (5 minutes)

**Hook Question:**
> "What if we could add new powers to our game without writing any code at all?"

**Discussion Prompts:**
- What kinds of upgrades do you see in games you play?
- How do game designers balance different upgrades?
- Why might designers want to change game data without editing code?

**Key Concept Introduction:**
Introduce **Resources** as "data containers" or "blueprints" that store information separately from code.

**Analogy:**
> "Think of Resources like recipe cards. The recipe card (Resource) contains ingredients and amounts (properties), but the actual cooking (code) stays the same. You can create new recipes without changing how the kitchen works!"

---

### 2. Demonstration (10 minutes)

**Live Demonstration Steps:**

1. **Show Existing Upgrades** (2 min)
   - Navigate to `resources/upgrades/`
   - Open `health_upgrade.tres`
   - Point out each property in Inspector
   - Show how it looks in code (`stat_upgrade_resource.gd`) but emphasize they won't edit code

2. **Explain the Flow** (3 min)
   - Draw on board:
     ```
     Resource (.tres file)
         ↓
     Inspector (edit properties)
         ↓
     Export Array (add to game)
         ↓
     Game (player sees it)
     ```

3. **Create an Example Upgrade** (5 min)
   - Duplicate `health_upgrade.tres` → `demo_upgrade.tres`
   - Change properties together as a class
   - Add to arena.tscn's Available Upgrades array
   - Run game and show it working
   - **Important**: Show the debug command (Enter key) to level up quickly

**Common Student Questions:**
- Q: "Do we need to write code?"
  - A: "No! That's the power of Resources - all data, no code!"
- Q: "What if I break something?"
  - A: "You can always delete the .tres file and start over, or use Git to revert!"
- Q: "Why use Resources instead of code?"
  - A: "Easier to edit, visual, no syntax errors, can be edited by designers who don't code!"

---

### 3. Guided Practice (15 minutes)

**Activity:** Create an Accuracy Upgrade

**Step-by-Step Guide Students Through:**

1. **Duplicate** (2 min)
   - Right-click `health_upgrade.tres`
   - Select Duplicate
   - Name it `accuracy_upgrade.tres`

2. **Configure** (5 min)
   - Walk through each property:
     - `upgrade_id`: "accuracy_boost"
     - `upgrade_name`: "Accuracy +0.2x"
     - `description`: "Reduces weapon spread"
     - `stat_type`: "accuracy"
     - `amount`: 0.2
   - Emphasize saving (Ctrl+S)

3. **Add to Game** (5 min)
   - Open `arena.tscn`
   - Find LevelUpUI node
   - Locate Available Upgrades in Inspector
   - Increase array size
   - Drag .tres file into slot
   - Save scene

4. **Test** (3 min)
   - Run game (F5)
   - Use Enter key to level up quickly
   - Find upgrade in menu
   - Select it
   - Check HUD to verify accuracy increased

**Teacher Circulation:**
- Walk around helping students
- Common issues: Forgetting to save, wrong stat_type spelling
- Help struggling students catch up before moving on

---

### 4. Independent Practice (15 minutes)

**Activity:** Create Your Own Upgrade

**Instructions to Students:**
> "Choose a stat type (health, speed, accuracy, carry) and create your own upgrade. Be creative with the name and balance the amount!"

**Differentiation:**

**For Struggling Students:**
- Provide a template with most fields filled in
- Have them only change the name and amount
- Pair with a peer mentor

**For On-Level Students:**
- Create 2 different upgrades
- Experiment with different stat types
- Test and adjust values for balance

**For Advanced Students:**
- Create 3+ upgrades
- Create a themed set (e.g., "Tank" upgrades)
- Try to make all values balanced
- Complete extension challenge

**Monitoring Progress:**
- Check in with each student/group
- Ask guiding questions:
  - "Why did you choose that amount?"
  - "Is it too powerful or too weak?"
  - "How does it compare to other upgrades?"

---

### 5. Testing & Iteration (Optional - 10 minutes)

**Activity:** Playtest and Balance

**Steps:**
1. Students play their game and level up multiple times
2. Record stat values before/after on worksheet
3. Determine if upgrades feel balanced
4. Adjust amounts and retest

**Encourage Discussion:**
- "Does +20 health feel as valuable as +30 speed?"
- "Should legendary upgrades be 2x or 3x better?"
- "What makes an upgrade feel 'worth it'?"

**Math Connection:**
This is a great time to discuss ratios, percentages, and relative value!

---

### 6. Closure (5 minutes)

**Review Questions:**
1. "What is a Resource?" (Data container, saved as file)
2. "Why use Resources?" (No coding, visual, safe, reusable)
3. "What are the four stat types?" (health, speed, accuracy, carry)
4. "How do you add a Resource to the game?" (Drag to exported array)

**Exit Ticket Ideas:**
- Draw and label the Resource creation workflow
- Write one sentence explaining Resources
- List 2 advantages of Resources over dictionaries

**Preview Next Lesson:**
- "Next time, we'll create enemy types using Resources!"
- "We might add more stat types or create upgrade trees!"

---

## Assessment Rubric

### Formative Assessment (During Class)

**Checklist for Each Student:**
- [ ] Created at least 1 working upgrade
- [ ] Upgrade appears in level-up menu
- [ ] Upgrade correctly modifies player stats
- [ ] Saved files properly
- [ ] Can explain what a Resource is

### Summative Assessment (Worksheet or Project)

| Criteria | Developing (1-2) | Proficient (3) | Advanced (4) |
|----------|------------------|----------------|--------------|
| **Resource Creation** | Incomplete or non-functional | Created 1-2 working upgrades | Created 3+ working upgrades |
| **Configuration** | Properties incomplete/incorrect | All properties correctly set | Creative names/descriptions |
| **Integration** | Not added to game or errors | Successfully added to game | Added multiple, tested thoroughly |
| **Testing** | Did not test or fix issues | Tested and verified working | Tested, adjusted for balance |
| **Understanding** | Cannot explain Resources | Can explain basic concept | Can explain benefits and use cases |
| **Balance/Design** | Random values, no thought | Reasonable value choices | Well-balanced, thematically cohesive |

**Scoring:**
- 6-11 points: Needs improvement
- 12-17 points: Proficient
- 18-24 points: Advanced

---

## Common Issues & Solutions

### Issue 1: "Could not find type StatUpgradeResource"
**Cause:** Godot hasn't rescanned the project
**Solution:** Close and reopen Godot project

### Issue 2: Upgrade doesn't appear in menu
**Causes:**
- Not added to Available Upgrades array
- Array size not increased
- Scene not saved
**Solution:** Check each step, especially saving

### Issue 3: Upgrade does nothing
**Causes:**
- stat_type spelled wrong (common typo)
- amount is 0 or negative
- .tres file not saved after editing
**Solution:** Double-check spelling and values

### Issue 4: Game crashes when leveling up
**Causes:**
- Array slot is empty (null)
- Resource file corrupted
**Solution:** Remove empty slots, recreate resource

### Issue 5: Stats don't change in HUD
**Causes:**
- Wrong stat_type selected
- HUD script doesn't display that stat
**Solution:** Verify stat_type matches available types

---

## Extension Activities

### For Early Finishers:

1. **Create an Upgrade Family**
   - Make 3 related upgrades (small, medium, large)
   - Example: Health +10, +25, +50

2. **Design for Balance**
   - Create one upgrade for each stat type
   - Make them equally appealing
   - Test with peers to see which they choose most

3. **Add Visual Descriptions**
   - Write detailed, flavorful descriptions
   - Example: "The ancient warrior's technique grants newfound strength!"

4. **Research Real Games**
   - Find examples of upgrade systems in games they play
   - Document 5 upgrades and their values
   - Compare to what they created

### For Next Class:

1. **Enemy Resources**
   - Apply same concept to creating enemy types
   - Students create "easy", "medium", "hard" enemies

2. **Weapon Resources**
   - Create different weapon types as Resources
   - More complex with multiple properties

3. **Upgrade Trees**
   - Design prerequisites (need Upgrade A before getting Upgrade B)
   - Would require script modification (advanced)

---

## Differentiation Strategies

### For English Language Learners:
- Provide vocabulary list: Resource, property, export, array
- Use visual diagrams heavily
- Allow native language notes on worksheet
- Pair with bilingual peer buddy

### For Students with Special Needs:
- Printed step-by-step checklist with checkboxes
- Larger font materials
- Extended time (may need 2 class periods)
- Pre-created templates with partial completion
- Screen reader compatible materials

### For Gifted Students:
- Challenge: Create upgrade with icon
- Challenge: Balance 5+ upgrades mathematically
- Challenge: Design an upgrade progression system
- Allow to modify StatUpgradeResource.gd to add features

---

## Cross-Curricular Connections

### Math
- **Percentages**: Accuracy as a percentage multiplier
- **Addition**: Health and speed as additive bonuses
- **Ratios**: Comparing value of different upgrades
- **Graphing**: Plot stat progression over levels

### English/Language Arts
- **Creative Writing**: Write compelling upgrade descriptions
- **Technical Writing**: Document upgrade effects clearly
- **Vocabulary**: Game design terminology

### Art
- **Digital Art**: Create icons for upgrades (extension)
- **Color Theory**: Choose colors representing upgrade types
- **Design Principles**: Visual hierarchy in UI

### Business/Economics
- **Supply and Demand**: Balancing "cost" (rarity) vs "value" (power)
- **Game Monetization**: How upgrades relate to game economy
- **User Experience**: What makes players want upgrades

---

## Resources for Teacher Prep

### Before Class:
1. Review all three student materials:
   - LESSON_Creating_Stat_Upgrades.md (detailed guide)
   - QUICK_REFERENCE_Upgrades.md (fast lookup)
   - WORKSHEET_Stat_Upgrades.md (printable activity)

2. Create your own example upgrade:
   - Make a unique one to show students
   - Test it works before class

3. Verify project setup:
   - Open project in Godot
   - Confirm health_upgrade.tres and speed_upgrade.tres exist
   - Confirm they're added to arena.tscn (or show students empty array)

4. Prepare troubleshooting:
   - Know common error messages
   - Have spare .tres files ready
   - Bookmark this guide for quick reference

### During Class:
- Keep this guide open on second monitor
- Have example solutions ready to show
- Take notes on what worked/didn't for next time

### After Class:
- Review student work (check .tres files in resources/upgrades/)
- Note common mistakes for next iteration
- Share exemplary student work with class

---

## Sample Solutions

### Example 1: Balanced Accuracy Upgrade
```
upgrade_id: "accuracy_boost"
upgrade_name: "Accuracy +0.2x"
description: "Reduces weapon spread"
stat_type: "accuracy"
amount: 0.2
```

### Example 2: Large Health Upgrade
```
upgrade_id: "health_surge"
upgrade_name: "Max Health +50"
description: "Greatly increases your maximum health"
stat_type: "health"
amount: 50.0
```

### Example 3: Themed "Warrior" Set
**Warrior's Strength:**
```
stat_type: "health"
amount: 30.0
```

**Warrior's Agility:**
```
stat_type: "speed"
amount: 25.0
```

**Warrior's Focus:**
```
stat_type: "accuracy"
amount: 0.15
```

---

## Reflection for Teachers

After teaching this lesson, consider:

### What worked well?
- Which explanations resonated with students?
- What examples were most effective?
- Which students grasped it quickly?

### What needs improvement?
- Where did students get stuck?
- What instructions were unclear?
- What should be added/removed?

### Adjustments for next time:
- Time allocation (more/less time on certain sections)
- Additional examples needed
- Different analogies to try
- Prerequisite skills to review

---

## Additional Notes

### Grading Worksheet Quickly:
1. Check that 3 .tres files exist in resources/upgrades/
2. Open arena.tscn - verify they're in Available Upgrades array
3. Run game, level up, confirm they appear and work
4. Skim worksheet for understanding (reflection questions)
5. Use rubric for final grade

**Time to Grade:** ~5-10 minutes per student

### Parent Communication:
If parents ask what students learned:
> "Students learned data-driven design - how to add new content to games by editing data files rather than writing code. This is how professional game designers work! They created custom power-ups and learned about game balance through testing."

---

## Appendix: Key Vocabulary

| Term | Definition | Example |
|------|------------|---------|
| **Resource** | A data container saved as a file in Godot | `.tres` files |
| **Export** | Makes a variable editable in Inspector | `@export var name: String` |
| **Property** | A variable that stores data in a Resource | `upgrade_name`, `amount` |
| **Array** | A list that stores multiple items | Available Upgrades array |
| **Inspector** | Panel where you edit node/resource properties | Right side of Godot |
| **Stat** | A player attribute that can change | Health, speed, accuracy |
| **Balance** | Making game elements equally useful/fair | Testing if upgrades feel fair |

---

## Questions? Contact Info

If you need help with this lesson:
- Check LESSON_Creating_Stat_Upgrades.md for detailed steps
- See QUICK_REFERENCE_Upgrades.md for fast answers
- Review this guide for teaching strategies
- Godot documentation: https://docs.godotengine.org/

---

**Good luck with your lesson! Your students are going to create awesome upgrades! 🎮**
