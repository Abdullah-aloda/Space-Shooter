extends Control


func _ready():
	# Set the label color to red
	add_theme_color_override("font_color", Color.RED)
	position.x = 125
	position.y = 450
