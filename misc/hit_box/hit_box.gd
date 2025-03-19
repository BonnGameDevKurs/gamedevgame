class_name HitBox
extends Area2D

signal hit()

@export var damage: int = 10

func _on_area_entered(area: Area2D):
	if not area is HurtBox:
		return
	var affected_by = area.affected_by_groups
	for group in get_groups():
		if group in affected_by:
			hit.emit()
			return
