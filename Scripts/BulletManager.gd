extends Node2D

var bullet_collider

	
func _on_player_player_fired_bullet(bullet, position, direction):
	add_child(bullet)
	set_bullet_collision(bullet, 3, false)
	set_bullet_collision(bullet, 9, true)
	bullet.global_position = position
	bullet.set_direction(direction)


func _on_enemy_fired_bullet(bullet, position, direction):
	add_child(bullet)
	set_bullet_collision(bullet, 9, false)
	set_bullet_collision(bullet, 3, true)
	bullet.global_position = position
	bullet.set_direction(direction)

func set_bullet_collision(bullet, layer_num, desired_bool):
	bullet_collider = bullet.get_node("Area2D")
	bullet_collider.set_collision_layer_value(layer_num, desired_bool)
	bullet_collider.set_collision_mask_value(layer_num, desired_bool)
