extends RigidBody2D

var dmg = 10

# Function to handle collision detection
func _on_body_entered(body):
	print("boom")
	await get_tree().create_timer(0.5).timeout
	queue_free()  # Remove the bullet from the scene
