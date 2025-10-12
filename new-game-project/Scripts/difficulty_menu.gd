extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.hide()
	
func open() -> void:
	self.show()

func play() -> void:
	get_tree().change_scene_to_file("res://Scenes/Morgan_Creek.tscn")

func easy() -> void:
	Global.difficulty = 100
	play()

func medium() -> void:
	Global.difficulty = 50
	play()

func hard() -> void:
	Global.difficulty = 10
	play()
