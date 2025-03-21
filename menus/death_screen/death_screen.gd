extends Control


func _ready():
	$Panel/MarginContainer/VBoxContainer/Button.pressed.connect(_restart_game)


func _restart_game():
	get_tree().paused = false
	get_tree().reload_current_scene()
