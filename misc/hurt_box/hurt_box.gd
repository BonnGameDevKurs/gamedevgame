class_name HurtBox
extends Area2D

signal damaged(damage, new_health)

@export var max_health: int = 100
@export var affected_by_groups: Array[String]

var health


func _ready():
	health = max_health
	area_entered.connect(on_area_entered)


func on_area_entered(area: Area2D):	
	if not area is HitBox:
		return
	for group in affected_by_groups:
		if not area.is_in_group(group):
			continue
		health = max(health - area.damage, 0)
		damaged.emit(area.damage, health)
		return
