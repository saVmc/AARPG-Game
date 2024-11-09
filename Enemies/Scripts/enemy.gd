class_name Enemy extends CharacterBody2D

signal direction_changed(new_direction: Vector2)
signal enemy_damaged(hurt_box: HurtBox)
signal enemy_destroyed(hurt_box: HurtBox)

const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

@export var hp: int = 3
@export var use_directional_animations: bool = true

var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO
var player: Player
var invulnerable: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite = $Sprite2D if has_node("Sprite2D") else $AnimatedSprite2D
@onready var hit_box: HitBox = $HitBox
@onready var state_machine: EnemyStateMachine = $EnemyStateMachine

func _ready():
	state_machine.initialise(self)
	player = PlayerManager.player
	hit_box.damaged.connect(_take_damage)

func _physics_process(_delta):
	move_and_slide()

func set_direction(_new_direction: Vector2) -> bool:
	direction = _new_direction
	if direction == Vector2.ZERO:
		return false
	
	var direction_id: int = int(round(
		(direction + cardinal_direction * 0.1).angle()
		/ TAU * DIR_4.size()
	))
	var new_dir = DIR_4[direction_id]
	
	if new_dir == cardinal_direction:
		return false
	
	cardinal_direction = new_dir
	direction_changed.emit(new_dir)
	
	if sprite is Sprite2D:
		sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	else:
		sprite.flip_h = cardinal_direction == Vector2.LEFT
	
	return true

func update_animation(state: String) -> void:
	if use_directional_animations:
		animation_player.play(state + "_" + anim_direction())
	else:
		animation_player.play(state)

func anim_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"

func _take_damage(hurt_box: HurtBox) -> void:
	if invulnerable:
		return
	hp -= hurt_box.damage
	if hp > 0:
		enemy_damaged.emit(hurt_box)
	else:
		enemy_destroyed.emit(hurt_box)
