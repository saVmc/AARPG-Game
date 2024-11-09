extends CanvasLayer

signal shown
signal hidden
@onready var audio_player = $AudioStreamPlayer
@onready var button_save: TextureButton = $VBoxContainer/Button_Save
@onready var button_load: TextureButton = $VBoxContainer/Button_Load
@onready var item_description: Label = $ItemDescription


var is_paused : bool = false

func _ready() -> void:
	button_save = $VBoxContainer/Button_Save
	button_load = $VBoxContainer/Button_Load
	audio_player = $AudioStreamPlayer
	print("Audio player initialized:", audio_player != null)
	
	if button_save and button_load:
		button_save.pressed.connect(_on_save_pressed)
		button_load.pressed.connect(_on_load_pressed)
	
	hide_pause_menu()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		print("ESC Pressed")
		if is_paused == false:
			show_pause_menu()
			print("Showing Pause Menu")
		else:
			hide_pause_menu()
			print("Hiding Pause Menu")
		get_viewport().set_input_as_handled()

func show_pause_menu() -> void:
	get_tree().paused = true
	visible = true
	is_paused = true
	print("About to emit shown signal")
	shown.emit()
	# Direct call to inventory update
	var inventory_ui = $PanelContainer/GridContainer
	if inventory_ui:
		print("Found inventory UI, updating directly")
		inventory_ui.update_inventory()

func hide_pause_menu() -> void:
	get_tree().paused = false
	visible = false
	is_paused = false
	hidden.emit()


func _on_save_pressed() -> void:
	if is_paused == false:
		return
	SaveManager.save_game()
	hide_pause_menu()
	pass

func _on_load_pressed() -> void:
	if is_paused == false:
		return
	SaveManager.load_game()
	await LevelManager.level_load_started
	hide_pause_menu()
	pass
	

func update_item_description(new_text: String) -> void:
	# Get a fresh reference each time
	var description_label = get_node_or_null("ItemDescription")
	if description_label:
		description_label.text = new_text
		print("Description updated to:", new_text)

func play_audio(audio : AudioStream) -> void:
	var scene_audio_player = get_tree().current_scene.get_node("PauseMenu/AudioStreamPlayer")
	print("Found scene audio player:", scene_audio_player != null)
	if scene_audio_player and audio:
		print("Playing audio through scene instance")
		scene_audio_player.stream = audio
		scene_audio_player.play()


