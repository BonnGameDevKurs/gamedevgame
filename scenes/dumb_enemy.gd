extends CharacterBody2D
@onready var target = $"../Player"
var speed = 10

# Health and HealthBar
var health: int
@export var max_health: int = 100
@export var health_bar: ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect the body_entered signal to the _on_Hitbox_body_entered function
	$Area2D.body_entered.connect(_on_Hitbox_body_entered)

	# Set up the players resources
	health = max_health
	
	# Set up the health bar
	health_bar.init(self)

# Function to handle collision detection
func _on_Hitbox_body_entered(body):
	# Check if the entering body is in the bullet group
	if body.is_in_group("Bullet"):
		update_health(-body.dmg)

func _physics_process(_delta: float) -> void:
	if (target.position - position).length() < 250:
		var dir = (target.position - position).normalized()
		velocity = dir * speed
		$Sprite2D.look_at(target.position)
		move_and_slide()

func update_health(addend: int):
	# Apply healing/damage to the enemy
	health += addend
	
	# Print the remaining health for debugging purposes
	print("Enemy health: ", health)
	
	# Check if the enemy's health is less than or equal to zero
	if health <= 0:
		# Add a kill
		StatsHolderClass.update_stat(	
								StatsHolderClass.Stats.KILLCOUNTER,
								StatsHolderClass.kill_counter + 1)
		# Remove the enemy from the scene
		queue_free()
	
	# Update the enemy's healthbar	
	health_bar.update()
