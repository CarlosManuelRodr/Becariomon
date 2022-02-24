extends Button

func _on_PlayButton_button_down():
	var err = get_tree().change_scene("res://Source/Level.tscn")
	if err:
		print("Failed loading level")
