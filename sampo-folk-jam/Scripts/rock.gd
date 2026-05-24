extends CharacterBody2D

var direction = Vector2.ZERO
var speed = 100

func _ready():
	#Delay to Hurtbox detection
	$Hurtbox.monitoring = false
	await get_tree().create_timer(2.0).timeout
	$Hurtbox.monitoring = true
	print("Rock ready, hurtbox monitoring: ", $Hurtbox.monitoring)
	$Lifetime.start()
	
func _physics_process(delta: float) -> void:
	velocity = direction * speed
	move_and_slide()
	if $Hurtbox.get_overlapping_areas().size() > 0:
		print("Overlapping: ", $Hurtbox.get_overlapping_areas())
	
func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.get_parent() == Globals.player:
		area.get_parent().player_take_damage(1)
	queue_free()


func _on_lifetime_timeout() -> void:
	queue_free()
