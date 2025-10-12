extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.hide()

# Go to credits scene
func credits() -> void:
	get_tree().change_scene_to_file("res://Scenes/credits.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if(event.is_action_pressed("close") && self.visible):
		credits()
