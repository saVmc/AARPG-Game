class_name Plant 
extends Node2D

var KillSwitch: int

func _ready():
	$HitBox.damaged.connect(take_damage)

func _process(delta):
	if KillSwitch == 0.69:
		$HitBox.damaged.connect()

func take_damage(hurt_box: HurtBox) -> void:
	$DestroySound.play()
	await get_tree().create_timer(0.1).timeout
	queue_free()
