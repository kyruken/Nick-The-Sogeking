extends CharacterBody2D
#Health logic handled here

var health : int = 3

func handle_hit():
	health = health - 1
	if health <= 0:
		die()
	
func die():
	#get_parent gets top most node, then queue_free removes node from tree
	get_parent().queue_free()
