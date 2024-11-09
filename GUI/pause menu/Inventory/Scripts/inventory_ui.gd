class_name InventoryUI extends Control

const INVENTORY_SLOT = preload("res://GUI/pause menu/Inventory/inventory_slot.tscn")

var focus_index : int = 0

@export var data : InventoryData


func _ready() -> void:
	print("InventoryUI ready, connecting signals")
	# Connect using a different method
	var pause_menu = get_node("/root/PauseMenu")
	print("Found PauseMenu:", pause_menu != null)
	if pause_menu:
		pause_menu.shown.connect(update_inventory)
		pause_menu.hidden.connect(clear_inventory)
	clear_inventory()
	data.changed.connect(on_inventory_changed)

func clear_inventory() -> void:
	for c in get_children():
		c.queue_free()


func update_inventory(i: int = 0) -> void:
	print("Update inventory called with index:", i)
	print("Current inventory data:", data.slots)
	clear_inventory()
	for s in data.slots:
		var new_slot = INVENTORY_SLOT.instantiate()
		add_child(new_slot)
		new_slot.slot_data = s
		new_slot.focus_entered.connect(item_focused)
	
	await get_tree().process_frame
	get_child(i).grab_focus()

func item_focused() -> void:
	for i in get_child_count():
		if get_child( i ).has_focus():
			focus_index = i
			return
	pass


func on_inventory_changed() -> void:
	var i = focus_index
	clear_inventory()
	update_inventory( i )
