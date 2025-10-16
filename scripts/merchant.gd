extends npc
@onready var menu: Node2D = $Menu





func _on_button_pressed() -> void:
	player.coins = player.coins - 1
	player.health = player.health + 2
	print("You payed one coin and you got two health. You now have " + str(player.coins) + " coins. You now have " + str(player.health) + " Health.")


func _on_collision_area_body_entered(body: Node2D) -> void:
	if body is Player:
		menu.visible = true


func _on_collision_area_body_exited(body: Node2D) -> void:
	if body is Player:
		menu.visible = false
