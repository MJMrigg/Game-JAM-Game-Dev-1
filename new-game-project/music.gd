extends Node

var ambient_song:AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ambient_song = get_node("Ambient")
	ambient_song.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		if(!ambient_song.playing):
			ambient_song.play()
