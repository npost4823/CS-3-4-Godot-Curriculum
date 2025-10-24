extends Area2D




func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		Global.key = Global.key + 1
		queue_free()
