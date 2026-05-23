extends CharacterBody2D

@export var speed = 100.0
@export var acceleration = 15.0 #For horizontal movement
@export var deceleration = 150.0 #For horizontal movement
@export var sisu = 3
@export var vaki = 5

@onready var vaki_label = %LabelVaki
@onready var sisu_label = %LabelSisu

var attacking = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	#$Animation.play("Idle")
	Globals.player = self 
	print("Globals.player at start: " + str(Globals.player))
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Attack"):
		Attack()
		
	#Horizontal movement
	var directionLR = Input.get_axis("Left", "Right")
	var directionUD = Input.get_axis("Up", "Down")
	
	if directionLR != null || directionUD != null:
		#Player gave movement horizontal
		velocity.x = move_toward(velocity.x, directionLR * speed, acceleration) #Function for applying movement
		#Player gave movement vertical
		velocity.y = move_toward(velocity.y, directionUD * speed, acceleration)
		
	else:
		#No movement input
		velocity.x = move_toward(velocity.x, 0.0, deceleration)
		velocity.y = move_toward(velocity.y, 0.0, deceleration)

	#Request movement from Godot based on velocity
	move_and_slide()
	#set_animation(direction)

func Attack() -> void:
	attacking = true
	print("Attack")
	$Weapon.visible = true
	#$Animation.Play("Attack")
	await get_tree().create_timer(0.2).timeout
	$Weapon.visible = false
	if $CombatArea.has_overlapping_areas():
		for area in $CombatArea.get_overlapping_areas():
			if area.get_parent().is_in_group("Enemy"):
				area.get_parent().take_damage(randi_range(1,5))

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
	
func set_sisu(sisu_amt: int):
	sisu = sisu_amt
	sisu_label.text = "SISU: " + str(sisu)
	
func set_vaki(vaki_amt: int):
	vaki = vaki + vaki_amt
	vaki_label.text = "VÄKI: " + str(vaki)
	
func take_damage(dmg_amount: int):
	sisu -= dmg_amount
	set_sisu(sisu)
	if sisu <= 0: #Dead
		#get_tree().call_deferred("change_scene_to_file", "ui.tscn") #Back to start screen
		pass

func _on_combat_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Item"):
		#Item pop-up
		#Sisu/Väki
		pass
