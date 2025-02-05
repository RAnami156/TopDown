extends CharacterBody2D

@onready var anim = $AnimatedSprite2D

var speed = 100
var player_chase = false
var player = null
var health = 100
var player_attack_zone = false
var take_damage = true

func _physics_process(delta: float) -> void:
	deal_with_damage()
	if player_chase:
		position += (player.position - position)
		anim.play("Walk")
		
		if (player.position.x - position.x) < 0:
			anim.flip_h = true
		else:
			anim.flip_h = false
			
	else:
		anim.play("Idle")


func _on_detector_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true


func _on_detector_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false

func enemy():
	pass
	


func _on_hitbox_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.has_method("player"):
		player_attack_zone = true


func _on_hitbox_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.has_method("player"):
		player_attack_zone = false
		
func deal_with_damage():
	if player_attack_zone and Global.player_current_attack == true:
		if take_damage == true:
			health -= 20
			$damage_cooldown.start()
			take_damage = false
			print("slime", health)
			if health <= 0:
				self.queue_free()


func _on_damage_cooldown_timeout() -> void:
	take_damage = true
