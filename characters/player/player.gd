extends CharacterBody2D

# Define states using an enumeration
enum State { STANDING, RUNNING }
enum _Direction {UP, DOWN, LEFT, RIGHT}

# Player constants
const PUSH_FORCE := 10
const MIN_PUSH_FORCE := 10
const SPEED = 150
@export var bullet_speed = 100
@export var fire_rate = 0.2
var can_fire = true


var bullet = preload("res://characters/player/patrone.tscn")

# Current state of the player
var current_state = State.STANDING
var _last_direction = _Direction.DOWN


@onready var animation_player = $AnimationPlayer
@onready var timer = $Timer

@onready var shoot_pos_up = $Shoot_positions/Bullet_pos_up
@onready var shoot_pos_down = $Shoot_positions/Bullet_pos_down
@onready var shoot_pos_right = $Shoot_positions/Bullet_pos_right
@onready var shoot_pos_left = $Shoot_positions/Bullet_pos_left

func _ready():
	motion_mode = MOTION_MODE_FLOATING
	$AnimationPlayer.play("idle down")
	$Timer.timeout.connect(_on_fire_timer_timeout)
	


func _physics_process(_delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	set_animation(direction)

	velocity = direction * SPEED
	move_and_slide()
	push_stuff()
	
	if Input.is_action_pressed("fire_up") and can_fire:
		fire_bullet(_Direction.UP)
	if Input.is_action_pressed("fire_down") and can_fire:
		fire_bullet(_Direction.DOWN)
	if Input.is_action_pressed("fire_left") and can_fire:
		fire_bullet(_Direction.LEFT)
	if Input.is_action_pressed("fire_right") and can_fire:
		fire_bullet(_Direction.RIGHT)


func set_animation(direction):	
	if direction.x > 0:
		current_state = State.RUNNING
		_last_direction = _Direction.RIGHT
		animation_player.play("run right")
	elif direction.x < 0:
		current_state = State.RUNNING
		_last_direction = _Direction.LEFT
		animation_player.play("run left")
	elif direction.y > 0:
		current_state = State.RUNNING
		_last_direction = _Direction.DOWN
		animation_player.play("run down")
	elif direction.y < 0:
		current_state = State.RUNNING
		_last_direction = _Direction.UP
		animation_player.play("run up")
		
	else:
		current_state = State.STANDING
		if _last_direction == _Direction.DOWN:
			animation_player.play("idle down")
		elif _last_direction == _Direction.UP:
			animation_player.play("idle up")
		elif _last_direction == _Direction.LEFT:
			animation_player.play("idle left")
		elif _last_direction == _Direction.RIGHT:
			animation_player.play("idle right")


func push_stuff() -> void:
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			var push_force = (PUSH_FORCE * velocity.length() / SPEED) + MIN_PUSH_FORCE
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)


func fire_bullet(direction):
		var bullet_instance = bullet.instantiate()
		bullet_instance.rotation_degrees = 0
		
		var direction_vector = Vector2.ZERO
		var shoot_pos
		
		match direction:
			_Direction.UP:
				direction_vector = Vector2.UP
				shoot_pos = shoot_pos_up
			_Direction.DOWN:
				direction_vector = Vector2.DOWN
				shoot_pos = shoot_pos_down
			_Direction.LEFT:
				direction_vector = Vector2.LEFT
				shoot_pos = shoot_pos_left
			_Direction.RIGHT:
				direction_vector = Vector2.RIGHT
				shoot_pos = shoot_pos_right
		
		bullet_instance.position = shoot_pos.global_position
		bullet_instance.apply_impulse(direction_vector*bullet_speed, bullet_instance.global_position)
		get_tree().get_root().add_child(bullet_instance)
		
		can_fire = false
		timer.start(fire_rate)
		
	


func _on_fire_timer_timeout():
	can_fire = true
