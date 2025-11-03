extends CanvasLayer
class_name LevelUpUI

## UI shown when player levels up
## Allows player to choose one stat upgrade from available upgrade resources
## Game pauses while this UI is shown
##
## TEACHING NOTE: This system uses Resources to define upgrades!
## Students can create new upgrades by:
## 1. Right-clicking in resources/upgrades/ folder
## 2. Creating a new StatUpgradeResource
## 3. Configuring the upgrade properties
## 4. Adding the resource path to available_upgrades array below

@onready var panel: Panel = $Panel
@onready var title_label: Label = $Panel/MarginContainer/VBoxContainer/TitleLabel
@onready var options_container: VBoxContainer = $Panel/MarginContainer/VBoxContainer/OptionsContainer

@onready var player: Player = %Player


## Available upgrade resources
## Add more .tres files here as students create them
## NOTE: Array type will show as Array[StatUpgradeResource] once Godot rescans the project
@export var available_upgrades: Array[StatUpgradeResource] = [] 


func _ready() -> void:
	print("Array size: ", available_upgrades.size())
	print("Array contents: ", available_upgrades)

	player.level_up.connect(_on_player_level_up)

	# Hide by default
	hide()



func _on_player_level_up(new_level: int) -> void:
	show_upgrade_options(new_level)


## Show the upgrade selection screen
func show_upgrade_options(level: int) -> void:
	# Pause game
	get_tree().paused = true

	# Update title
	title_label.text = "Level " + str(level) + " - Choose an Upgrade!"

	# Clear existing options
	for child in options_container.get_children():
		child.queue_free()

	# Pick up to 3 random upgrades to offer (or all if less than 3)
	var offered_upgrades = available_upgrades.duplicate()
	offered_upgrades.shuffle()
	var num_to_offer = min(3, offered_upgrades.size())
	offered_upgrades = offered_upgrades.slice(0, num_to_offer)

	# Create buttons for each upgrade resource
	for upgrade_resource in offered_upgrades:
		var button = Button.new()
		button.text = upgrade_resource.get_display_text()
		button.custom_minimum_size = Vector2(400, 60)
		button.pressed.connect(_on_upgrade_selected.bind(upgrade_resource))
		options_container.add_child(button)

	show()


## Handle when player selects an upgrade
func _on_upgrade_selected(upgrade) -> void:
	if not player or not upgrade:
		return

	# Apply the upgrade using the resource's method
	# upgrade should be a StatUpgradeResource
	upgrade.apply_to_player(player)

	# Hide UI and unpause
	hide()
	get_tree().paused = false
