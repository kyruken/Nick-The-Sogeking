extends Node2D

@export var mob_to_spawn : PackedScene
@onready var spawn_timer = $SpawnTimer

var can_spawn = false

func _process(delta):
	if (can_spawn):
		spawn()

func spawn():
	var mob_instance = mob_to_spawn.instantiate()
	add_child(mob_instance)
	can_spawn = false
	
func _on_spawn_timer_timeout():
	can_spawn = true
