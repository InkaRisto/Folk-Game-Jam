extends Node2D

#Hiisi plans
#if dead:
#		get_tree().call_deferred("change_scene_to_file", "win.tscn")

func _on_button_tester_button_down() -> void:
		get_tree().change_scene_to_file("start_menu.tscn") 
