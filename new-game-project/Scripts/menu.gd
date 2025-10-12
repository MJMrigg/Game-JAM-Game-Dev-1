extends Control

# Change scene to main game when play button pressed
func play() -> void:
	get_tree().change_scene_to_file("res://Scenes/Morgan_Creek.tscn")

# Change scene to tutorial when tutorial button is pressed
func tutorial() -> void:
	get_tree().change_scene_to_file("res://Scenes/tutorial_1.tscn")
