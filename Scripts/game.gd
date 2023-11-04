extends Node2D

@export var hellcat_scene: PackedScene
@onready var player = $Player


func _on_hellcat_timer_timeout():
	var mob = hellcat_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("HellcatPath/SpawnLocation")
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position
	var direction = (player.global_position - mob.position).normalized()
	

	# Choose the velocity for the mob.
	var speed = randf_range(1000,1200)
	mob.linear_velocity = speed * direction

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
	
	
	
	
