class_name StatsHolderClass
extends Node

signal kill_counter_updated()
signal highscore_updated()

static var kill_counter = 0
static var highscore = 0

enum Stats
{
	KILLCOUNTER,
	HIGHSCORE
}

func _ready():
	# Fetch old stats from config
	var config = ConfigFile.new()
	config.load("user://config.cfg")
	
	if config.has_section("stats"):
		highscore = config.get_value("stats", "highscore")

func update_stat(stat: Stats, new_value):
	match stat:
		Stats.KILLCOUNTER:
			kill_counter = new_value
			kill_counter_updated.emit()

		Stats.HIGHSCORE:
			if new_value > highscore:
				highscore = new_value
				highscore_updated.emit()
				
				var config = ConfigFile.new()
				config.load("user://config.cfg")
				config.set_value("stats", "highscore", new_value)
				config.save("user://config.cfg")
	
