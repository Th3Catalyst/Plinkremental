extends Timer

# This script handles despawning a ball after 15 seconds have passed, in case a ball gets stuck

func _ready() -> void:
	# run _on_timer_timeout when the ball despawn timer runs out
	$".".timeout.connect(_on_timer_timeout) 


func _on_timer_timeout() -> void:
	var ball: Node2D = $".".get_parent().get_parent() # gets the root node of the ball
	Game.money += ball.get_meta("Value") # returns the money spent on the ball 
	$".".get_parent().get_parent().queue_free() #removes the ball from the game
