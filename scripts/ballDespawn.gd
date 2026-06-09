extends Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".timeout.connect(_on_timer_timeout)


func _on_timer_timeout():
	var ball: Node2D = $".".get_parent().get_parent()
	Game.money += ball.get_meta("Value")
	print("test")
	$".".get_parent().get_parent().queue_free()
