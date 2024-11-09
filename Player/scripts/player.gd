class_name Player extends CharacterBody2D

var cardinal_direction : Vector2 = Vector2.DOWN
const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]
var direction : Vector2 = Vector2.ZERO
var invulnerable : bool = false
var hp : int = 6
var max_hp : int = 6
var base_speed: float = 100.0  
var speed_multiplier: float = 1.0

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var effect_animation_player : AnimationPlayer = $EffectAnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
@onready var state_machine : PlayerStateMachine = $StateMachine
@onready var hit_box : HitBox = $HitBox
@onready var parry_system = $ParrySystem

signal direction_changed(new_direction: Vector2)
signal player_damaged(hurt_box: HurtBox)

func _ready():
	PlayerManager.player = self
	state_machine.Initialise(self)
	if hit_box == null:
		print("HitBox is null!")
	else:
		hit_box.damaged.connect(take_damage)
	update_hp(99)
	print("Player is ready and connected to HitBox signal")

func _process(_delta):
	if Input.is_key_pressed(KEY_SHIFT) and Input.is_key_pressed(KEY_P):
		speed_multiplier = 5.0
	else:
		speed_multiplier = 1.0
	direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized()	

func _physics_process(_delta):
	if state_machine.current_state is State_Attack or state_machine.current_state is State_Stun:
		move_and_slide()
	else:
		velocity = direction * base_speed * speed_multiplier
		move_and_slide()

func set_direction() -> bool:
	if direction == Vector2.ZERO:
		return false
	var direction_id : int = int(round(
		(direction + cardinal_direction * 0.1).angle() 
		/ TAU * DIR_4.size()
	))
	var new_dir = DIR_4[direction_id]
	if new_dir == cardinal_direction:
		return false
	cardinal_direction = new_dir
	emit_signal("direction_changed", new_dir)
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true

func update_animation(state : String) -> void:
	animation_player.play(state + "_" + anim_direction())

func anim_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"

func take_damage(hurt_box: HurtBox) -> void:
	if parry_system and parry_system.parry_active:
		parry_system.successful_parry(hurt_box)
		return
	if invulnerable:
		return
	update_hp(-hurt_box.damage)
	if hp > 0:
		emit_signal("player_damaged", hurt_box)
		print("Player took damage, HP:", hp)
	else:
		emit_signal("player_damaged", hurt_box)
		update_hp(99)
		print("Player died and HP reset")

func update_hp(delta: int) -> void:
	hp = clamp(hp + delta, 0, max_hp)
	PlayerHud.update_hp(hp, max_hp)

func make_invulnerable(_duration: float = 1.0) -> void:
	invulnerable = true
	hit_box.monitoring = false
	await get_tree().create_timer(_duration).timeout
	invulnerable = false
	hit_box.monitoring = true
