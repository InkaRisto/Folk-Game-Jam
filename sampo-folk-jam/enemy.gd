extends CharacterBody2D

var speed = 50
var direction : Vector2 = Vector2.ZERO
var wander_timer = 0.0
var positions : Array
var temp_positions : Array
var current_position : Marker2D

func _ready():
	positions = get_tree().get_nodes_in_group("Waypoints")
	get_positions()
	get_next_position()
	
func _physics_process(delta):
	if global_position.distance_to(current_position.position) < 10:
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

func take_damage(dmg: int):
	#$Animation.Play("Hurt")
	$HurtLabel.text = str(-dmg)	
	$HurtLabel.visible = true
	await get_tree().create_timer(0.5).timeout
	$HurtLabel.visible = false
	
func _on_player_detect_area_entered(area: Area2D) -> void:
	print("Player detected")
	
func set_animation(direction : float) -> void:
	#Prioritise Hurt
	#if $Animation.current_animation == "Hurt" || $Animation.current_animation == "Attack":
	#	return
	#Flip player sprite when necessary
	#$PlayerSprite2D.flip_h = direction < 0 #true/false
	
	#Start the animation based on movement
	#if is_on_floor() and velocity.x != 0:
	#	$Animation.play("Walk")
	#elif not is_on_floor() && velocity.y > 0:
	#	$Animation.play("Land")
	#elif not is_on_floor() && velocity.y < 0:
	#	$Animation.play("Jump")
	#else: 
	#	$Animation.play("Idle")
	pass
