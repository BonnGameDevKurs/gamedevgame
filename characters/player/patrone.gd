extends RigidBody2D


func _ready():
	$HitBox.hit.connect(_on_hit)
	$Timer.timeout.connect(_on_timeout)


# Function to handle collision detection
func _on_hit():
	print("boom")
	$Timer.start(0.5)
	

func _on_timeout():
	queue_free()
	
