extends CanvasLayer
class_name CraftingUI

## UI for crafting weapons from materials
## Shows available recipes and material requirements
## Press 'C' to toggle crafting display

@onready var panel: Panel = $Panel
@onready var recipes_list: VBoxContainer = $Panel/MarginContainer/VBoxContainer/HSplitContainer/RecipesSection/RecipesList
@onready var recipe_details: VBoxContainer = $Panel/MarginContainer/VBoxContainer/HSplitContainer/DetailsSection/DetailsContent
@onready var craft_button: Button = $Panel/MarginContainer/VBoxContainer/HSplitContainer/DetailsSection/CraftButton
@onready var close_button: Button = $Panel/MarginContainer/VBoxContainer/CloseButton

var crafting_system: CraftingSystem = null
@onready var inventory: InventorySystem = $"../InventorySystem"
@onready var player: Player = %Player

var selected_recipe: RecipeResource = null


func _ready() -> void:
	# Create crafting system
	crafting_system = CraftingSystem.new()
	add_child(crafting_system)

	# Pass references to crafting system
	crafting_system.inventory = inventory
	crafting_system.player = player

	# Load available recipes
	_load_recipes()

	# Connect signals
	craft_button.pressed.connect(_on_craft_pressed)
	close_button.pressed.connect(_on_close_pressed)

	if inventory:
		inventory.inventory_changed.connect(_update_display)

	# Hide by default
	hide()
	craft_button.disabled = true


func _input(event: InputEvent) -> void:
	# Toggle crafting with 'C' key (ui_cancel mapped differently)
	if event is InputEventKey and event.pressed and event.keycode == KEY_C:
		toggle_crafting()


## Toggle crafting UI visibility
func toggle_crafting() -> void:
	visible = not visible
	if visible:
		_update_display()


## Load available recipes
func _load_recipes() -> void:
	# Try to load recipe files
	var recipes_path = "res://resources/recipes/"

	# Load rapid pistol recipe
	var rapid_recipe = load(recipes_path + "craft_rapid_pistol.tres")
	if rapid_recipe and crafting_system:
		crafting_system.available_recipes.append(rapid_recipe)


## Update the entire display
func _update_display() -> void:
	if not visible or not crafting_system:
		return

	_update_recipes_list()
	_update_recipe_details()


## Update the recipes list
func _update_recipes_list() -> void:
	# Clear existing items
	for child in recipes_list.get_children():
		child.queue_free()

	if not crafting_system:
		return

	# Display each recipe
	for recipe in crafting_system.available_recipes:
		var recipe_button = Button.new()

		# Check if craftable
		var can_craft = crafting_system.can_craft_recipe(recipe)

		# Set button text and color
		recipe_button.text = recipe.recipe_name
		if can_craft:
			recipe_button.modulate = Color.GREEN
		else:
			recipe_button.modulate = Color.GRAY

		recipe_button.pressed.connect(_on_recipe_selected.bind(recipe))
		recipes_list.add_child(recipe_button)

	# Show message if no recipes
	if crafting_system.available_recipes.size() == 0:
		var no_recipes_label = Label.new()
		no_recipes_label.text = "No recipes available"
		recipes_list.add_child(no_recipes_label)


## Update recipe details panel
func _update_recipe_details() -> void:
	# Clear existing details
	for child in recipe_details.get_children():
		child.queue_free()

	if not selected_recipe:
		var no_selection_label = Label.new()
		no_selection_label.text = "Select a recipe to view details"
		recipe_details.add_child(no_selection_label)
		craft_button.disabled = true
		return

	# Recipe name
	var name_label = Label.new()
	name_label.text = "Recipe: " + selected_recipe.recipe_name
	name_label.add_theme_font_size_override("font_size", 18)
	recipe_details.add_child(name_label)

	# Category
	var category_label = Label.new()
	category_label.text = "Category: " + selected_recipe.recipe_category
	recipe_details.add_child(category_label)

	# Materials required
	var materials_label = Label.new()
	materials_label.text = "\nMaterials Required:"
	materials_label.add_theme_font_size_override("font_size", 14)
	recipe_details.add_child(materials_label)

	# Get adjusted costs with crafting efficiency
	var adjusted_cost = selected_recipe.required_materials
	if player:
		adjusted_cost = selected_recipe.get_adjusted_material_cost(player.crafting_efficiency)

	# List each material
	for material_id in adjusted_cost.keys():
		var needed = adjusted_cost[material_id]
		var has = 0
		if inventory:
			has = inventory.get_material_count(material_id)

		var material_label = Label.new()
		material_label.text = "  • " + material_id + ": " + str(has) + "/" + str(needed)

		if has >= needed:
			material_label.modulate = Color.GREEN
		else:
			material_label.modulate = Color.RED

		recipe_details.add_child(material_label)

	# Output
	var output_label = Label.new()
	output_label.text = "\nProduces:\n  • " + selected_recipe.output_item_id + " x" + str(selected_recipe.output_quantity)
	recipe_details.add_child(output_label)

	# Crafting level requirement
	if selected_recipe.min_crafting_level > 1:
		var level_label = Label.new()
		level_label.text = "\nRequires Crafting Level: " + str(selected_recipe.min_crafting_level)
		recipe_details.add_child(level_label)

	# Update craft button
	var can_craft = crafting_system.can_craft_recipe(selected_recipe)
	craft_button.disabled = not can_craft
	craft_button.text = "Craft" if can_craft else "Cannot Craft (Missing Materials)"


## Handle recipe selection
func _on_recipe_selected(recipe: RecipeResource) -> void:
	selected_recipe = recipe
	_update_recipe_details()


## Handle craft button press
func _on_craft_pressed() -> void:
	if not selected_recipe or not crafting_system:
		return

	var success = crafting_system.craft_recipe(selected_recipe)

	if success:
		print("✅ Successfully crafted: " + selected_recipe.recipe_name)

		# TODO: Actually give the player the weapon
		# For now, just add to inventory
		# This requires loading the weapon Resource file

		# Update display
		_update_display()
	else:
		print("❌ Failed to craft: " + selected_recipe.recipe_name)


## Close button handler
func _on_close_pressed() -> void:
	hide()
