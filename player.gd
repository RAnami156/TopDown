extends CharacterBody2D

const speed = 300
var current_dir = "none"

func _ready() -> void:
	$CollisionShape2D/AnimatedSprite2D.play("Front_idle")

enum {
	IDLE,
	MOVING	
}

func _physics_process(delta):
	player_movement(delta)
	
func player_movement(delta):
	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_anim(MOVING)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		play_anim(MOVING)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		play_anim(MOVING)
		velocity.y = speed
		velocity.x = 0
	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		play_anim(MOVING)
		velocity.y = -speed
		velocity.x = 0
	else:
		play_anim(IDLE)
		velocity.x = 0
		velocity.y = 0 
	
	move_and_slide()
	
	
func play_anim(movement):
	var dir = current_dir
	var anim = $CollisionShape2D/AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false 
		if movement == MOVING :
			anim.play("Side_walk")
		elif movement == IDLE:
			anim.play("Front_idle")
			
	if dir == "left":
		anim.flip_h = true 
		if movement == 1 :
			anim.play("Side_walk")
		elif movement == 0:
			anim.play("Front_idle")
	
	if dir == "down":
		anim.flip_h = true 
		if movement == 1 :
			anim.play("Front_walk")
		elif movement == 0:
			anim.play("Idle")
			
	if dir == "up":
		anim.flip_h = true 
		if movement == 1 :
			anim.play("Back_walk")
		elif movement == 0:
			anim.play("Back_idle")
