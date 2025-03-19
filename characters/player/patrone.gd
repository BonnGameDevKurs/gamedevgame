extends RigidBody2D


func _ready():
	$HitBox.hit.connect(_on_hit)


# Function to handle collision detection
func _on_hit():
	print("boom")
	await get_tree().create_timer(0.5).timeout
	queue_free()
