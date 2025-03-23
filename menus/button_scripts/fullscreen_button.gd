extends CustomButton

var fullscreen: bool = false
func _ready():
	var config = ConfigFile.new()
	config.load("user://config.cfg")
	
	if config.has_section("display"):
		fullscreen = config.get_value("display", "fullscreen")
	
	set_fullscreen()

func _process(_delta):
	var F11 = Input.is_action_just_pressed("F11")
	if F11:
		toggle_fullscren()

func _on_pressed():
	toggle_fullscren()

func toggle_fullscren():
	fullscreen = !fullscreen
	set_fullscreen()

func set_fullscreen():
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		self.label.text = "Maximize"
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		self.label.text = "Fullscreen"

	var config = ConfigFile.new()
	config.load("user://config.cfg")
	config.set_value("display", "fullscreen", fullscreen)
	config.save("user://config.cfg")
