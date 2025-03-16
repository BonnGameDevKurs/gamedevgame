class_name StatsHolderClass
extends Node

static var kill_counter = 0

enum Stats
{
	KILLCOUNTER,
}

static var subscriber_matrix: Array = []

func _ready():
	for stat in Stats:
		subscriber_matrix.append([])

func subscribe(new_sub: Node, interests: Array[Stats]):
	for interest in interests:
		subscriber_matrix[interest].append(new_sub)

static func update_stat(stat: Stats, new_value):
	match stat:
		Stats.KILLCOUNTER:
			kill_counter = new_value
	
	for sub in subscriber_matrix[stat]:
		sub.update()
	
