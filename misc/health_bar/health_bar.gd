extends TextureProgressBar

@export var hurt_box: HurtBox

func _ready():
	self.max_value = hurt_box.max_health
	self.min_value = 0
	self.value = self.max_value
	hurt_box.damaged.connect(update_health)

func update_health(_damage, health):
	self.value = health
