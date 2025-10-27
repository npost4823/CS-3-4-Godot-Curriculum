extends Node
class_name CraftingSystem

## Manages crafting recipes and weapon creation
## Uses RecipeResources to define what can be crafted
## Works with InventorySystem to check and consume materials

@export var available_recipes: Array[RecipeResource] = []

# References set by CraftingUI
var player: Player = null
var inventory: InventorySystem = null

signal recipe_crafted(item_id: String)


## Check if a recipe can be crafted
func can_craft_recipe(recipe: RecipeResource) -> bool:
	if not inventory or not player:
		return false

	# Check crafting level requirement
	if recipe.min_crafting_level > int(player.crafting_efficiency):
		return false

	# Check materials with crafting efficiency bonus
	var adjusted_cost = recipe.get_adjusted_material_cost(player.crafting_efficiency)
	return inventory.has_materials(adjusted_cost)


## Attempt to craft a recipe
func craft_recipe(recipe: RecipeResource) -> bool:
	if not can_craft_recipe(recipe):
		print("Cannot craft " + recipe.recipe_name + " - missing requirements!")
		return false

	# Get adjusted material cost
	var adjusted_cost = recipe.get_adjusted_material_cost(player.crafting_efficiency)

	# Consume materials
	if not inventory.consume_materials(adjusted_cost):
		return false

	# Create the output item
	_create_crafted_item(recipe)

	print("Successfully crafted: " + recipe.recipe_name + "!")
	recipe_crafted.emit(recipe.output_item_id)
	return true


## Create the crafted item and add to inventory
## Returns true if item was created successfully
func _create_crafted_item(recipe: RecipeResource) -> bool:
	if not recipe:
		return false

	# Load the output item Resource
	# For weapons, add to inventory
	# Students will expand this to handle different item types

	print("Created " + str(recipe.output_quantity) + "x " + recipe.output_item_id)

	# TODO: Load the actual weapon resource and add to inventory
	# This requires a resource database/registry system that students will implement

	return true


## Get all recipes the player can currently craft
func get_craftable_recipes() -> Array[RecipeResource]:
	var craftable: Array[RecipeResource] = []

	for recipe in available_recipes:
		if can_craft_recipe(recipe):
			craftable.append(recipe)

	return craftable


## Get all recipes (for display purposes)
func get_all_recipes() -> Array[RecipeResource]:
	return available_recipes
