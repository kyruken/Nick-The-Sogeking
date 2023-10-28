extends State
class_name PlayerIdle

@export var animator : AnimationPlayer

const normalspeed = 300
const dashspeed = 1200
const dashlength = .1

func Enter():
	animator.play("idle_animation") 
	owner.velocity = Vector2.ZERO
	
func Update(delta: float):
	if (Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right")
	or Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down")):
		Transitioned.emit(self, "walk")

func on_dash():
	if (Input.is_action_just_pressed("dash")):
	dash.start_dash(dashlength)
