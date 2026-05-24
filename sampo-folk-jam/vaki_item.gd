extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body == Globals.player:
		Globals.player.set_vaki(+1) 
		queue_free()
