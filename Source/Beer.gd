extends Area2D

func _ready():
	pass

func _on_Beer_body_entered(_body):
	$Sfx.play()
	$Sprite.hide()
	yield($Sfx, "finished")
	queue_free()
