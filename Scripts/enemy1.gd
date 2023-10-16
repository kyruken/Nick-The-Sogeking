extends CharacterBody2D

var speed = 250
var player_chase = false
var player = null

func _physics_process(delta):
	if player_chase:
		velocity = position.direction_to(player.global_position) * speed
		move_and_slide()

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true
	print("entered")


func _on_detection_area_body_exited(body):
	player = null
	player_chase = false
	print("exited")
