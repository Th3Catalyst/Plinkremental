extends LineEdit

func _ready() -> void:
	Game.connect("drop", drop_ball)

func drop_ball() -> void: 
	var bet: float = round(float($".".text)*100)/100
	if Game.money >= bet:
		var ball: Node2D = Game.ball_scene.instantiate()
		var ball_value_mod: float = Game.ball_mods[floor(abs(randfn(0, Game.mod_deviation)))]
		var ball_value: float = bet + ball_value_mod
		var ball_position: Vector2 = Vector2(randfn(Game.center, Game.spacing_h*0.3), Game.top-70) 
		
		if ball_value_mod != 0:
			var mod_label: Label = Label.new()
			mod_label.text = "+" + str(ball_value_mod)
			mod_label.label_settings = load("res://res/modTextStyle.tres")
			mod_label.position = ball_position + Vector2(0, -90)
			$".".get_parent().add_child(mod_label)
			
			var mod_death_timer: Timer = Timer.new()
			mod_death_timer.wait_time = 1.0
			mod_death_timer.timeout.connect(func(): 
				mod_label.queue_free()
				mod_death_timer.queue_free()
			)
			add_child(mod_death_timer)
			mod_death_timer.start()
		
		ball.set_meta("Value", ball_value)
		Game.money -= bet
		$".".get_parent().add_child(ball)
		ball.position = ball_position
		for child in ball.get_child(0).get_children():
			print(type_string(typeof(child)))
			if str(child.name)[-2] == "2":
				child.scale *= Game.spacing_h/110
