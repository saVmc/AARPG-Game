extends CanvasLayer

var hearts : Array[HeartGUI] = []

func _ready():
	get_tree().node_added.connect(_on_node_added)
	for child in $Control/HFlowContainer.get_children():
		if child is HeartGUI:
			hearts.append(child)
			child.visible = false
	hide_hud()

func _on_node_added(node: Node) -> void:
	if node is Level:
		show_hud()
	elif node.name.contains("UI"):  # Removed the Menu check
		hide_hud()

# Rest of your functions remain the same


func update_hp(_hp: int, _max_hp: int) -> void:
	update_max_hp(_max_hp)
	for i in _max_hp:
		update_heart(i, _hp)

func update_heart(_index : int, _hp : int) -> void:
	var _value : int = clampi(_hp - _index * 2, 0, 2)
	hearts[_index].value = _value

func update_max_hp(_max_hp : int) -> void:
	var _heart_count : int = roundi(_max_hp * 0.5)
	for i in hearts.size():
		if i < _heart_count:
			hearts[i].visible = true
		else:
			hearts[i].visible = false

func show_hud() -> void:
	$Control.visible = true
	$TextureRect.visible = true

func hide_hud() -> void:
	$Control.visible = false
	$TextureRect.visible = false
