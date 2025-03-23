extends CharacterBody2D

signal died()
signal update_ability_meter(value)

# Define states using an enumeration
enum State { IDLE, RUNNING }
enum _Direction {UP, DOWN, LEFT, RIGHT}

# Player constants
const PUSH_FORCE := 10
const MIN_PUSH_FORCE := 10
const SPEED = 150
@export var kills_for_ability_use = 10
@export var bullet_speed = 100
@export var fire_rate = 0.2
var can_fire = true

var in_explosion_range = []

var bullet = preload("res://characters/player/patrone.tscn")

# Current state of the player
var current_state = State.IDLE
var _last_direction = _Direction.DOWN

var kills_before_ability_reset = 0
var ability_meter = 0

@onready var movement_animation = $MovementAnimation
@onready var gun_animation = $GunAnimation
@onready var explosion_animation = $ExplosionAnimation
@onready var timer = $Timer

@onready var shoot_pos_up = $Shoot_positions/Bullet_pos_up
@onready var shoot_pos_down = $Shoot_positions/Bullet_pos_down
@onready var shoot_pos_right = $Shoot_positions/Bullet_pos_right
@onready var shoot_pos_left = $Shoot_positions/Bullet_pos_left

@onready var raycast_ignore = [self, $HurtBox, $ExplosionArea]


func _ready():
	motion_mode = MOTION_MODE_FLOATING
	$MovementAnimation.play("idle down")
	$Timer.timeout.connect(_on_fire_timer_timeout)
	$HurtBox.damaged.connect(_on_damage_taken)
	$ExplosionArea.area_entered.connect(_on_explosion_area_entered)
	$ExplosionArea.area_exited.connect(_on_explosion_area_exited)


func _physics_process(_delta):
	var new_ability_meter = StatsHolder.kill_counter-kills_before_ability_reset
	if ability_meter != new_ability_meter:
		ability_meter = new_ability_meter
		update_ability_meter.emit(ability_meter)
		
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	velocity = direction * SPEED
	move_and_slide()
	
	if Input.is_action_pressed("fire_up"):
		animate_shooting(_Direction.UP)
		if can_fire:
			fire_bullet(_Direction.UP)
	
	elif Input.is_action_pressed("fire_down"):
		animate_shooting(_Direction.DOWN)
		if can_fire:
			fire_bullet(_Direction.DOWN)
	
	elif Input.is_action_pressed("fire_left"):
		animate_shooting(_Direction.LEFT)
		if can_fire:
			fire_bullet(_Direction.LEFT)
	
	elif Input.is_action_pressed("fire_right"):
		animate_shooting(_Direction.RIGHT)
		if can_fire:
			fire_bullet(_Direction.RIGHT)
	else:
		animate_shooting()
		
	# direction can be influenced by shooting direction on idle
	set_animation(direction)
	
	
	if Input.is_action_just_pressed("ability") and ability_meter>=kills_for_ability_use:
		explosion_animation.play("explosion")


func set_animation(direction):	
	if direction.x > 0:
		current_state = State.RUNNING
		_last_direction = _Direction.RIGHT
		movement_animation.play("run right")
	elif direction.x < 0:
		current_state = State.RUNNING
		_last_direction = _Direction.LEFT
		movement_animation.play("run left")
	elif direction.y > 0:
		current_state = State.RUNNING
		_last_direction = _Direction.DOWN
		movement_animation.play("run down")
	elif direction.y < 0:
		current_state = State.RUNNING
		_last_direction = _Direction.UP
		movement_animation.play("run up")
		
	else:
		current_state = State.IDLE
		if _last_direction == _Direction.DOWN:
			movement_animation.play("idle down")
		elif _last_direction == _Direction.UP:
			movement_animation.play("idle up")
		elif _last_direction == _Direction.LEFT:
			movement_animation.play("idle left")
		elif _last_direction == _Direction.RIGHT:
			movement_animation.play("idle right")


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
		get_tree().get_current_scene().add_child(bullet_instance)
		
		can_fire = false
		timer.start(fire_rate)


func animate_shooting(direction=null):
	if direction == null:
		gun_animation.play("RESET")
		return
	
	if current_state == State.IDLE:
		_last_direction = direction
	
	match direction:
		_Direction.UP:
			match _last_direction:
				_Direction.UP, _Direction.RIGHT:
					gun_animation.play("shoot up")
				_Direction.DOWN, _Direction.LEFT:
					gun_animation.play("shoot up alt")
		
		_Direction.DOWN:
			match _last_direction:
				_Direction.UP, _Direction.RIGHT:
					gun_animation.play("shoot down alt")
				_Direction.DOWN, _Direction.LEFT:
					gun_animation.play("shoot down")
		
		_Direction.RIGHT:
			match _last_direction:
				_Direction.DOWN, _Direction.RIGHT:
					gun_animation.play("shoot right")
				_Direction.UP, _Direction.LEFT:
					gun_animation.play("shoot right alt")
		
		_Direction.LEFT:
			match _last_direction:
				_Direction.DOWN, _Direction.RIGHT:
					gun_animation.play("shoot left alt")
				_Direction.UP, _Direction.LEFT:
					gun_animation.play("shoot left")


func damage_by_distance(hurtbox):
	var relative_distance = hurtbox.global_position.distance_to(global_position)/42
	var damage = max(0,(1-relative_distance)*100)
	hurtbox.take_damage(damage)


func _on_fire_timer_timeout():
	can_fire = true


func _on_damage_taken(_damage, health):
	if health <= 0:
		died.emit()


func _on_explosion_area_entered(area: Area2D):
	if not area is HurtBox:
		return
	if area.get_parent() == self:
		return
	in_explosion_range.append(area)


func _on_explosion_area_exited(area: Area2D):
	in_explosion_range.erase(area)


func _explosion_kill():
	var space_state = get_world_2d().direct_space_state
	for box in in_explosion_range:
		var query = PhysicsRayQueryParameters2D.create(global_position, box.global_position, 80, raycast_ignore)
		query.collide_with_areas = true
		query.hit_from_inside = true
		var result = space_state.intersect_ray(query)
		if not result or not result.collider == box:
			damage_by_distance(box)
			continue
		box.get_parent().queue_free()
		var kills = StatsHolder.kill_counter + 1
		var stats_holder: StatsHolderClass = $"/root/StatsHolder"
		stats_holder.update_stat(stats_holder.Stats.KILLCOUNTER, kills)


func _reset_ability_meter():
	kills_before_ability_reset = StatsHolder.kill_counter
	ability_meter = 0
	update_ability_meter.emit(0)
