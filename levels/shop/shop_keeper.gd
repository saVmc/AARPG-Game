extends Node2D

@onready var interaction_area: Area2D = $InteractionArea
@onready var shop_ui: Control = $CanvasLayer/ShopUI
@onready var player_inventory: InventoryData = null
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var audio_player: AudioStreamPlayer2D = $AudioPlayer
@export var success_sound: AudioStream
@export var fail_sound: AudioStream

var charge_attack = {
	"name": "Charge Attack",
	"cost": 10,
	"description": "A powerful spinning attack that deals damage to surrounding enemies",
	"ability_id": "charge_attack"
}

var parry_ability = {
	"name": "Parry",
	"cost": 20,
	"description": "Press F to parry attacks. Successful parries grant triple damage!",
	"ability_id": "parry_attack"
}

var health_upgrade = {
	"name": "Health Upgrade",
	"cost": 15,
	"description": "Increases your maximum health by 4",
	"ability_id": "health_upgrade"
}


func _ready() -> void:
	print("Shop keeper initializing...")
	print("Connecting Area2D signals...")
	interaction_area.body_entered.connect(_on_player_entered)
	interaction_area.body_exited.connect(_on_player_exited)
	canvas_layer.visible = false
	print("Initial UI state set")
	print("Area2D collision layer:", interaction_area.collision_layer)
	print("Area2D collision mask:", interaction_area.collision_mask)

func _on_player_entered(body: Node2D) -> void:
	print("Player entered, showing UI")
	canvas_layer.visible = true
	print("Canvas layer visibility:", canvas_layer.visible)
	player_inventory = PlayerManager.INVENTORY_DATA

func _on_player_exited(body: Node2D) -> void:
	print("Player left, hiding UI")
	canvas_layer.visible = false
	print("Canvas layer visibility:", canvas_layer.visible)

func try_purchase_charge_attack() -> void:
	var gem_item = load("res://Items/gem.tres")
	
	# Already purchased check
	if SaveManager.current_save.abilities["charge_attack"]:
		audio_player.stream = fail_sound
		audio_player.play()
		return
		
	# Purchase attempt
	if player_inventory.use_item(gem_item, charge_attack.cost):
		SaveManager.current_save.abilities["charge_attack"] = true
		SaveManager.save_game()
		SaveManager.emit_signal("show_notification", "Charge Attack acquired!")
		audio_player.stream = success_sound
		audio_player.play()
	else:
		audio_player.stream = fail_sound
		audio_player.play()


func try_purchase_health_upgrade() -> void:
	var gem_item = load("res://Items/gem.tres")
	
	if SaveManager.current_save.abilities["health_upgrade_purchased"]:
		audio_player.stream = fail_sound
		audio_player.play()
		return
		
	if player_inventory.use_item(gem_item, health_upgrade.cost):
		PlayerManager.set_health(PlayerManager.player.hp + 4, PlayerManager.player.max_hp + 4)
		SaveManager.current_save.abilities["health_upgrade_purchased"] = true
		SaveManager.save_game()
		SaveManager.emit_signal("show_notification", "Health Upgraded!")
		audio_player.stream = success_sound
		audio_player.play()
	else:
		audio_player.stream = fail_sound
		audio_player.play()

func try_purchase_parry() -> void:
	var gem_item = load("res://Items/gem.tres")
	
	if SaveManager.current_save.abilities["parry_attack"]:
		audio_player.stream = fail_sound
		audio_player.play()
		return
		
	if player_inventory.use_item(gem_item, parry_ability.cost):
		SaveManager.current_save.abilities["parry_attack"] = true
		SaveManager.save_game()
		SaveManager.emit_signal("show_notification", "Parry Attack acquired!")
		audio_player.stream = success_sound
		audio_player.play()
	else:
		audio_player.stream = fail_sound
		audio_player.play()
