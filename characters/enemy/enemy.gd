extends CharacterBody2D

@export var speed: float = 50

enum {LEFT, RIGHT, UP, DOWN}

var _active = false
var _detected = false
var _last_direction = DOWN

@onready var animation_player = $AnimationPlayer
@onready var player = get_tree().root.find_child("Player", true, false)


func _ready():
	$AnimationPlayer.play("spawn")
	$HurtBox.monitorable = false
	$HurtBox.monitoring = false
	$HitBox.monitorable = false
	$HitBox.monitoring = false
	$AnimationPlayer.animation_finished.connect(_spawned)
	$DetectionArea.area_entered.connect(_area_entered_detection_range)
	$UndetectionArea.area_exited.connect(_area_exited_detection_range)
	$HurtBox.damamged.connect(_on_damaged)


func _physics_process(_delta):
	if not _active:
		return
	if not _detected:
		set_idle_animation()
		return
	var direction = global_position.direction_to(player.global_position)
	set_run_animation(direction)
	velocity = direction * speed
	move_and_slide()


func set_idle_animation():
	match _last_direction:
		DOWN:
			animation_player.play("idle down")
		UP:
			animation_player.play("idle up")
		RIGHT:
			animation_player.play("idle right")
		LEFT:
			animation_player.play("idle left")


func set_run_animation(direction):
	if abs(direction.x) >= abs(direction.y):
		if direction.x > 0:
			animation_player.play("run right")
			_last_direction = RIGHT
			return
		animation_player.play("run left")
		_last_direction = LEFT
		return
	if direction.y > 0:
		animation_player.play("run down")
		_last_direction = DOWN
		return
	animation_player.play("run up")
	_last_direction = UP
	


func _spawned(_animation):
	_active = true
	$HurtBox.monitorable = true
	$HurtBox.monitoring = true
	$HitBox.monitorable = true
	$HitBox.monitoring = true
	$AnimationPlayer.animation_finished.disconnect(_spawned)


func _area_entered_detection_range(area: Area2D):
	if not area is HurtBox:
		return
	if not area.is_in_group("Player"):
		return
	_detected = true


func _area_exited_detection_range(area: Area2D):
	if not area is HurtBox:
		return
	if not area.is_in_group("Player"):
		return
	_detected = false


func _on_damaged(damage, health):
	if health <= 0:
		queue_free()
