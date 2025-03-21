class_name HurtBox
extends Area2D

signal damaged(damage, new_health)

@export var max_health: int = 100
@export var damage_tick_time = 0.5
@export var affected_by_groups: Array[String]

var health
var damage_dealers = []
var tick_time_remaining = 0

func _ready():
	health = max_health
	area_entered.connect(on_area_entered)
	area_exited.connect(on_area_exited)


func _physics_process(delta):
	if damage_dealers.is_empty():
		return
	tick_time_remaining -= delta
	if tick_time_remaining > 0:
		return
	var damage = get_max_damage_in_dealers()
	take_damage(damage)


func get_max_damage_in_dealers():
	var damage = 0
	for dealer in damage_dealers:
		damage = max(damage, dealer.damage)
	return damage


func take_damage(damage):
	tick_time_remaining = damage_tick_time
	health = max(health - damage, 0)
	damaged.emit(damage, health)


func on_area_entered(area: Area2D):	
	if not area is HitBox:
		return
	for group in affected_by_groups:
		if not area.is_in_group(group):
			continue
		damage_dealers.append(area)
		take_damage(area.damage)
		return


func on_area_exited(area: Area2D):
	damage_dealers.erase(area)
