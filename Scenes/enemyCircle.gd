extends CharacterBody2D


var speed = 300.0
@onready var attack_timer = $AttackTimer
enum {
	NEUTRAL,
	SURROUND,
	ATTACK
}

var state = NEUTRAL
var player = null
var target
var randomnum

func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	randomnum = rng.randf()

func _physics_process(delta):
	match state:
		# gets circle position around player
		SURROUND:
			print("surround")
			move(get_circle_position(randomnum), delta)
		# engage player with attack
		ATTACK:
			print("attack")
			move(player.global_position, delta)
			
func move(target, delta):
	var direction = (target - global_position).normalized() 
	var desired_velocity =  direction * speed
	var steering = (desired_velocity - velocity) * delta * 2.5
	velocity += steering
	move_and_slide()
	
func get_circle_position(random):
	var kill_circle_centre = player.global_position
	var radius = 300
	var angle = random * PI * 2;
	var x = kill_circle_centre.x + cos(angle) * radius;
	var y = kill_circle_centre.y + sin(angle) * radius;

	return Vector2(x, y)
	
func _on_detection_area_body_entered(body):
	player = body
	state = SURROUND
	attack_timer.start()
	print("entered")

func _on_detection_area_body_exited(body):
	state = null
	attack_timer.stop()
	print("exited")

	


func _on_attack_timer_timeout():
	state = ATTACK


	


