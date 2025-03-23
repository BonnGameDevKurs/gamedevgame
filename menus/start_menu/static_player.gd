extends CharacterBody2D

func _ready():
	$MovementAnimation.play("idle down")
	$HealthBar.visible = false
