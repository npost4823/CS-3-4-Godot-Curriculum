extends CanvasLayer
class_name InventoryUI

## UI for displaying player inventory
## Shows materials in a grid and weapons in a list
## Press 'I' to toggle inventory display

@onready var panel: Panel = $Panel
@onready var materials_grid: GridContainer = $Panel/MarginContainer/VBoxContainer/MaterialsSection/MaterialsGrid
@onready var weapons_list: VBoxContainer = $Panel/MarginContainer/VBoxContainer/WeaponsSection/WeaponsList
@onready var close_button: Button = $Panel/MarginContainer/VBoxContainer/CloseButton

@onready var inventory: InventorySystem = $"../InventorySystem"

@onready var player: Player = %Player


# Preload material Resource files for display
var material_resources: Dictionary = {}


func _ready() -> void:
	# Get references
	

	# Load material Resources for icons/names
	_load_material_resources()

	# Connect signals
	if inventory:
		inventory.inventory_changed.connect(_update_display)

	close_button.pressed.connect(_on_close_pressed)

	# Hide by default
	hide()
	_update_display()


func _input(event: InputEvent) -> void:
	# Toggle inventory with 'I' key
	if event.is_action_pressed("ui_text_completion_query"):  # Tab key
		toggle_inventory()


## Toggle inventory visibility
func toggle_inventory() -> void:
	visible = not visible
	if visible:
		_update_display()


## Load material Resources for display info
func _load_material_resources() -> void:
	# Try to load known materials
	var materials_path = "res://resources/materials/"

	# Load iron ore
	var iron = load(materials_path + "iron_ore.tres")
	if iron:
		material_resources["iron_ore"] = iron

	# Load magic essence
	var magic = load(materials_path + "magic_essence.tres")
	if magic:
		material_resources["magic_essence"] = magic


## Update the entire display
func _update_display() -> void:
	if not visible or not inventory:
		return

	_update_materials_grid()
	_update_weapons_list()


## Update the materials grid
func _update_materials_grid() -> void:
	# Clear existing items
	for child in materials_grid.get_children():
		child.queue_free()

	if not inventory:
		return

	# Display each material
	for material_id in inventory.materials.keys():
		var quantity = inventory.materials[material_id]

		# Create material display
		var material_container = VBoxContainer.new()

		# Icon (if we have the resource loaded)
		var icon_rect = TextureRect.new()
		icon_rect.custom_minimum_size = Vector2(48, 48)
		icon_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		icon_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

		if material_resources.has(material_id):
			var material_res = material_resources[material_id]
			if material_res.icon:
				icon_rect.texture = material_res.icon

		material_container.add_child(icon_rect)

		# Name and quantity
		var label = Label.new()
		label.text = material_id + "\nx" + str(quantity)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		material_container.add_child(label)

		materials_grid.add_child(material_container)


## Update the weapons list
func _update_weapons_list() -> void:
	# Clear existing items
	for child in weapons_list.get_children():
		child.queue_free()

	if not inventory:
		return

	# Display each weapon
	for weapon in inventory.weapons:
		var weapon_button = Button.new()
		weapon_button.text = weapon.item_name + " (Damage: " + str(weapon.base_damage) + ")"
		weapon_button.pressed.connect(_on_weapon_selected.bind(weapon))
		weapons_list.add_child(weapon_button)

	# Show message if no weapons
	if inventory.weapons.size() == 0:
		var no_weapons_label = Label.new()
		no_weapons_label.text = "No weapons in inventory"
		weapons_list.add_child(no_weapons_label)


## Handle weapon selection
func _on_weapon_selected(weapon: WeaponResource) -> void:
	if inventory:
		inventory.equip_weapon(weapon)

		# Update weapon system if player has one
		if player:
			var weapon_system = player.get_node_or_null("WeaponSystem")
			if weapon_system and weapon_system.has_method("equip_weapon"):
				weapon_system.equip_weapon(weapon)

	print("Equipped: " + weapon.item_name)


## Close button handler
func _on_close_pressed() -> void:
	hide()
