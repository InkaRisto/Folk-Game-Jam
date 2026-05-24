extends Area2D

var item_scenes = [preload("res://sisu_item.tscn"), preload("res://vaki_item.tscn")]
var sampo_scene = preload("res://sampo.tscn")

var sampo_instance = null

@export var item_type = "sisu"

func spawn_items():
	var shuffled = item_scenes.duplicate()
	shuffled.shuffle()
	for item in shuffled:
		var instance = item.instantiate()
		instance.position = get_random_position()
		add_child(instance)

func spawn_sampo():
	if sampo_instance == null:
		sampo_instance = sampo_scene.instantiate()
		add_child(sampo_instance)
		sampo_instance.global_position = Vector2(218, 428) #Could come from an array of goals

func collect():
	if item_type == "sisu":
		Globals.player.player_take_damage(-2)  # heal
	elif item_type == "vaki":
		Globals.player.set_vaki(1)
	elif item_type == "sampo":
		# trigger sampo logic
		pass

func get_random_position(x_range, y_range):
	var x_value: float = randf_range(0, 416) #room1 x
	var y_value: float = randf_range(0, 288) #room1 y
	return Vector2(x_value, y_value)
