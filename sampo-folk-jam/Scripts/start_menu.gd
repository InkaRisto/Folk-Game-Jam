extends Control

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var audio_stream_player_2d_2: AudioStreamPlayer2D = $AudioStreamPlayer2D2

func _on_button_button_down() -> void:
	get_tree().change_scene_to_file("BaseLevel.tscn")


func _on_button_quit_button_down() -> void:
	get_tree().quit()

func _on_button_play_mouse_entered() -> void:
	audio_stream_player_2d.play() 

func _on_button_quit_mouse_entered() -> void:
	audio_stream_player_2d.play() 
