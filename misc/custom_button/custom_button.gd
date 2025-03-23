class_name CustomButton
extends TextureButton

@export var text: String = ""

@onready var label: Label = $Label

func _ready():
	label.text = text
