extends Node2D

var move_speed : float = 10
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_body_entered(body):
	print('hit player')
	if body.has_method("handle_hit"):
		body.handle_hit()
