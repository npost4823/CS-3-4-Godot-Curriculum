@tool

extends pickup
class_name HealthPotion

func use_potion(player: Player):
	"""Alternative method for manual potion use"""
	if player.has_method("change_health"):
		player.change_health(amount)
		$AnimationPlayer.play("disappear")
		return true
	return false
