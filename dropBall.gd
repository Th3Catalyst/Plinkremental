extends LineEdit

func _input(_event: InputEvent) -> void:
	var bet: float = round(float($".".text)*100)/100
	if Input.is_key_pressed(KEY_SPACE) and Game.money >= bet:
		var ball: Node2D = Game.ball_scene.instantiate()
		ball.set_meta("Value", bet) 
		Game.money -= bet
		$".".get_parent().add_child(ball)
		ball.position = Vector2(randfn(Game.center, Game.spacing_h*0.3), Game.top-70)
		for child in ball.get_child(0).get_children():
			child.scale *= Game.spacing_h/100
