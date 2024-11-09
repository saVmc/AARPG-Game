class_name HurtBox extends Area2D

@export var damage : int = 1

func _ready():
	area_entered.connect(AreaEntered)

func AreaEntered(a : Area2D) -> void:
	if a is HitBox:
		print("HurtBox detected hit")
		var final_damage = damage
		print("Base damage:", damage)
		
		# Only check for parry system if this is a player's attack
		if get_parent().name == "Sprite2D" and get_parent().get_parent().name == "Player":
			var player = get_parent().get_parent()
			var parry_system = player.find_child("ParrySystem")
			if parry_system:
				print("Found ParrySystem!")
				print("Current double_damage_ready state:", parry_system.double_damage_ready)
				var multiplier = parry_system.get_damage_multiplier()
				print("Received multiplier:", multiplier)
				final_damage = damage * multiplier
				print("Calculated final damage:", final_damage)
		
		print("Final damage being dealt:", final_damage)
		a.take_damage(self)






func owner_node():
	var parent = get_parent()
	while parent != null:
		if parent is Player:
			return parent
		parent = parent.get_parent()
	return null
