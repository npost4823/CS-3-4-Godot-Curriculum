extends Node

var key = 0
var game_world: GameWorld = null



func _ready() -> void:
	game_world = get_tree().current_scene
