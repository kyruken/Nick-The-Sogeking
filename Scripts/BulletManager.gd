extends Node2D

func _on_player_player_fired_bullet(bullet, position, direction):
	add_child(bullet)
	var bullet_collider = bullet.get_node("Area2D")
	bullet_collider.set_collision_layer_value(1, false)
	bullet_collider.set_collision_mask_value(1, false)
#
	bullet_collider.set_collision_layer_value(9, true)
	bullet_collider.set_collision_mask_value(9, true)
	bullet.global_position = position
	bullet.set_direction(direction)


func _on_enemy_enemy_fired_bullet(bullet, position, direction):
	add_child(bullet)
	bullet.global_position = position
	bullet.set_direction(direction)
