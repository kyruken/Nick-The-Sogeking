extends Node2D

signal player_fired_bullet(bullet, position, direction)
@export var Bullet: PackedScene
@export var speed = 300

@onready var end_of_gun = $Firepoint

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * speed * delta

func _unhandled_input(event: InputEvent):
		if event.is_action_released("shoot"):
			shoot()
			
func shoot():
	var bullet_instance = Bullet.instantiate()
	bullet_instance.global_position = end_of_gun.global_position
	var target = get_global_mouse_position()
	
	#We find the direction towards the mouse through vector functions
	var direction_to_mouse = end_of_gun.global_position.direction_to(target).normalized()
	bullet_instance.set_direction(direction_to_mouse)
	emit_signal("player_fired_bullet", bullet_instance, end_of_gun.global_position, direction_to_mouse)
