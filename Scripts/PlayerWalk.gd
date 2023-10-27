extends State
class_name PlayerWalk

@export var player : CharacterBody2D
@export var speed = 300
@export var sprite : Sprite2D
@export var animator : AnimationPlayer

func Enter():
	animator.play("walk_animation") 
	
func Update(delta: float):
	pass

func Physics_Update(delta: float):
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	owner.velocity = input_direction * speed
	print(owner.velocity)
	flip_sprite()
	
	if (owner.velocity == Vector2.ZERO):
		Transitioned.emit(self, "idle")
		
func flip_sprite():
	if (owner.velocity.x < 0):
		sprite.flip_h = 0
	elif (owner.velocity.x > 0):
		sprite.flip_h = 1
	
	
