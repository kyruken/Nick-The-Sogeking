extends CharacterBody2D

const speed = 250

@onready var nav_agent = $NavigationAgent2D
@export var player := Node2D
var player_chase = false
@onready var timer = $Timer

func _physics_process(_delta):
	if player_chase:
		var dir = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = dir * speed
		move_and_slide()

func makepath():
	nav_agent.target_position = player.global_position

func _on_detection_area_body_entered(body):
	timer.start()
	player_chase = true
	print("entered")



func _on_timer_timeout():
	makepath()
