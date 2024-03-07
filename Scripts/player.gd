extends CharacterBody2D

# movement variables
@export var acceleration = 512
@export var max_velocity = 64
@export var friction = 256
@export var gravity = 200
@export var jump_force = 128
@export var max_fall_velocity = 80

# animation variables
@export var blink_freq = 2

@onready var anim_player = $AnimationPlayer

func _ready():
	randomize()
	anim_player.play("Idle")

func _physics_process(delta):
	idle_blink_check()
	
	apply_gravity(delta)
	
	var input_axis = Input.get_axis("ui_left", "ui_right")
	apply_acceleration(delta, input_axis)
	
	jump_check()
	
	move_and_slide()

func is_moving(input_axis) ->bool:
	return input_axis != 0

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y = move_toward(velocity.y, max_fall_velocity, gravity * delta)

func apply_acceleration(delta, input_axis):
	if is_moving(input_axis):
		velocity.x = move_toward(velocity.x, input_axis * max_velocity, acceleration * delta)
	else:
		apply_friction(delta)

func apply_friction(delta):
	velocity.x = move_toward(velocity.x, 0, friction * delta)

func jump_check():
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = -jump_force

func idle_blink_check():
	var random_chance = randi_range(1, 100)
	if random_chance < blink_freq:
		anim_player.play("Idle_Blink")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Idle_Blink":
		anim_player.play("Idle")
