class_name State_ChargeAttack extends State

@export var charge_duration : float = 1.0
@export var move_speed : float = 80.0
@export var sfx_charged : AudioStream
@export var sfx_spin : AudioStream

var timer : float = 0.0
var walking : bool = false
var is_attacking : bool = false
var particles : ParticleProcessMaterial

@onready var idle: State_Idle = $"../Idle"
@onready var charge_hurt_box: HurtBox = %ChargeHurtBox
@onready var charge_spin_box:HurtBox = %ChargeSpinBox
@onready var audio_stream_player_2d : AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"
@onready var spin_effect_sprite_2d : Sprite2D = $"../../Sprite2D/SpinEffectSprite2D"
@onready var spin_animation_player: AnimationPlayer = $"../../Sprite2D/SpinEffectSprite2D/AnimationPlayer"
@onready var gpu_particles_2d: GPUParticles2D = $"../../Sprite2D/ChargeHurtBox/GPUParticles2D"


func init() -> void:
	gpu_particles_2d.emitting = false
	particles = gpu_particles_2d.process_material as ParticleProcessMaterial
	spin_effect_sprite_2d.visible = false
	pass

#what happens when the player enters this state
func enter() -> void:
	timer = charge_duration
	is_attacking = false
	walking = false
	charge_hurt_box.monitoring = true
	gpu_particles_2d.emitting = true
	gpu_particles_2d.amount = 4
	gpu_particles_2d.explosiveness = 0
	particles.initial_velocity_min = 10
	particles.initial_velocity_max = 30


func exit() -> void:
	charge_hurt_box.monitoring = false
	charge_spin_box.monitoring = false
	spin_effect_sprite_2d.visible = false
	gpu_particles_2d.emitting = false
	pass

func process( _delta : float) -> State:
	
	if timer > 0:
		timer -= _delta
		if timer <= 0:
			timer = 0
			charge_complete()
	
	
	if is_attacking == false:
		if player.direction == Vector2.ZERO:
			walking = false
			player.update_animation("charge" )
		elif player.set_direction() or walking == false:
			walking = true
			player.update_animation("charge_walk")
			pass
	
	player.velocity = player.direction * move_speed
	return null

func physics( _delta : float ) -> State:
	return null

func handle_input( _event: InputEvent ) -> State:
	if _event.is_action_released("attack"):
		if timer > 0:
			return idle
		elif is_attacking == false:
			charge_attack()
	return null

func charge_attack() -> void:
	is_attacking = true
	player.animation_player.stop()
	player.animation_player.play("charge_attack")
	player.animation_player.seek(get_spin_frame())
	play_audio(sfx_spin)
	spin_effect_sprite_2d.visible = true
	spin_animation_player.play("spin")
	
	# Set duration for exactly 2 spins
	var spin_duration: float = 0.35 * 2
	player.make_invulnerable(spin_duration)
	charge_spin_box.monitoring = true
	
	# Create timer for exact spin duration
	await get_tree().create_timer(spin_duration).timeout
	state_machine.change_state(idle)

func _on_charge_attack_finished(_anim_name: String) -> void:
	state_machine.change_state(idle)
	print("no more charge '_'")
	
func get_spin_frame() -> float:
	var interval : float = 0.05
	match player.cardinal_direction:
		Vector2.DOWN:
			return interval * 0
		Vector2.UP:
			return interval * 4
		_:
			return interval * 6
		
	

func charge_complete() -> void:
	play_audio(sfx_charged)
	gpu_particles_2d.amount = 60
	gpu_particles_2d.explosiveness = 1
	particles.initial_velocity_min = 50
	particles.initial_velocity_max = 100
	await get_tree().create_timer(0.5).timeout
	gpu_particles_2d.amount = 14
	gpu_particles_2d.explosiveness = 0
	particles.initial_velocity_min = 10
	particles.initial_velocity_max = 30

func play_audio(_audio : AudioStream) -> void:
	audio_stream_player_2d.stream = _audio
	audio_stream_player_2d.play()
	pass
