extends TextureRect

func _ready():
	visible = false
	SaveManager.show_notification.connect(_on_notification)

func _on_notification(text: String):
	visible = true
	await get_tree().create_timer(2.0).timeout
	visible = false
