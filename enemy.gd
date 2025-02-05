extends CharacterBody2D

@onready var anim = $AnimatedSprite2D

var speed = 100
var player_chase = false
var player = null

func _physics_process(delta: float) -> void:
	if player_chase:
		position += (player.position - position)/speed
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
