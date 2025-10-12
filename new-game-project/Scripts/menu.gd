extends Control

# Change scenes to main game when play button pressed
func play() -> void:
	get_tree().change_scene_to_file("res://Scenes/Morgan_Creek.tscn")
