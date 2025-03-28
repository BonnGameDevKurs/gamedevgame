extends Node2D

@export var spawn_area_start: Vector2 = Vector2(0,0)
@export var spawn_area_end: Vector2 = Vector2(300,200) 
@export var initial_spawn_time = 5
@export var time_reset_after_spawn_multiplier = 0.9
@export var min_spawn_time = 1


var enemy = preload("res://characters/enemy/enemy.tscn")
var spawn_time

@onready var spawn_timer = $SpawnTimer


func _ready():
	$SpawnTimer.timeout.connect(_on_spawn_timer_timeout)
	spawn_time = initial_spawn_time
	$SpawnTimer.start(initial_spawn_time)
	find_child("Player", true, false).died.connect(_end_game)
	var ability_progress = $StatsLayer/PanelContainer2/MarginContainer/ProgressBar
	ability_progress.max_value = $Player.kills_for_ability_use
	$Player.update_ability_meter.connect(ability_progress._on_ability_meter_update)


func spawn_enemies():
	var spawn_point = Vector2(
		randf_range(spawn_area_start.x, spawn_area_end.y), 
		randf_range(spawn_area_start.y, spawn_area_end.y)
	)
	var instance = enemy.instantiate()
	instance.global_position = spawn_point
	self.add_child(instance)


func _on_spawn_timer_timeout():
	spawn_time = max(min_spawn_time, spawn_time*time_reset_after_spawn_multiplier)
	spawn_timer.start(spawn_time)
	spawn_enemies()


func _end_game():
	var stats_holder: StatsHolderClass = $"/root/StatsHolder"
	stats_holder.update_stat(
			stats_holder.Stats.HIGHSCORE,
			stats_holder.kill_counter)
	get_tree().paused = true
	$"DeathLayer/DeathScreen".init()
	$DeathLayer.visible = true
