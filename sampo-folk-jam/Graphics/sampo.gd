extends Area2D

@onready var hiisi_spawn = get_tree().root.find_child("HiisiSpawns", true, false)

var hiisi = preload("res://Hiisi.tscn")

func _on_body_entered(body: Node2D) -> void:
		if body == Globals.player:
			var hiisi_instance = hiisi.instantiate()
			get_parent().add_child(hiisi_instance)	
			$Sprite2D.visible = false
			hiisi_spawn.play()
			await get_tree().create_timer(1.3).timeout
			hiisi_instance.global_position = Vector2(218, 428)
			queue_free()
