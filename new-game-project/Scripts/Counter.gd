extends CanvasLayer

var score = 0
var update = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.get_node("Number").set_text(str(score))
	#print("Current Score ", score)

func _process(delta: float) -> void:
	if (score >= 100):
		get_node("../win_menu/ColorRect2").show()


func stop() -> void:
	update = false;

func updateScore():
	if(!update):
		return
	score = score + 1
	#print(score)
	_ready()
	
func deadBody():
	if(!update):
		return
	score = score + 15
	#print(score)
	_ready()
	
func wrongTarget():
	if(!update):
		return
	score = score + 15
	#print(score)
	_ready()
