extends Area2D
class_name XPDrop

## XP pickup that drops from enemies
## Automatically moves toward player and grants XP on collection

@export var xp_amount: int = 10
@export var attraction_range: float = 150.0
@export var attraction_speed: float = 200.0
@export var collect_range: float = 20.0

var player: Node2D = null
var being_attracted: bool = false


func _ready() -> void:
	# Connect collision signal
	body_entered.connect(_on_body_entered)

	# Get player reference
	if Global.game_world and Global.game_world.has("player"):
		player = Global.game_world.player


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
