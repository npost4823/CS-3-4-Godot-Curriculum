extends Resource
class_name StatUpgradeResource

## Configuration resource for player stat upgrades
## Used by the level up system to offer stat improvements
## Students will create different upgrades by duplicating this resource

@export_group("Upgrade Identity")
## Unique identifier for this upgrade
@export var upgrade_id: String = ""

## Display name shown to the player (e.g., "Max Health +20")
@export var upgrade_name: String = "Unknown Upgrade"

## Description explaining what this upgrade does
@export var description: String = ""

## Optional icon to display with the upgrade
@export var icon: Texture2D

@export_group("Upgrade Effect")
## Type of stat to upgrade (health, speed, accuracy, carry)
@export_enum("health", "speed", "accuracy", "carry") var stat_type: String = "health"

## Amount to increase the stat by
@export var amount: float = 0.0


## Apply this upgrade to the player
## Returns true if successfully applied
func apply_to_player(player: Player) -> bool:
	if not player:
		return false

	match stat_type:
		"health":
			player.upgrade_health(amount)
		"speed":
			player.upgrade_speed(amount)
		"accuracy":
			player.upgrade_accuracy(amount)
		"carry":
			player.upgrade_carry_capacity(int(amount))
		_:
			push_error("Unknown stat_type: " + stat_type)
			return false

	return true


## Get the full display text for this upgrade
func get_display_text() -> String:
	return upgrade_name + "\n" + description
