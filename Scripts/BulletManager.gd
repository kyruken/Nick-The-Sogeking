extends Node2D

func _on_player_player_fired_bullet(bullet, position, direction):
	add_child(bullet)
	bullet.global_position = position
	bullet.set_direction(direction)
