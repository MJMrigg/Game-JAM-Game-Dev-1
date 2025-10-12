extends CanvasLayer

var score = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	self.get_node("Number").set_text(str(score))
	#print("Current Score ", score)


func updateScore():
	score = score + 1
	#print(score)
	_ready()
	
func deadBody():
	score = score + 15
	#print(score)
	_ready()
	
func wrongTarget():
	score = score + 15
	#print(score)
	_ready()
