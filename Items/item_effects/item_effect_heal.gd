class_name ItemEffectHeal extends ItemEffect

@export var heal_amount : int = 1
@export var audio : AudioStream

func use() -> void:
	print("Heal effect used, audio resource:", audio)
	PlayerManager.player.update_hp(heal_amount)
	if audio:
		print("Playing heal audio")
		PauseMenu.play_audio(audio)
