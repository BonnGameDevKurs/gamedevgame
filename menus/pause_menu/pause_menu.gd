extends CanvasLayer

var reactivate = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var esc = Input.is_action_just_pressed("ESC")
	if esc:
		toggle()
	
func toggle():
	if self.visible != get_tree().paused:
		reactivate = false
	
	self.visible = !self.visible
	
	if not self.visible and not reactivate:
		reactivate = true
	else:
		get_tree().paused = self.visible
