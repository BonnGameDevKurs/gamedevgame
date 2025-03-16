extends CanvasLayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var esc = Input.is_action_just_pressed("ESC")
	if esc:
		toggle()
	
func toggle():
	self.visible = !self.visible
	get_tree().paused = self.visible
