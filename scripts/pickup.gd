# This next line allows the color of the coin to update without running the game
# It can mostly be ignored, but it must be the first line of the script
@tool

extends Area2D
class_name pickup

@export var color: Color
@export var amount : int = 1
@export var type : String = ""
@export var label : String = ""
@export var auto_pickup : bool = true

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	# Set the color of the pickup
	$AnimatedSprite2D.material.set_shader_parameter("color", color)

func _on_body_entered(body):
	if body is Player:
			# Remove the potion after use
			if auto_pickup:
				$AnimationPlayer.play("disappear")
		else:
			print("Player doesn't have heal() method yet - coming in Lesson 2!")
