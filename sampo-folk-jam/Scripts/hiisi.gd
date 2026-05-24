extends CharacterBody2D

enum State {IDLE, CHASE, MELEE, RANGED}
var state = State.IDLE
var player_distance : float
var speed : float = 80

var attacking : bool = false
var health : int = 25

var rock_scene = preload("res://Rock.tscn")

func _physics_process(delta):
	player_distance = global_position.distance_to(Globals.player.global_position)
	match state:
		State.IDLE:
			$AnimatedSprite2D.play("Idle")
			if player_distance < 200 && player_distance > 100:
				state = State.CHASE
		State.CHASE:
			$AnimatedSprite2D.play("Walk")
			chase_player()
			if player_distance < 80:
				state = State.MELEE
			elif player_distance < 200:
				state = State.RANGED
		State.MELEE:
			melee_attack()
		State.RANGED:
			ranged_attack()
			
func chase_player():
	var player_position = Globals.player.global_position
	var direction = (player_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
	
func melee_attack():
	if attacking:
		return
	#$AnimatedSprite2D.play("Swing")
	attacking = true
	$AttackTimer.start()
	$Circle.visible = !$Circle.visible #toggles attack
	print("Swing Attack")
	#Continue attacking if player present
	if $PlayerDetect.has_overlapping_areas():
		for area in $PlayerDetect.get_overlapping_areas():
			if area.name == "Hurtbox" && area.get_parent() == Globals.player:
				area.get_parent().player_take_damage(2)		
		
func _on_attack_timer_timeout() -> void:
	attacking = false
	state = State.CHASE
	
func ranged_attack():
	if attacking:
		return
	attacking = true
	$AttackTimer.start()
	#$AnimatedSprite2D.play("ThrowRock")
	
	var rock = rock_scene.instantiate()
	get_parent().add_child(rock)
	rock.global_position = global_position
	rock.direction = (Globals.player.global_position - global_position).normalized()
	
func take_damage(dmg: int):
	#$Animation.Play("Hurt")
	$HurtLabel.text = str(-dmg)	
	health -= dmg
	$HurtLabel.visible = true
	await get_tree().create_timer(0.5).timeout
	$HurtLabel.visible = false
	if health <= 0:
		queue_free()
		$"../ButtonTester".visible = true
		
func _on_hurtbox_area_entered(area: Area2D) -> void:
	if  area.get_parent() == Globals.player && area.get_parent().attacking:
		take_damage(2)

func _on_hurtbox_area_exited(area: Area2D) -> void:
	if area.get_parent() == Globals.player:
		attacking = false
		$AttackTimer.stop()
		$Circle.visible = false
		state = State.CHASE 
	if area.get_parent() == Globals.player:
		take_damage(2)
		
