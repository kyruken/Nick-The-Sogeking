extends Node2D

@export var mob_to_spawn : PackedScene
@onready var spawn_timer = $SpawnTimer
@onready var tree = get_tree().get_root()

var can_spawn = false

func _process(delta):
	if (can_spawn):
		spawn()

func spawn():
	var mob_instance = mob_to_spawn.instantiate()
	mob_instance.global_position = self.global_position
	tree.add_child(mob_instance)
	can_spawn = false
	
func _on_spawn_timer_timeout():
	can_spawn = true
