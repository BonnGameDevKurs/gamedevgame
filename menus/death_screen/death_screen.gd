extends Control

@onready var stats_holder: StatsHolderClass = $"/root/StatsHolder"
@onready var label_score: Label = $Panel/MarginContainer/VBoxContainer/LabelScore
@onready var label_highscore: Label = $Panel/MarginContainer/VBoxContainer/LabelNewHighscore

func _ready():
	$Panel/MarginContainer/VBoxContainer/Button.pressed.connect(_restart_game)
	stats_holder.highscore_updated.connect(show_new_highscore_message)

func show_new_highscore_message():
	label_highscore.text = "NEW HIGHSCORE!!!"
	label_highscore.visible = true
	print("Trigger")

func init():
	label_score.text = "Score: %s" % str(StatsHolder.kill_counter)

func _restart_game():
	label_highscore.visible = false
	get_tree().paused = false
	get_tree().reload_current_scene()
