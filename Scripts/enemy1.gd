extends CharacterBody2D

const speed = 250

@onready var nav_agent = $NavigationAgent2D
@export var player := Node2D

@onready var navTimer = $NavTimer
@onready var attackTimer = $AttackTimer

var state = CHASE
var randomnum
var rng = RandomNumberGenerator.new()

enum {
	CHASE,
	ATTACK
}

func _ready():
	rng.randomize()
	randomnum = rng.randf()

func _physics_process(delta):
	move(delta)
			

func move(delta):
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
	navTimer.start()
	attackTimer.start()
	state = ATTACK
	print("entered")

func _on_timer_timeout():
	makepath()


func _on_attack_timer_timeout():
	print("attacking")
	state = CHASE
