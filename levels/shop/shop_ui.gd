extends Control

@onready var shop_keeper: Node2D = $"../.."  
@onready var item_list: VBoxContainer = $ItemList
@onready var description_label: Label = $Description
@onready var gem_counter_label = $GemCounter

func _ready():
	update_gem_count()
	PlayerManager.INVENTORY_DATA.inventory_updated.connect(update_gem_count)

func update_gem_count():
	var gem_item = load("res://Items/gem.tres")
	var gem_count = PlayerManager.INVENTORY_DATA.get_item_count(gem_item)
	gem_counter_label.text = "Gems: " + str(gem_count)
