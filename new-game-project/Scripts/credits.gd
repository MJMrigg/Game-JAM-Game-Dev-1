extends Control

var credits_song:AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	credits_song = get_node("Credits Song")
	credits_song.play()

func _process(delta: float) -> void:
	# If the player pressed escape, bring up the quit menu
	if(Input.is_action_just_pressed("p_menu")):
		get_node("quit_menu").show()
	# Quit when the song stops playing
	if(!credits_song.playing):
		get_node("quit_menu").quit()
	# Roll the credits
	if(get_node("ColorRect/Credits").position.y > -950):
		get_node("ColorRect/Credits").position.y -= 1
