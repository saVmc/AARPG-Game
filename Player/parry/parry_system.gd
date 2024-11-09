extends Node2D

@export var cooldown_time: float = 1.0

var can_parry: bool = true
var double_damage_ready: bool = false

@onready var cooldown_timer = $CooldownTimer
@onready var damage_particles = $DamageParticles
@onready var parry_text = $ParryTexture
@onready var player_animation : AnimationPlayer = $"../AnimationPlayer"
@onready var cooldown_bar = $CooldownBar

func _ready():
	print("Parry system initialized")
	print("Initial double_damage_ready state:", double_damage_ready)
	parry_text.hide()
	damage_particles.emitting = false
	cooldown_bar.max_value = cooldown_time
	cooldown_bar.value = 0
	can_parry = true
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)

func _process(_delta):
	if !can_parry:
		cooldown_bar.value = cooldown_timer.time_left
	else:
		cooldown_bar.value = 0

func _input(event):
	if event.is_action_pressed("parry"):
		print("F key pressed")
		print("Can parry state:", can_parry)
		print("Current double_damage_ready state:", double_damage_ready)
		if can_parry and SaveManager.current_save.abilities["parry_attack"]:
			print("Starting parry sequence")
			var player = get_parent()
			var anim_name = "parry_" + player.anim_direction()
			print("Playing animation:", anim_name)
			player_animation.play(anim_name)
			activate_double_damage()
			can_parry = false
			cooldown_timer.start(cooldown_time)

func activate_double_damage():
	print("Activating double damage")
	parry_text.show()
	double_damage_ready = true
	print("double_damage_ready set to:", double_damage_ready)
	damage_particles.emitting = true
	print("Particles enabled")
	await get_tree().create_timer(1.0).timeout
	parry_text.hide()

func _on_cooldown_timer_timeout():
	print("Cooldown timer finished")
	can_parry = true
	print("Can parry reset to:", can_parry)

func get_damage_multiplier() -> int:
	print("Checking damage multiplier")
	print("Current double_damage_ready state:", double_damage_ready)
	if double_damage_ready:
		print("Double damage triggered!")
		double_damage_ready = false
		damage_particles.emitting = false
		print("Particles disabled")
		print("Returning damage multiplier: 2")
		return 2
	print("Returning normal damage: 1")
	return 1
