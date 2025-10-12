extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#self.hide()
	get_node("ColorRect").hide()
	get_node("ColorRect2").hide()

# Go to credits scene
func credits() -> void:
	get_tree().change_scene_to_file("res://Scenes/credits.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if(event.is_action_pressed("close") && (get_node("ColorRect").visible || get_node("ColorRect2").visible)):
		credits()
