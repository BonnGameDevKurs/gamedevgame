extends CharacterBody2D

const SPEED = 10

@export var LP = 50

var detected = false

@onready var target = $"../Player"

func _ready():
	$DetectionRadius.area_entered.connect(_on_detection_radius_area_entered)
	$DetectionRadius.area_exited.connect(_on_detection_radius_area_exited)

func _physics_process(_delta: float) -> void:
	if detected:
		var dir = (target.position - position).normalized()
		velocity = dir * SPEED
		#look_at(target.position)
		move_and_slide()

func _on_detection_radius_area_entered(area: Node2D) -> void:
	if area.name == "PlayerHurtBox":
		detected = true
	print("here")

func _on_detection_radius_area_exited(area: Node2D) -> void:
	if area.name == "PlayerHurtBox":
		detected = false
