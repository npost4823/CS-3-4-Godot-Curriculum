extends CanvasLayer
class_name LevelUpUI

## UI shown when player levels up
## Allows player to choose one stat upgrade
## Game pauses while this UI is shown

@onready var panel: Panel = $Panel
@onready var title_label: Label = $Panel/MarginContainer/VBoxContainer/TitleLabel
@onready var options_container: VBoxContainer = $Panel/MarginContainer/VBoxContainer/OptionsContainer

@onready var player: Player = %Player


# Stat upgrade options
var stat_upgrades = [
	{"name": "Max Health +20", "stat": "health", "amount": 20.0, "description": "Increases your maximum health"},
	{"name": "Movement Speed +30", "stat": "speed", "amount": 30.0, "description": "Move faster to dodge enemies"},
	{"name": "Accuracy +0.2x", "stat": "accuracy", "amount": 0.2, "description": "Reduces weapon spread"},
	{"name": "Carry Capacity +1", "stat": "carry", "amount": 1, "description": "Equip heavier weapons or dual wield"},
	{"name": "Crafting Efficiency +0.3x", "stat": "crafting", "amount": 0.3, "description": "Reduces materials needed for recipes"}
]


func _ready() -> void:
	# Get player reference
	
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

	# Pick 3 random upgrades to offer
	var offered_upgrades = stat_upgrades.duplicate()
	offered_upgrades.shuffle()
	offered_upgrades = offered_upgrades.slice(0, 3)

	# Create buttons for each option
	for upgrade in offered_upgrades:
		var button = Button.new()
		button.text = upgrade["name"] + "\n" + upgrade["description"]
		button.custom_minimum_size = Vector2(400, 60)
		button.pressed.connect(_on_upgrade_selected.bind(upgrade))
		options_container.add_child(button)

	show()


## Handle when player selects an upgrade
func _on_upgrade_selected(upgrade: Dictionary) -> void:
	if not player:
		return

	# Apply the upgrade
	match upgrade["stat"]:
		"health":
			player.upgrade_health(upgrade["amount"])
		"speed":
			player.upgrade_speed(upgrade["amount"])
		"accuracy":
			player.upgrade_accuracy(upgrade["amount"])
		"carry":
			player.upgrade_carry_capacity(int(upgrade["amount"]))
		"crafting":
			player.upgrade_crafting_efficiency(upgrade["amount"])

	# Hide UI and unpause
	hide()
	get_tree().paused = false
