extends Resource
class_name RecipeResource

## Defines a crafting recipe that combines materials into a weapon or item
## Students will create recipes to upgrade their weapons
## Example: 2x Iron Ore + 1x Wood -> Iron Arrow (better projectile)

@export_group("Recipe Info")
## Unique identifier for this recipe
@export var recipe_id: String = ""

## Display name for the recipe
@export var recipe_name: String = "Unknown Recipe"

## What category does this recipe belong to?
@export_enum("Weapon Upgrade", "Weapon Craft", "Consumable", "Special") var recipe_category: String = "Weapon Craft"

@export_group("Ingredients Required")
## List of material IDs needed and their quantities
## Format: {"material_id": quantity_needed}
## Example: {"iron_ore": 2, "wood": 1}
@export var required_materials: Dictionary = {}

@export_group("Recipe Result")
## What item is produced? (must match an ItemResource's item_id)
@export var output_item_id: String = ""

## How many of the item are produced?
@export var output_quantity: int = 1

@export_group("Crafting Requirements")
## Minimum crafting efficiency level needed to use this recipe
## (Higher efficiency from leveling unlocks complex recipes)
@export var min_crafting_level: int = 1

## Icon/preview of what this recipe creates
@export var result_icon: Texture2D


## Check if the player has the required materials in inventory
func can_craft(inventory_materials: Dictionary) -> bool:
	for material_id in required_materials.keys():
		var needed_amount = required_materials[material_id]
		var has_amount = inventory_materials.get(material_id, 0)

		if has_amount < needed_amount:
			return false

	return true


## Calculate actual material cost with crafting efficiency bonus
## Higher efficiency = less materials needed
func get_adjusted_material_cost(crafting_efficiency: float) -> Dictionary:
	var adjusted_cost = {}

	for material_id in required_materials.keys():
		var base_cost = required_materials[material_id]
		# Efficiency reduces cost (max 50% reduction at efficiency 2.0)
		var reduction = clamp(crafting_efficiency - 1.0, 0.0, 1.0) * 0.5
		var final_cost = max(1, int(base_cost * (1.0 - reduction)))
		adjusted_cost[material_id] = final_cost

	return adjusted_cost


## Returns a formatted string of materials needed for UI display
func get_materials_display_text() -> String:
	var text = ""
	for material_id in required_materials.keys():
		text += material_id + " x" + str(required_materials[material_id]) + "\n"
	return text
