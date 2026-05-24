extends CharacterBody2D

@export var speed = 100.0
@export var acceleration = 15.0 #For horizontal movement
@export var deceleration = 150.0 #For horizontal movement
@export var sisu = 3
@export var vaki = 5

@onready var vaki_label = %LabelVaki
@onready var sisu_label = %LabelSisu
@onready var player_gets_hit: AudioStreamPlayer2D = $"../Sounds/PlayerGetsHit"
@onready var sword_hits: AudioStreamPlayer2D = $"../Sounds/SwordHits"
@onready var player_falls: AudioStreamPlayer2D = $"../Sounds/PlayerFalls"

var sword_sounds : Array
var attacking = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	$Animation.play("Idle")
	Globals.player = self
	sword_sounds = [
		preload("res://Sounds/SWORD HIT 2.wav"),
		preload("res://Sounds/SWORD HIT 3.wav"),
	]
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Attack"):
		Attack()
		$Animation.play("Attack")

	#Horizontal movement
	var directionLR = Input.get_axis("Left", "Right")
	var directionUD = Input.get_axis("Up", "Down")
	
	if directionLR != null || directionUD != null:
		#Player gave movement horizontal
		velocity.x = move_toward(velocity.x, directionLR * speed, acceleration) #Function for applying movement
		#Player gave movement vertical
		velocity.y = move_toward(velocity.y, directionUD * speed, acceleration)
		if !attacking:
			$Animation.play("Idle")

	else:
		#No movement input
		velocity.x = move_toward(velocity.x, 0.0, deceleration)
		velocity.y = move_toward(velocity.y, 0.0, deceleration)

	#Request movement from Godot based on velocity
	move_and_slide()
	#set_animation(direction)

func Attack() -> void:
	attacking = true
	play_sword_sound()
	if $CombatArea.has_overlapping_areas():
		for area in $CombatArea.get_overlapping_areas():
			if area.name == "Hurtbox" && area.get_parent().is_in_group("Enemy"):
				print("Hit: ", area.get_parent().name)
				area.get_parent().enemy_take_damage(randi_range(1,3))

func play_sword_sound():
	sword_hits.stream = sword_sounds[randi() % sword_sounds.size()]
	sword_hits.play()
	
func set_sisu(sisu_amt: int):
	sisu = sisu_amt
	sisu_label.text = "SISU: " + str(sisu)
	
func set_vaki(vaki_change: int):
	vaki = vaki + vaki_change
	vaki_label.text = "VÄKI: " + str(vaki)
	
func player_take_damage(dmg_amount: int):
	if dmg_amount > 0:
		player_gets_hit.play()
	sisu -= dmg_amount
	set_sisu(sisu)
	if sisu <= 0: #Dead
		player_falls.play()
		await get_tree().create_timer(0.5).timeout
		get_tree().call_deferred("change_scene_to_file", "start_menu.tscn") #Back to start screen
		
