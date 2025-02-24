class_name Player
extends CharacterBody2D


const SPEED = 300 # Wie schnell sich euer Charakter bewegen soll

# Diese funktion wird aufgerufen, sobald die Scene (Hier euer Charakter) gerufen wird
func _ready():
	
	motion_mode = MOTION_MODE_FLOATING # motion_mode gibt für move_and_slide() an, welche Art von Kollisionen für euer Spiel relevant sind. Es wird zwischen Side scrollern und Top down unterschieden.

# _physics_process ist eine funktion, welche jeden "Physics frame" aufgerufen wird
# Bitte ignoriert erstmal _delta
func _physics_process(_delta):
	
	# Input ist ein Objekt, welches euch zugriff auf Spielereingaben gibt
	# Die Funktion get_vector gibt euch einen Vector 2d zurück wobei:
	# get_vector(negative_x: StringName, positive_x: StringName, negative_y: StringName, positive_y: StringName, deadzone: float = -1.0)
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	velocity = direction * SPEED # Vektor Multiplikation. velocity ist dabei eine globale variable
	
	# Die Funktion move_and_slide() berechnet für euch wie sich der Charakter bewegen muss, anhand dem Richtungsvektor velocity
	move_and_slide()
	
	
	push_stuff()

########################################################### For Later ###########################################

const PUSH_FORCE := 10
const MIN_PUSH_FORCE := 10

func push_stuff() -> void:
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c. get_collider() is RigidBody2D:
			var push_force = (PUSH_FORCE * velocity.length() / SPEED) + MIN_PUSH_FORCE
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)
		
