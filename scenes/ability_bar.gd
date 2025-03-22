extends ProgressBar


func _on_ability_meter_update(ability):
	var display_value = min(max_value, ability)
	value = display_value
	
