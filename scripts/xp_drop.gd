extends Area2D
class_name XPDrop

## XP pickup that drops from enemies
## Automatically moves toward player and grants XP on collection

@export var xp_amount: int = 10
@export var attraction_range: float = 150.0
@export var attraction_speed: float = 200.0
@export var collect_range: float = 20.0


var being_attracted: bool = false
var player: Player = null


func _ready() -> void:
	# Connect collision signal
	body_entered.connect(_on_body_entered)

	# Find the player
	_find_player()

	if not player:
		print("WARNING: XP Drop could not find Player!")


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
