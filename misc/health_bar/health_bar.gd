extends ProgressBar

@export var hurt_box: HurtBox

func _ready():
	self.max_value = hurt_box.max_health
	self.min_value = 0
	self.value = self.max_value

func update():
	self.value = hurt_box.health
