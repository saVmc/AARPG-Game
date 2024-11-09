extends Button

@onready var shop_keeper = $"../../../../"
@onready var description_label = $"../../Description"

func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	pressed.connect(_on_button_pressed)
	update_button_state()

func update_button_state():
	disabled = SaveManager.current_save.abilities["parry_attack"]
	modulate = Color(0.5, 0.5, 0.5) if disabled else Color.WHITE

func _on_mouse_entered():
	description_label.text = shop_keeper.parry_ability.description

func _on_mouse_exited():
	description_label.text = ""

func _on_button_pressed():
	shop_keeper.try_purchase_parry()
	update_button_state()
