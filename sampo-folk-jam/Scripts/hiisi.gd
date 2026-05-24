extends CharacterBody2D

@onready var hiisi_dies = get_tree().root.find_child("HiisiDies", true, false)
@onready var hiisi_laughs = get_tree().root.find_child("HiisiLaughs", true, false)
@onready var hiisi_spawn = get_tree().root.find_child("HiisiSpawns", true, false)
@onready var hiisi_music = get_tree().root.find_child("HiisiMusic", true, false)
@onready var forest_ambience = get_tree().root.find_child("ForestAmbience", true, false)

enum State {IDLE, CHASE, MELEE, RANGED}
var state = State.IDLE
var player_distance : float
var speed : float = 80

var attacking : bool = false
var health : int = 50

var rock_scene = preload("res://Rock.tscn")
var sisu_scene = preload("res://sisu_item.tscn")

func _ready():
	forest_ambience.stream_paused = true
	hiisi_music.play()

func _physics_process(delta):
	player_distance = global_position.distance_to(Globals.player.global_position)
	
	match state:
		State.IDLE:
			$AnimatedSprite2D.play("Idle")
			if player_distance < 150 && player_distance > 100:
				state = State.CHASE
		State.CHASE:
			$AnimatedSprite2D.play("Walk")
			chase_player()
			if player_distance < 100:
				state = State.MELEE
			elif player_distance < 200:
				state = State.RANGED
		State.MELEE:
			$AnimatedSprite2D.play("Swing")
			melee_attack()
		State.RANGED:
			$AnimatedSprite2D.play("ThrowRock")
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
	print("Swing Attack")
	#Continue attacking if player present
	if $PlayerDetect.has_overlapping_areas():
		for area in $PlayerDetect.get_overlapping_areas():
			if area.name == "Hurtbox" && area.get_parent() == Globals.player:
				area.get_parent().player_take_damage(2)		
		
func _on_attack_timer_timeout() -> void:
	if randi_range(0,99) <= 8 && !hiisi_spawn.playing:
				hiisi_laughs.play()
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
	var chance = randi_range(0,99) 
	if health < 25 && chance < 50:
		spawn_item()
	if health <= 0:
		hiisi_dies.play()
		$AnimatedSprite2D.visible = false
		await get_tree().create_timer(2.5).timeout
		queue_free()
		$"../ButtonTester".visible = true

func spawn_item():
	var item = sisu_scene.instantiate()
	get_parent().add_child(item)
	item.global_position = Vector2(randf_range(112, 512), randf_range(448, 656)) #Hiisi room
		
func _on_hurtbox_area_entered(area: Area2D) -> void:
	if  area.get_parent() == Globals.player && area.get_parent().attacking:
		take_damage(2)

func _on_hurtbox_area_exited(area: Area2D) -> void:
	if area.get_parent() == Globals.player:
		attacking = false
		$AttackTimer.stop()
		state = State.CHASE 
	if area.get_parent() == Globals.player:
		take_damage(2)
		
