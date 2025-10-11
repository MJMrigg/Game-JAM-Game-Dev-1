extends Label

var score = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = String(score)


func points():
	score = score + 1
	_ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
