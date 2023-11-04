extends State
class_name PlayerDash

@export var animator : AnimationPlayer
@export var character_body : CharacterBody2D
const normalspeed = 300
const dashspeed = 700
const dashlength = .8

var roll_vector
@onready var timer = $DashTimer

func Enter():
	animator.play("dodge_animation") 
	start_dash(dashlength)
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	roll_vector = input_direction
	
func Physics_Update(delta: float):
	if is_dashing():
		owner.velocity =  roll_vector * dashspeed
		character_body.set_collision_layer_value(3, false)
		character_body.set_collision_mask_value(3, false)
	else:
		character_body.set_collision_layer_value(3, true)
		character_body.set_collision_mask_value(3, true)
		Transitioned.emit(self, "walk")
		
func start_dash(dur):
	timer.wait_time = dur
	timer.start()

func is_dashing():
	return !timer.is_stopped()

		

