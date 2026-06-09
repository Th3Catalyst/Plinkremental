extends LineEdit

func _ready() -> void:
	Game.connect("drop", drop_ball)

func drop_ball() -> void: 
	var bet: float = round(float($".".text)*100)/100
	if Game.money >= bet:
		var ball: Node2D = Game.ball_scene.instantiate()
		var ball_value_mod: float = Game.ball_costs[floor(randfn(1.8, 0.6))]
		var ball_value: float = bet + ball_value_mod/2
		
		print("ball_value_mod: ", ball_value_mod)
		print("bet: ", bet)
		print("ball_value: ", ball_value)
		
		ball.set_meta("Value", ball_value)
		Game.money -= bet
		$".".get_parent().add_child(ball)
		ball.position = Vector2(randfn(Game.center, Game.spacing_h*0.3), Game.top-70) 
		for child in ball.get_child(0).get_children():
			if type_string(typeof(child)) == "Node2D":
				child.scale *= Game.spacing_h/100
