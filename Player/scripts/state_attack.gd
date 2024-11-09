class_name State_Attack extends State

var attacking : bool = false

@export var attack_sound : AudioStream
@export_range(1,20, 0.5) var decelerate_speed : float = 5.0

@onready var walk : State = $"../Walk"
@onready var attack_anim : AnimationPlayer = $"../../Sprite2D/Effects/AnimationPlayer"
@onready var animation_player : AnimationPlayer = $"../../AnimationPlayer"
@onready var idle : State = $"../Idle"
@onready var audio : AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"
@onready var hurt_box : HurtBox = %AttackHurtBox
@onready var charge_attack: State = $"../ChargeAttack"

func enter() -> void:
	player.update_animation("attack")
	attack_anim.play("attack_" + player.anim_direction())
	animation_player.animation_finished.connect(end_attack)
	
	audio.stream = attack_sound
	audio.pitch_scale = randf_range(0.9, 1.1)
	audio.play()
	
	attacking = true
	
	await get_tree().create_timer(0.075).timeout
	if attacking:
		hurt_box.monitoring = true

func exit() -> void:
	animation_player.animation_finished.disconnect(end_attack)
	attacking = false
	hurt_box.monitoring = false

func process(_delta : float) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null

func physics(_delta : float) -> State:
	return null

func handle_input(_event: InputEvent) -> State:
	return null

func end_attack(_newAnimName : String) -> void:
	if Input.is_action_pressed("attack"):
		if SaveManager.current_save.abilities.get("charge_attack", false):
			state_machine.change_state(charge_attack)
			return
	attacking = false
