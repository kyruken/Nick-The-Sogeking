extends CharacterBody2D

const speed = 250

signal enemy_fired_bullet(bullet, position, direction)

@export var Bullet: PackedScene
@onready var end_of_gun = $Firepoint
@onready var shoot_timer = $Firepoint/ShootTimer

@onready var nav_agent = $NavigationAgent2D
@export var player := CharacterBody2D

@onready var navTimer = $NavTimer
@onready var attackTimer = $AttackTimer

var health : int = 3
var can_shoot = false

var state = CHASE
var randomnum
var rng = RandomNumberGenerator.new()

enum {
	CHASE,
	ATTACK
}

func _ready():
	var player_node = get_tree().get_first_node_in_group("player")
	player = player_node
	rng.randomize()
	randomnum = rng.randf()
	
	var bullet_manager = get_tree().get_first_node_in_group("bullet_manager")
	self.connect("enemy_fired_bullet", bullet_manager._on_enemy_fired_bullet, 1)

func _physics_process(delta):
	move(delta)
	
	flip_sprite()
	if (can_shoot):
		shoot()
			

func move(delta):
	$Sprite2D/AnimationPlayer.play("kevin_walk_1")
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	var desired_velocity = dir * speed
	var steering = (desired_velocity - velocity) * delta * 2.5
	velocity += steering
	move_and_slide()

func makepath():
	match state:
		CHASE:
			nav_agent.target_position = get_circle_position(randomnum)
		ATTACK:
			nav_agent.target_position = player.global_position
	
func get_circle_position(random):
	var kill_circle_centre = player.global_position
	var radius = rng.randf_range(100, 200)
	var angle = random * PI * 2;
	var x = kill_circle_centre.x + cos(angle) * radius;
	var y = kill_circle_centre.y + sin(angle) * radius;

	return Vector2(x, y)

func _on_detection_area_body_entered(body):
	shoot_timer.start()
	shoot_timer.set_paused(false)
	navTimer.start()
	attackTimer.start()
	state = ATTACK
	
func _on_detection_area_body_exited(body):
	shoot_timer.set_paused(true)
	can_shoot = false
	
func _on_timer_timeout():
	makepath()


func _on_attack_timer_timeout():
	state = CHASE

### Enemy private functions ###
func shoot():
	var bullet_instance = Bullet.instantiate()
	bullet_instance.global_position = end_of_gun.global_position
	var target = position.direction_to(player.global_position)

	var direction_to_mouse = end_of_gun.global_position.direction_to(target).normalized()
	bullet_instance.set_direction(direction_to_mouse)
	emit_signal("enemy_fired_bullet", bullet_instance, end_of_gun.global_position, target)
	can_shoot = false

func handle_hit():
	health = health - 1
	if health <= 0:
		die()

func die():
	#get_parent gets top most node, then queue_free removes node from tree
	queue_free()

func flip_sprite():
	if (self.velocity.x < 0):
		$Sprite2D.flip_h = 0
	elif (self.velocity.x > 0):
		$Sprite2D.flip_h = 1
### Enemy private functions ###



func _on_shoot_timer_timeout():
	can_shoot = true
