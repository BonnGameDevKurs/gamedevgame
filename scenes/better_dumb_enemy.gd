extends CharacterBody2D
@onready var target = $"../Player"
var speed = 10

@export var LP = 50

var detected = false
@onready var hitbox = $Hitbox

func _physics_process(_delta: float) -> void:
	if detected:
		var dir = (target.position - position).normalized()
		velocity = dir * speed
		look_at(target.position)
		move_and_slide()

func _on_detection_radius_body_entered(body: Node2D) -> void:
	detected = true


func _on_detection_radius_body_exited(body: Node2D) -> void:
	detected = false
