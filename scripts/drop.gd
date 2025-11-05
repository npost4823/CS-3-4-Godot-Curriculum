extends Area2D
class_name Drop

## ============================================================================
## DROP - XP pickups that drop from defeated enemies
## ============================================================================
##
## WHAT THIS SCRIPT DOES:
## This script controls XP drops. When enemies die, they spawn these pickups.
## The drops:
## - Float in place for a moment
## - Detect when player gets close
## - Fly toward the player (magnetic attraction)
## - Grant XP to player on collection
## - Destroy themselves after being collected
##
## This script works with:
## - scripts/enemies/enemy_base.gd (spawns drops when dying)
## - scripts/player.gd (receives XP from drops)
## - scenes/drop.tscn (the drop scene)
##
## ============================================================================
## COMMON MODIFICATIONS:
## ============================================================================
##
## Change attraction range (how close player needs to be):
##   - Find: @export var attraction_range: float = 200.0
##   - Increase for easier collection, decrease for more challenge
##
## Change attraction speed:
##   - Find: @export var attraction_speed: float = 450.0
##   - Higher = drops fly to you faster
##
## Change XP values:
##   - XP amount is set by enemy when dropping (see enemy_resource.gd)
##   - Different drops can give different XP amounts
##
## ============================================================================
## ADVANCED: New Features
## ============================================================================
##
## Add different drop types:
##   - Create new Drop variants (health drops, coin drops, etc.)
##   - Add enum for drop type
##   - Apply different effects in _on_body_entered()
##
## Add visual variety:
##   - Set sprite/texture based on XP value (big gems for high XP)
##   - Add particle effects or glowing
##
## Add drop magnets:
##   - Increase attraction_range when player has magnet upgrade
##   - Read player stats/upgrades to modify behavior
##
## ============================================================================

@export var xp_amount: int = 10
@export var attraction_range: float = 200.0
@export var attraction_speed: float = 450.0
@export var collect_range: float = 20.0


var being_attracted: bool = false
var player: Player = null


func _ready() -> void:
	# Connect collision signal
	body_entered.connect(_on_body_entered)

	# Find the player
	_find_player()

	if not player:
		print("WARNING: Drop could not find Player!")


func _process(delta: float) -> void:
	if not player or not is_instance_valid(player):
		return

	var distance_to_player = global_position.distance_to(player.global_position)

	# Start being attracted if player is close enough
	if distance_to_player <= attraction_range:
		being_attracted = true

	# Move toward player if attracted
	if being_attracted:
		var direction = (player.global_position - global_position).normalized()
		global_position += direction * attraction_speed * delta

		# Auto-collect if very close
		if distance_to_player <= collect_range:
			collect()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		collect()


## Grant XP to player and remove this pickup
func collect() -> void:
	if player and player.has_method("gain_experience"):
		player.gain_experience(xp_amount)
	queue_free()


## Find the player in the scene tree
func _find_player() -> void:
	# Try to get player by unique name first
	player = get_node_or_null("%Player")

	# If that fails, search the scene tree for a Player node
	if not player:
		var root = get_tree().root
		player = _search_for_player(root)


## Recursively search for Player node
func _search_for_player(node: Node) -> Player:
	# Check if this node is the player
	if node is Player:
		return node

	# Search children
	for child in node.get_children():
		var found = _search_for_player(child)
		if found:
			return found

	return null
