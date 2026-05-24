extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body == Globals.player:
		Globals.player.player_take_damage(-1) #heal
		queue_free()
