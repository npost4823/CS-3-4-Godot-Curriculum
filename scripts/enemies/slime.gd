extends npc
func _on_hurt_radius_body_entered(body: Node2D) -> void:
	if body is Player:
		player.take_damage(1)
