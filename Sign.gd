extends StaticBody2D

@export var sign_text: String = "Sample Text"
@export var text_color: Color = Color.BLACK
@export var text_size: int = 16
@export var panel_color: Color = Color(255,255,255,175)
@export var panel_distance: float = 25.0  # New variable for panel distance

@onready var panel = $Panel
@onready var label = $Panel/Label

func _ready():
	panel.modulate = panel_color
	label.add_theme_color_override("font_color", text_color)
	label.add_theme_font_size_override("font_size", text_size)

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		label.text = sign_text
		panel.show()
		panel.size.x = label.size.x + 16
		panel.size.y = label.size.y + 16
		panel.position.y = label.size.y + panel_distance

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		panel.hide()
