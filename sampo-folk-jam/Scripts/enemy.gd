extends CharacterBody2D

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var speed = 50
var direction : Vector2 = Vector2.ZERO
var wander_timer = 0.0
var positions : Array
var temp_positions : Array
var current_position : Marker2D

var dealing_dmg : bool = false
var health : int = 10

var stuck_timer = 0.0
var last_position = Vector2.ZERO

var sampo_scene = preload("res://sampo.tscn")
var appeared = false

func _ready():
	await get_tree().create_timer(1.8).timeout
	$AnimationPlayer.play("Appear")
	positions = get_tree().get_nodes_in_group("Waypoints")
	get_positions()
	get_next_position()
	
func _physics_process(delta):
	if !appeared:
		return
	if dealing_dmg:
		velocity = Vector2.ZERO
		return
	if global_position.distance_to(current_position.global_position) < 10:
		get_next_position()
		
	if global_position.distance_to(last_position) < 2.0:
		stuck_timer += delta
		if stuck_timer > 0.5:
			get_next_position()
			stuck_timer = 0.0
		else:
			stuck_timer = 0.0
			
		last_position = global_position
		
		if global_position.distance_to(current_position.global_position) < 10:
			get_next_position()
	
	velocity = direction * speed
	move_and_slide()

func get_positions():
	temp_positions = positions.duplicate()
	temp_positions.shuffle()
	
func get_next_position():
	if temp_positions.is_empty():
		get_positions()
	current_position = temp_positions.pop_front()
	direction = (current_position.global_position - global_position).normalized()

func enemy_take_damage(dmg: int):
	audio_stream_player_2d.play()
	$HurtLabel.text = str(-dmg)	
	health -= dmg
	$HurtLabel.visible = true
	await get_tree().create_timer(0.5).timeout
	$HurtLabel.visible = false
	if health <= 0:
		queue_free()
		var sampo_instance = sampo_scene.instantiate()
		get_parent().add_child(sampo_instance)
		sampo_instance.global_position = Vector2(445, 560)

	
func _on_player_detect_area_entered(area: Area2D) -> void:
	if area.name == "Hurtbox" && area.get_parent() == Globals.player:
		dealing_dmg = true
		$AttackTimer.start()

func _on_player_detect_area_exited(area: Area2D) -> void:
	if area.get_parent() == Globals.player:
		dealing_dmg = false
		$AttackTimer.stop()
		$Circle.visible = false
		
func _on_attack_timer_timeout() -> void:
		$Circle.visible = !$Circle.visible #toggles attack
		#Continue attacking if player present
		if $PlayerDetect.has_overlapping_areas():
			for area in $PlayerDetect.get_overlapping_areas():
				if area.name == "Hurtbox" && area.get_parent() == Globals.player:
					area.get_parent().player_take_damage(1)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Appear":
		appeared = true
		$AnimationPlayer.play("Idle")
