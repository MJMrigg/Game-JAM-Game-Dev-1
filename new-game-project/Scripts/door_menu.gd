extends Control

func _ready() -> void:
	self.hide()
	
# Open the menu(Good for signals)
func open() -> void:
	self.show()

# Close the menu(Also good for signals)
func close() -> void:
	self.hide()

# If the player presses a key
func _unhandled_input(event: InputEvent) -> void:
	if(event.is_action_pressed("close")): # Close the menu
		close()
	if(event.is_action_pressed("quit") && self.visible): # Quit the game if menu is open
		get_tree().quit()
