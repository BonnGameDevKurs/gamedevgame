extends Label

var stats_holder: StatsHolderClass

func _ready():
	stats_holder = $"/root/StatsHolder"
	stats_holder.kill_counter_updated.connect(update)

func update():
	self.text = "Kills: %s" % str(StatsHolder.kill_counter)
