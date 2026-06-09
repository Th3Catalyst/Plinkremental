extends Node2D

func _ready() -> void:
	# Pegs
	for i in range(Game.rows):
		for j in range(5+i):
			var peg: Node2D = Game.peg_scene.instantiate()
			add_child(peg)
			for child in peg.get_child(0).get_children():
				child.scale *= Game.spacing_h/100
			peg.position = Vector2(
				Game.center-(Game.spacing_h/2)*i+Game.spacing_h*(j-2), 
				Game.top+Game.spacing_v*i
			)

	# Bins
	for i in range(Game.rows+3):
		var bin = Game.bin_scene.instantiate()
		add_child(bin)
		Game.bins.push_front(bin)
		bin.set_meta("multiplier", Game.mult_vals[i])
		if Game.mult_vals[i] < 100:
			bin.get_child(1).get_child(1).text = str(round(Game.mult_vals[i]*10)/10) + "x"
		else:
			bin.get_child(1).get_child(1).text = str(int(Game.mult_vals[i])) + "x"
		bin.position = Vector2(
			Game.center-((Game.rows+2)/2)*Game.spacing_h + Game.spacing_h*i, 
			Game.top+Game.height
		)
	
	# Upgrades
	var label_y: int = 1300
	for upgrade_key in Game.upgrades:
		var value: Dictionary = Game.upgrades[upgrade_key]
		
		var upgrade_label: Label = Label.new()
		upgrade_label.text = upgrade_key + ": $" + str(value["cost"])
		upgrade_label.position = Vector2(259, label_y)
		upgrade_label.label_settings = load("res://res/mainTextStyle.tres")
		add_child(upgrade_label)
		
		var upgrade_button: Button = Button.new()
		
		var button_press: Callable = func(): 
			if Game.money >= value["cost"]:
				Game.money -= value["cost"]
				value["cost"] = int(value["cost"] * 1.3)
				upgrade_label.text = upgrade_key + ": $" + str(value["cost"])
				value["effect"].call()
		
		upgrade_button.icon = load("res://res/upgradeOn.png")
		upgrade_button.position = Vector2(1559, label_y - 10)
		upgrade_button.scale *= 0.25
		upgrade_button.pressed.connect(button_press)
		add_child(upgrade_button)
		
		label_y += 130
		
