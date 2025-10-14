extends npc
class_name enemy_base
@onready var sprite: Sprite2D = $Sprite2D


@export var move_speed: float = 5




func _ready() -> void:
	pass
	#player = Global.game_world.player
	

func _process(delta: float) -> void:
	pass
	# MOVE TWOARD PLAYER
