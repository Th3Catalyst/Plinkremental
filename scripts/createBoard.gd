extends Node2D

# This script generates all the board components not already placed manually (pegs, bins, upgrades)

func _ready() -> void:
	# these for loops create the pegs on the board
	for i in range(Game.rows):
		for j in range(5+i): # starts the first row off at 5 pegs
			var peg: Node2D = Game.peg_scene.instantiate() # create a copy the peg scene (one peg)
			add_child(peg) # add the peg to the scene (makes it a child of the main root node)
			# scale the sprite and collision box of the peg based on the board size
			for child in peg.get_child(0).get_children():
				child.scale *= Game.spacing_h/100
			
			#position the peg based on where it should be on the board
			peg.position = Vector2(
				Game.center-(Game.spacing_h/2)*i+Game.spacing_h*(j-2), 
				Game.top+Game.spacing_v*i
			)

	# this for loop creates the bins at the bottom of the board
	for i in range(Game.rows+3):
		var bin = Game.bin_scene.instantiate() # create a copy of the bin scene (one bin)
		add_child(bin) # add the bin to the scene (makes it a child of the main root node)
		Game.bins.push_front(bin) # add the bin to a list (used for upgrading bins in game.gd)
		# set the multiplier value of the bin based on the mult_vals list in game.gd
		bin.set_meta("multiplier", Game.mult_vals[i])  
		# cut off the decimals in the bin labels based on their length, 
		# so the text fits in the bin
		if Game.mult_vals[i] < 100:
			# rounds to one decimal
			bin.get_child(1).get_child(1).text = str(round(Game.mult_vals[i]*10)/10) + "x"
		else:
			# rounds to zero decimals
			bin.get_child(1).get_child(1).text = str(int(Game.mult_vals[i])) + "x"
		# positions the bin in the row below the pegs
		bin.position = Vector2(
			Game.center-((Game.rows+2)/2)*Game.spacing_h + Game.spacing_h*i, 
			Game.top+Game.height
		)
	
	# this for loop creates the upgrade labels and buttons
	var label_x: int = 259 # the x coordinate of the top label
	var label_y: int = 1300 # the y coordinate of the top label
	for upgrade_key in Game.upgrades: # iterate through all upgrades in the upgrade list 
		# get the dict containing the cost, effect, and label reference of the upgrade
		var value: Dictionary = Game.upgrades[upgrade_key] 
		
		var upgrade_label: Label = Label.new() # create a new Label object
		# set the text in the label with its name and cost
		upgrade_label.text = upgrade_key + ": $" + str(value["cost"]) 
		upgrade_label.position = Vector2(label_x, label_y) # set the label position
		# style the label to the save style
		upgrade_label.label_settings = load("res://res/mainTextStyle.tres") 
		# add the upgrade label to the scene (makes it a child of the main root node)
		add_child(upgrade_label) 
		# add the label to the upgrade dict, to be referenced in game.gd
		value["label"] = upgrade_label 
		
		var upgrade_button: Button = Button.new() # create a new Button object
		var button_press: Callable = func(): # create the button press function
			if Game.money >= value["cost"]: # checks that the player can afford the upgrade
				Game.money -= value["cost"] # buys it
				value["cost"] = int(value["cost"] * 1.3) # makes it more expensive
				# updates the cost on the label
				upgrade_label.text = upgrade_key + ": $" + str(value["cost"]) 
				value["effect"].call() # runs the function of the button
		
		upgrade_button.icon = load("res://res/upgradeOn.png") # sets the button sprite
		upgrade_button.position = Vector2(label_x + 1300, label_y - 10) # positions it
		upgrade_button.scale *= 0.25 # scales the sprite down to the right size
		# run the button_press function when the button is pressed
		upgrade_button.pressed.connect(button_press) 
		# add the upgrade button to the scene (makes it a child of the main root node)
		add_child(upgrade_button)
		
		label_y += 130 # change label_y so that the future upgrades are below the first one
		
