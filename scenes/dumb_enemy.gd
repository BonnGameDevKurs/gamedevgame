extends CharacterBody2D
@onready var target = $"../Player"
var speed = 10

@export var LP = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect the body_entered signal to the _on_Hitbox_body_entered function
	$Area2D.body_entered.connect(_on_Hitbox_body_entered)


# Function to handle collision detection
func _on_Hitbox_body_entered(body):
	# Check if the entering body is in the bullet group
	if body.is_in_group("Bullet"):
		# Apply damage to the enemy
		LP -= body.dmg
		# Print the remaining health for debugging purposes
		print("Enemy health: ", LP)
		# Check if the enemy's health is less than or equal to zero
		if LP <= 0:
			# Remove the enemy from the scene
			queue_free()

func _physics_process(_delta: float) -> void:
	if (target.position - position).length() < 50:
		var dir = (target.position - position).normalized()
		velocity = dir * speed
		look_at(target.position)
		move_and_slide()
