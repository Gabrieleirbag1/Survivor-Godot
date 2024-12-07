class_name Player extends CharacterBody2D

@onready var animation : AnimatedSprite2D = $AnimatedSprite2D
@onready var invincibility_timer: Timer = $Invincibility
@onready var hurted_timer: Timer = $Hurted
@onready var level_label: Label = $Level/Control/Level_label

@export var speed: int = 250

@export var experience: int = 0
var level: int = 1

@export var health: int = 50
@export var health_max: int = 50
@export var health_min: int = 0
 
var alive : bool = true
var death_animation_played : bool = false
var immortal: bool = false
var invincible: bool = false

func _ready() -> void:
	EventController.connect("xp_collected", on_event_xp_collected)
	level = MathXp.calculate_level_from_exp(experience)
	level_label.text = str(level)

func on_event_xp_collected(value: int) -> void:
	print(experience, " ", value)
	experience += value
	level = MathXp.calculate_level_from_exp(experience)
	level_label.text = str(level)

func play_animation(animation_name: String) -> void:
	if not alive:
		return
	animation.play(animation_name)

func check_health():
	if immortal:
		return
	if health <= 0 and not death_animation_played:
		play_animation("death")
		alive = false
		death_animation_played = true

func take_damage(enemyVelocity, knockback_force, damage):
	if not invincible:
		health -= damage
		var kb_direction = (enemyVelocity - velocity).normalized() * knockback_force
		velocity = kb_direction
		move_and_slide()

func enemy_attack(velocity, knockback_force, damage):
	if alive and not invincible:
		take_damage(velocity, knockback_force, damage)
		play_animation("hurt")
		check_health()
		invincible = true
		invincibility_timer.start()
		hurted_timer.start()

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _input(event):
	if alive:
		if Input.is_key_pressed(KEY_Z) or Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_UP) or Input.is_key_pressed(KEY_DOWN):
			play_animation("walk_shadow")
		elif Input.is_key_pressed(KEY_RIGHT) or Input.is_key_pressed(KEY_D):
			play_animation("walk_shadow")
			animation.scale.x = abs(animation.scale.x)
		elif Input.is_key_pressed(KEY_Q) or Input.is_key_pressed(KEY_LEFT):
			play_animation("walk_shadow")
			animation.scale.x = -abs(animation.scale.x)
		else:
			play_animation("idle_shadow")

func _physics_process(delta):
	if alive:
		get_input()
		move_and_slide()

func _on_invincibility_timeout() -> void:
	invincible = false

func _on_hurted_timeout() -> void:
	if alive:
		animation.stop()
		play_animation("idle_shadow")
	
