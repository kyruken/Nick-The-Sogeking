extends Node2D

@export var speed = 10

var direction := Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# physics_process is called at specific time intervals and does not depend on frame rate
func _physics_process(delta):
	if direction != Vector2.ZERO:
		var velocity = direction * speed
		
		global_position += velocity

func set_direction(direction: Vector2):
	self.direction = direction
