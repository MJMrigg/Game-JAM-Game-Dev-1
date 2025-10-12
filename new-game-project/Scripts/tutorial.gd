extends Control

@export var scene:int

func next() -> void:
	if(scene == 1):
		get_tree().change_scene_to_file("res://Scenes/tutorial_2.tscn")
	elif(scene == 2):
		get_tree().change_scene_to_file("res://Scenes/tutorial_3.tscn")
	elif(scene == 3):
		get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func prev() -> void:
	if(scene == 3):
		get_tree().change_scene_to_file("res://Scenes/tutorial_2.tscn")
	elif(scene == 2):
		get_tree().change_scene_to_file("res://Scenes/tutorial_1.tscn")
	elif(scene == 1):
		get_tree().change_scene_to_file("res://Scenes/menu.tscn")
