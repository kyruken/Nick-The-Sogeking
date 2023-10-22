extends CharacterBody2D

signal player_fired_bullet(bullet, position, direction)
@export var Bullet: PackedScene
@export var speed = 300
var health : int
var max_health: int = 3
var attention: float
var max_attention: float = 100
@export var attention_deplete: float = 0.1
var is_attentive: bool

@onready var end_of_gun = $Firepoint
@onready var health_bar = $HealthBar
@onready var attention_bar = $AttentionBar

func _ready():
	is_attentive = true
	health = max_health
	attention = max_attention
	update_attribute(health_bar, max_health)
	update_attribute(attention_bar, max_attention)

func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * speed
	
func _physics_process(delta):
	if is_attentive == true:
		get_input()
		move_and_slide()
		
	if attention <= 0:
		attention_deficit()
	update_attribute(health_bar, health)
	decrement_attention(attention_deplete)
	update_attribute(attention_bar, attention)

func _unhandled_input(event: InputEvent):
	if is_attentive:
		if event.is_action_released("shoot"):
			shoot()
	
	if event.is_action_pressed("check_phone"):
		check_phone()
		
func check_phone():
	is_attentive = false
	var cooldown = await get_tree().create_timer(2.0).timeout
	attention = max_attention
	is_attentive = true
	
func shoot():
	var bullet_instance = Bullet.instantiate()
	bullet_instance.global_position = end_of_gun.global_position
	var target = get_global_mouse_position()
	
	#We find the direction towards the mouse through vector functions
	var direction_to_mouse = end_of_gun.global_position.direction_to(target).normalized()
	bullet_instance.set_direction(direction_to_mouse)
	emit_signal("player_fired_bullet", bullet_instance, end_of_gun.global_position, direction_to_mouse)


func update_attribute(attribute_bar, amount):
	attribute_bar.value = amount
	
func decrement_attention(amount):
	attention -= amount

func attention_deficit():
	is_attentive = false
	
func handle_hit():
	health = health - 1
	if health <= 0:
		die()
	
func die():
	#get_parent gets top most node, then queue_free removes node from tree
	get_parent().queue_free()
	
	
