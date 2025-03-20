extends Node2D

@export var spawn_area_start: Vector2 = Vector2(0,0)
@export var spawn_area_end: Vector2 = Vector2(300,200) 

var enemy = preload("res://characters/enemy/enemy.tscn")

@onready var spawn_timer = $SpawnTimer


func _ready():
	$SpawnTimer.timeout.connect(_on_spawn_timer_timeout)


func spawn_enemies():
	var spawn_point = Vector2(
		randf_range(spawn_area_start.x, spawn_area_end.y), 
		randf_range(spawn_area_start.y, spawn_area_end.y)
	)
	var instance = enemy.instantiate()
	instance.global_position = spawn_point
	get_tree().get_root().add_child(instance)


func _on_spawn_timer_timeout():
	spawn_timer.start()
	spawn_enemies()
