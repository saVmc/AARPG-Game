class_name InventorySlotUI extends Button


var slot_data : SlotData : set = set_slot_data

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label



func _ready() -> void:
	texture_rect.texture = null
	label.text = ""
	focus_entered.connect( item_focused )
	focus_exited.connect( item_unfocused )
	pressed.connect( item_pressed )


func set_slot_data( value : SlotData ) -> void:
	slot_data = value
	if slot_data == null:
		return
	texture_rect.texture = slot_data.item_data.texture
	label.text = str( slot_data.quantity )


func item_focused() -> void:
	if slot_data != null and slot_data.item_data != null:
		var pause_menu = get_tree().current_scene.get_node("PauseMenu")
		if pause_menu:
			pause_menu.update_item_description(slot_data.item_data.description)

func item_unfocused() -> void:
	var pause_menu = get_tree().current_scene.get_node("PauseMenu")
	if pause_menu:
		pause_menu.update_item_description("")



func item_pressed() -> void:
	if slot_data and slot_data.item_data:
		var was_used = slot_data.item_data.use()
		if was_used:
			slot_data.quantity -= 1
			if slot_data.quantity <= 0:
				# Clear the slot visually
				texture_rect.texture = null
				label.text = ""
				# Remove from inventory data
				var inventory = get_parent().data
				var slot_index = inventory.slots.find(slot_data)
				inventory.slots[slot_index] = null
				inventory.emit_changed()
			else:
				label.text = str(slot_data.quantity)
