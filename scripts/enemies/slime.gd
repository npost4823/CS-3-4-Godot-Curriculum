extends enemy_base



func _on_hurt_radius_body_entered(body: Node2D) -> void:
	if body is Player:
		player.take_damage(1)


func _on_detection_radius_body_entered(body: Node2D) -> void:
	if body is Player:
		is_hostile = true
		
	


func _on_detection_radius_body_exited(body: Node2D) -> void:
	if body is Player:
		is_hostile = false
