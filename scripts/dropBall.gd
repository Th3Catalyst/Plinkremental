extends LineEdit

# This script handles the dropping of the balls, plus getting mod and bet amounts

func _ready() -> void:
	# run drop_ball when the drop signal is received (from button.gd)
	Game.connect("drop", drop_ball) 

func drop_ball() -> void: 
	# gets the bet amount rounded to two decimals (also removes any letters in it)
	var bet: float = round(float($".".text)*100)/100 
	# checks to make sure player can afford it and bet is worth money
	if Game.money >= bet and bet > 0: 
		var ball: Node2D = Game.ball_scene.instantiate() # makes a copy of the ball scene (one ball)
		# picks a random modifier for the ball (weighted towards the low end of the list)
		var ball_value_mod: float = Game.ball_mods[floor(abs(randfn(0, Game.mod_deviation)))]
		var ball_value: float = bet + ball_value_mod # sets the new ball value with modifier
		# picks a random spot at the top of the board to drop the ball 
		# (weighted towards the center)
		var ball_position: Vector2 = Vector2(randfn(Game.center, Game.spacing_h*0.3), Game.top-70) 
		
		if ball_value_mod != 0: # shows the modifier only if it isnt zero
			var mod_label: Label = Label.new() # creates a new label
			mod_label.text = "+" + str(ball_value_mod) # sets the text to the mod value
			mod_label.label_settings = load("res://res/modTextStyle.tres") # styles the label
			mod_label.position = ball_position + Vector2(0, -90) # positions it above the ball
			$".".get_parent().add_child(mod_label) # makes it a child of the main root node
			
			# creates a one second despawn timer for the label
			var mod_death_timer: Timer = Timer.new()
			mod_death_timer.wait_time = 1.0
			mod_death_timer.timeout.connect(func(): 
				mod_label.queue_free()
				mod_death_timer.queue_free()
			)
			add_child(mod_death_timer)
			mod_death_timer.start()
		
		ball.set_meta("Value", ball_value) # set the balls value to ball_value
		Game.money -= bet # subtract the bet amount
		$".".get_parent().add_child(ball) # makes the ball a child of the main root node
		ball.position = ball_position # positions the ball from ball_position
		# scales the balls sprite and body based on the size of the board
		for child in ball.get_child(0).get_children():
			if str(child.name)[-2] == "2": # scales everything but the Timer node
				child.scale *= Game.spacing_h/110
