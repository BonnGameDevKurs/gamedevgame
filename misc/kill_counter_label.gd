extends Label

var stats_holder: StatsHolderClass

func _ready():
	stats_holder = $"/root/StatsHolder"
	stats_holder.subscribe(self, [StatsHolderClass.Stats.KILLCOUNTER])

func update():
	self.text = "Kills: %s" % str(StatsHolder.kill_counter)
