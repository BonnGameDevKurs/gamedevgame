extends ProgressBar

var target: Node

func init(target_: Node):
	target = target_
	self.max_value = target.max_health
	self.min_value = 0
	self.value = self.max_value

func update():
	self.value = target.health
