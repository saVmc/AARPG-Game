extends Node


func _on_Play_pressed():
	get_tree().change_scene_to_file("res://levels/area1/01.tscn")
func _on_Options_pressed():
	get_tree().change_scene_to_file("res://options_Menu.tscn")


func _on_Exit_pressed():
	get_tree().quit()
