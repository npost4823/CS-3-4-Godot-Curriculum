extends Area2D
class_name MaterialDrop

## Material pickup that drops from enemies
## Students will expand this to use different sprites per material type

@export var material_id: String = "iron_ore"
@export var amount: int = 1

var player: Node2D = null
var being_attracted: bool = false
var attraction_range: float = 100.0
var attraction_speed: float = 150.0
var collect_range: float = 20.0


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


## Add material to player inventory and remove this pickup
func collect() -> void:
	if Global.game_world and Global.game_world.inventory:
		Global.game_world.inventory.add_material(material_id, amount)
		print("Collected " + str(amount) + "x " + material_id)

	queue_free()
