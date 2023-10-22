extends Node2D

signal enemy_fired_bullet(bullet, position, direction)

@export var Bullet: PackedScene

@onready var end_of_gun = $Firepoint
@onready var player = get_tree().get_nodes_in_group("player")

var move_speed : float = 10
var shoot_timer: float = 4
var timer: float = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if timer <= shoot_timer:
		timer += delta
	else:
		timer = 0
		print(player.get_position)
#		shoot()
	
func _on_area_2d_body_entered(body):
	print('hit player')
	if body.has_method("handle_hit"):
		body.handle_hit()

func shoot():
	var bullet_instance = Bullet.instantiate()
	bullet_instance.global_position = end_of_gun.global_position
	var target = player.global_position
	
	var direction_to_player = end_of_gun.global_position.direction_to(target).normalized()
	bullet_instance.set_direction(direction_to_player)
	emit_signal("enemy_fired_bullet", bullet_instance, end_of_gun.global_position, player.global_position)
