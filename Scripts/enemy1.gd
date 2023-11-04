extends CharacterBody2D

signal enemy_fired_bullet(bullet, position, direction)

@export var Bullet: PackedScene
@onready var end_of_gun = $Firepoint
@onready var shoot_timer = $Firepoint/Timer

var health : int = 3
var speed = 250
var player_chase = false
var player = null
var can_shoot = false
### Ready and Update functions###

func _ready():
	var bullet_manager = get_parent().get_node("BulletManager")
	print(bullet_manager)
	self.connect("enemy_fired_bullet", bullet_manager._on_enemy_enemy_fired_bullet, 1)
	
func _physics_process(delta):
	if player_chase:
		velocity = position.direction_to(player.global_position) * speed
		move_and_slide()
	if (can_shoot):
		shoot()
		
### Ready and Update functions###

### Collision functions ###
func _on_detection_area_body_entered(body):
	shoot_timer.start()
	shoot_timer.set_paused(false)
	player = body
	player_chase = true
	can_shoot = true

func _on_detection_area_body_exited(body):
	shoot_timer.set_paused(true)
	player_chase = false
	can_shoot = false
	
func _on_area_2d_body_entered(body):
	print('hit player')
	if body.has_method("handle_hit"):
		body.handle_hit()

### Collision functions ###

### Enemy private functions ###
func shoot():
	var bullet_instance = Bullet.instantiate()
	bullet_instance.global_position = end_of_gun.global_position
	var target = position.direction_to(player.global_position)

	var direction_to_mouse = end_of_gun.global_position.direction_to(target).normalized()
	bullet_instance.set_direction(direction_to_mouse)
	emit_signal("enemy_fired_bullet", bullet_instance, end_of_gun.global_position, target)
	can_shoot = false

func _on_timer_timeout():
	can_shoot = true
	
func handle_hit():
	health = health - 1
	if health <= 0:
		die()
	
func die():
	#get_parent gets top most node, then queue_free removes node from tree
	queue_free()
### Enemy private functions ###


