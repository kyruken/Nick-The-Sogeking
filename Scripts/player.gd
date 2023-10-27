extends CharacterBody2D

signal player_fired_bullet(bullet, position, direction)
@export var Bullet: PackedScene
var health : int
var max_health: int = 3
var attention: float
var max_attention: float = 100
@export var attention_deplete: float = 0.25
var is_attentive: bool

@onready var end_of_gun = $Firepoint
@onready var health_bar = $HealthBar
@onready var attention_bar = $AttentionBar

var can_shoot = true

func _ready():
	
	is_attentive = true
	health = max_health
	attention = max_attention
	update_attribute(health_bar, max_health)
	update_attribute(attention_bar, max_attention)	
	
func _physics_process(delta):
	if is_attentive == true:
		move_and_slide()
		
	if attention <= 0:
		attention_deficit()
	update_attribute(health_bar, health)
	decrement_attention(attention_deplete)
	update_attribute(attention_bar, attention)
	
func _unhandled_input(event: InputEvent):
	if is_attentive:
		if event.is_action_released("shoot") and can_shoot:
			shoot()
	
	if event.is_action_pressed("check_phone"):
		check_phone()
		
func check_phone():
	$Sprite2D/AnimationPlayer.play("phone_animation") 
	is_attentive = false
	var cooldown = await get_tree().create_timer(0.5).timeout
	$AudioStreamPlayer.play()
	var play_sound = await get_tree().create_timer(1).timeout
	attention = max_attention
	is_attentive = true
	
func shoot():
	
	$Sprite2D/AnimationPlayer.play("attack_animation") 
	var bullet_instance = Bullet.instantiate()
	bullet_instance.global_position = end_of_gun.global_position
	var target = get_global_mouse_position()

	#We find the direction towards the mouse through vector functions
	var direction_to_mouse = end_of_gun.global_position.direction_to(target).normalized()
	bullet_instance.set_direction(direction_to_mouse)
	emit_signal("player_fired_bullet", bullet_instance, end_of_gun.global_position, direction_to_mouse)
	can_shoot = false


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

func _on_timer_timeout():
	can_shoot = true
