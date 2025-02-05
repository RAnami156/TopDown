extends CharacterBody2D


@onready var anim = $AnimatedSprite2D
var speed = 300
var current_dir = "none"
var enemy_in_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true
var attack_ip = false


func _ready() -> void:
	anim.play("Front_idle")

enum {
	IDLE,
	MOVING	
}

#main
func _physics_process(delta):
	#z_index = int(position.y)
	player_movement(delta)
	enemy_attack()
	attack()
	
	if health <= 0:
		player_alive = false
		health = 0
		self.queue_free()
	
func player_movement(delta):
	#run
	if Input.is_action_pressed("run"):
		speed = 600
	else :
		speed = 300
		
	
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
	#idle
	else:
		play_anim(IDLE)
		velocity.x = 0
		velocity.y = 0 
	
	move_and_slide()
	
	
func play_anim(movement):
	var dir = current_dir
	
	if dir == "right":
		anim.flip_h = false 
		if movement == MOVING :
			anim.play("Side_walk")
		elif movement == IDLE:
			if attack_ip == false:
				anim.play("Front_idle")
			
	if dir == "left":
		anim.flip_h = true 
		if movement == MOVING :
			anim.play("Side_walk")
		elif movement == IDLE:
			if attack_ip == false:
				anim.play("Front_idle")
	
	if dir == "down":
		anim.flip_h = true 
		if movement == MOVING :
			anim.play("Front_walk")
		elif movement == IDLE:
			if attack_ip == false:
				anim.play("Idle")
			
	if dir == "up":
		anim.flip_h = true 
		if movement == MOVING :
			anim.play("Back_walk")
		elif movement == IDLE:
			if attack_ip == false:
				anim.play("Back_idle")
	


func player():
	pass

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_range = true


func _on_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_range = false
		
func enemy_attack():
	if enemy_in_range and enemy_attack_cooldown == true :
		health -= 20
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print(health)

func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true


func attack():
	var dir = current_dir
	
	if Input.is_action_just_pressed("attack"):
		Global.player_current_attack = true
		attack_ip = true
		if dir == "right":
			anim.flip_h = false
			anim.play("Side_attack")
			$deal_attack.start()
		if dir == "left":
			anim.flip_h = true
			anim.play("Side_attack")
			$deal_attack.start()
		if dir == "down":
			anim.play("Back_attack")
			$deal_attack.start()
		if dir == "up":
			anim.play("Front_attack")
			$deal_attack.start()

func _on_deal_attack_timeout() -> void:
	$deal_attack.stop()
	Global.player_current_attack = false
	attack_ip = false
