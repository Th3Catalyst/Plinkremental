extends Area2D

func _ready():
	$".".body_entered.connect(_on_body_entered)

func _on_body_entered(body: RigidBody2D) -> void:
	if body.name == "BallBody":
		var ball: Node2D = body.get_parent()
		Game.money += ball.get_meta("Value") * $".".get_parent().get_meta("multiplier")
		ball.queue_free()
