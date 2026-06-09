extends Area2D

func _ready():
	$".".body_entered.connect(_on_body_entered)

func _on_body_entered(body: RigidBody2D) -> void:
	if body.name == "BallBody":
		var ball: Node2D = body.get_parent()
		var money: float = ball.get_meta("Value") * $".".get_parent().get_meta("multiplier")
		Game.money += money
		$CollectSound.play()
		ball.queue_free()
