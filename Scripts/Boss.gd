extends CharacterBody2D

var speed = 400

signal enemy_fired_bullet(bullet, position, direction)

@export var Bullet: PackedScene
@onready var end_of_gun = $Firepoint
@onready var shoot_timer = $Firepoint/ShootTimer

@onready var nav_agent = $NavigationAgent2D
@export var player := CharacterBody2D

@onready var navTimer = $NavTimer
@onready var attackTimer = $AttackTimer

@export var health : int = 2

@onready var current_sprite = $Sprite2D
var can_shoot = false

var state = CHASE
var randomnum
var rng = RandomNumberGenerator.new()

var is_phase_1 = true
var is_phase_2 = false

var is_charging = false

enum {
	CHASE,
	ATTACK
}

func _ready():
	current_sprite = $Sprite2D
	var player_node = get_tree().get_first_node_in_group("player")
	player = player_node
	rng.randomize()
	randomnum = rng.randf()
	
	$%Sprite2D2.visibility_layer = false
	var bullet_manager = get_tree().get_first_node_in_group("bullet_manager")
	self.connect("enemy_fired_bullet", bullet_manager._on_enemy_fired_bullet, 1)

func _physics_process(delta):
	flip_sprite()
	if is_phase_1:
		move(delta)
		if (can_shoot):
			shoot(0.8)
		if (health <= 1):
			transfer_phase_2()
	else:
		if (!is_phase_2):
			var cooldown = await get_tree().create_timer(3.5).timeout
			$Sprite2D.visibility_layer = false
			$Sprite2D2.visibility_layer = true
			current_sprite = $Sprite2D2
			$Firepoint/ShootTimer.wait_time = 1.0

			is_phase_2 = true
		else:
			move(delta)
			if (can_shoot):
				shoot(0.4)

func move(delta):
	if is_phase_1:
		current_sprite.get_node("AnimationPlayer").play("boss_phase1_walk")
	else:
		current_sprite.get_node("AnimationPlayer").play("boss_phase2_walk")
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
func shoot(shoot_time):
	if is_phase_1:
		current_sprite.get_node("AnimationPlayer").play("boss_phase1_attack")
	else:
		current_sprite.get_node("AnimationPlayer").play("boss_phase2_attack")
	var cooldown = await get_tree().create_timer(shoot_time).timeout
	var bullet_instance = Bullet.instantiate()
	bullet_instance.global_position = end_of_gun.global_position
	var target = position.direction_to(player.global_position)

	var direction_to_mouse = end_of_gun.global_position.direction_to(target).normalized()
	bullet_instance.set_direction(direction_to_mouse)
	emit_signal("enemy_fired_bullet", bullet_instance, end_of_gun.global_position, target)
	can_shoot = false
	
#func charge():
#	is_charging = true
#	current_sprite.get_node("AnimationPlayer").play("boss_phase2_charge")
#	var direction = (player.global_position - self.position).normalized()
#	var speed = randf_range(1000,1200)
#	self.velocity = speed * direction
	
func handle_hit():
	health = health - 1
	if health <= 0:
		die()

func die():
	#get_parent gets top most node, then queue_free removes node from tree
	queue_free()

func flip_sprite():
	if (self.velocity.x < 0):
		current_sprite.flip_h = 0
	elif (self.velocity.x > 0):
		current_sprite.flip_h = 1
### Enemy private functions ###

func _on_shoot_timer_timeout():
	can_shoot = true
	
func transfer_phase_2():
	is_phase_1 = false
	$Sprite2D/AnimationPlayer.play("boss_phase1_transitiontophase2")
	speed = 600

