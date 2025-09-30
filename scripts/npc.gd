extends CharacterBody2D
class_name npc

@onready var player: Player = %Player

@export var health : int = 10
@export var speed : int = 200
@export var is_hostile : bool = false
@export var move_points : Array[Vector2] = []
@export var move_point : int = 0
@export var dialogue : Array[String] = []
@export var inventory : Array[String] = []
@export var inventory_drop : int = 0
#@export var state
@export var type : String = ""
@export var target : Vector2 

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	movement(delta)
	pass
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_area_2d_body_exited(body: Node2D) -> void:
	pass # Replace with function body.

func movement(_delta):
	if is_hostile:
		target = player.position
	else:
		target = move_points[move_point]
	pass
