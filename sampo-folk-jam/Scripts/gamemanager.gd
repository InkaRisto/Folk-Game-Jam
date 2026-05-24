extends Node2D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Exit"):
		get_tree().change_scene_to_file("res://start_menu.tscn")

func _on_button_tester_button_down() -> void:
		get_tree().change_scene_to_file("start_menu.tscn") 
