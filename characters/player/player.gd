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

# Health and HealthBar
var health: int
@export var max_health: int = 100
@export var health_bar: ProgressBar

func _ready():
	motion_mode = MOTION_MODE_FLOATING
	$AnimatedSprite2D.play("idle_down")
	
	# Set up the players resources
	health = max_health
	
	# Set up the health bar
	health_bar.init(self)

func _physics_process(_delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if direction.x > 0:
		current_state = State.RUNNING
		_last_direction = _Direction.RIGHT
		$AnimatedSprite2D.play("run_side")
		$AnimatedSprite2D.flip_h = false  # Ensure the sprite is not flipped
	elif direction.x < 0:
		current_state = State.RUNNING
		_last_direction = _Direction.LEFT
		$AnimatedSprite2D.play("run_side")
		$AnimatedSprite2D.flip_h = true  # Flip the sprite for left movement
	elif direction.y > 0:
		current_state = State.RUNNING
		_last_direction = _Direction.DOWN
		$AnimatedSprite2D.play("run_down")
	elif direction.y < 0:
		current_state = State.RUNNING
		_last_direction = _Direction.UP
		$AnimatedSprite2D.play("run_up")
		
	else:
		current_state = State.STANDING
		if _last_direction == _Direction.DOWN:
			$AnimatedSprite2D.play("idle_down")  # Change to your idle animation
		elif _last_direction == _Direction.UP:
			$AnimatedSprite2D.play("idle_up")
		elif _last_direction == _Direction.RIGHT:
			$AnimatedSprite2D.play("idle_side")
			$AnimatedSprite2D.flip_h = false
		elif _last_direction == _Direction.LEFT:
			$AnimatedSprite2D.play("idle_side")
			$AnimatedSprite2D.flip_h = true

	velocity = direction * SPEED
	move_and_slide()
	push_stuff()
	fire_bullet()

func push_stuff() -> void:
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			var push_force = (PUSH_FORCE * velocity.length() / SPEED) + MIN_PUSH_FORCE
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)

func fire_bullet() -> void:
	if Input.is_action_pressed("fire_up") and can_fire:
		var bullet_instance = bullet.instantiate()
		bullet_instance.position = $Shoot_positions/Bullet_pos_up.global_position
		bullet_instance.rotation_degrees = 0
		bullet_instance.apply_impulse(Vector2(0, -bullet_speed), bullet_instance.global_position)
		get_tree().get_root().add_child(bullet_instance)
		can_fire = false
		await get_tree().create_timer(fire_rate).timeout
		can_fire = true
	if Input.is_action_pressed("fire_down") and can_fire:
		var bullet_instance = bullet.instantiate()
		bullet_instance.position = $Shoot_positions/Bullet_pos_down.global_position
		bullet_instance.rotation_degrees = 0
		bullet_instance.apply_impulse(Vector2(0, bullet_speed), bullet_instance.global_position)
		get_tree().get_root().add_child(bullet_instance)
		can_fire = false
		await get_tree().create_timer(fire_rate).timeout
		can_fire = true
	if Input.is_action_pressed("fire_left") and can_fire:
		var bullet_instance = bullet.instantiate()
		bullet_instance.position = $Shoot_positions/Bullet_pos_left.global_position
		bullet_instance.rotation_degrees = 0
		bullet_instance.apply_impulse(Vector2(-bullet_speed, 0), bullet_instance.global_position)
		get_tree().get_root().add_child(bullet_instance)
		can_fire = false
		await get_tree().create_timer(fire_rate).timeout
		can_fire = true
	if Input.is_action_pressed("fire_right") and can_fire:
		var bullet_instance = bullet.instantiate()
		bullet_instance.position = $Shoot_positions/Bullet_pos_right.global_position
		bullet_instance.rotation_degrees = 0
		bullet_instance.apply_impulse(Vector2(bullet_speed, 0), bullet_instance.global_position)
		get_tree().get_root().add_child(bullet_instance)
		can_fire = false
		await get_tree().create_timer(fire_rate).timeout
		can_fire = true
