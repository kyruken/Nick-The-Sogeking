# PlayerWalk.gd
extends State

func Enter():
	$Sprite2D/AnimationPlayer.play("idle_animation") 
	
func Update(delta: float):
	pass
