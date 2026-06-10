extends Area2D

# This script handles gaining money after a ball enters a bin

func _ready():
	$".".body_entered.connect(_on_body_entered) # run _on_body_entered when any body enters the bin

func _on_body_entered(body: RigidBody2D) -> void:
	if body.name == "BallBody": # checks to make sure that the body is a ball
		var ball: Node2D = body.get_parent() # gets the ball root node
		# sets the money to be gained based on ball value and the bins multiplier
		var money: float = ball.get_meta("Value") * $".".get_parent().get_meta("multiplier")
		Game.money += money # gives the player the money
		$CollectSound.play() # play a sound for the ball
		ball.queue_free() # removes the ball from the game
