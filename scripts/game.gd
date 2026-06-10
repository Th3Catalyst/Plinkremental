extends Node

# This is the main script, which stores global variables and functions

# references to all the scenes that are instantiated in other scripts
var peg_scene: PackedScene = preload("res://scenes/peg.tscn")
var ball_scene: PackedScene = preload("res://scenes/ball.tscn")
var bin_scene: PackedScene = preload("res://scenes/bin.tscn")

#board variables
var height: float = 1700.0 # board height
var rows: float = 15.0 # rows in the board
var center: float = 3200.0 # center x of the board 
var top: float = 400.0 # top y of the board
# these spacings make equilateral triangles
var spacing_v: float = height/rows # vertical space between rows
var spacing_h: float = spacing_v/sqrt(0.75) # horizontal space between pegs

signal label_change # fires when the money label should change
signal drop # fires when a ball should be dropped
var money: float = 200.0: # player money
	set = set_money # runs set_money when the money is changed
var initial_money: float = money # initial money (used to reset the game)
var delay: int = 400 # autobet delay in frames
var initial_delay: int = delay # initial delay (used to reset the game)

# array of possible modifiers to be added to the ball
var ball_mods: Array[float] = [0.0, 0.5, 1.0, 2.0, 5.0, 8.0, 10.0, 15.0, 25.0, 50.0]
# a copy of the initial list (used to reset the game)
var initial_ball_mods: Array[float] = ball_mods.duplicate() 
# a standard deviation of the random function used to choose from ball_mods
var mod_deviation: float = 1.0 
var initial_mod_deviation: float = mod_deviation # initial deviation (used to reset the game)
# multiplier values for the bins
var mult_vals: Array[float] = [110,41,10,5,3,1.5,1,0.7,0.3,0.3,0.7,1,1.5,3,5,10,41,110]
# a copy of the initial list (used to reset the game)
var initial_mult_vals: Array[float] = mult_vals.duplicate()
var bins: Array[Node2D] = [] # list of bins (populated by createBoard.gd)

# upgrades the multiplier values (Multiplier Value upgrade function)
func upgrade_mults(add_mult: float = 0.5) -> void:
	for i in range(mult_vals.size()): # iterates through the mult_vals
		var val: float = mult_vals[i] # current mult value
		var bin: Node2D = bins[i] # bin the value corresponds to
		val += val * add_mult # increments the multiplier
		mult_vals[i] = val # makes mult_vals reflect that change
		
		bin.set_meta("multiplier",val) # changes the bins multiplier value
		# changes the bin label to reflect the multiplier change
		if val < 100:
			bin.get_child(1).get_child(1).text = str(round(Game.mult_vals[i]*10)/10) + "x"
		else:
			bin.get_child(1).get_child(1).text = str(int(val)) + "x"

# reduces autobet cooldown (Autobet Delay upgrade)
func lower_cooldown() -> void:
	delay *= 0.6 

# makes modifiers worth more and more likely (Modifier Value function) 
func upgrade_mods() -> void:
	# makes each value in the ball mod list 30% greater
	for i in range(1, ball_mods.size()):
		ball_mods[i] = round(ball_mods[i] * 1.6 * 10) / 10
	mod_deviation += 0.7 # makes it more likely to get a higher ball mod
	
# dicitonary containing all upgrades
var upgrades: Dictionary[String,Dictionary] = {
	"Multiplier Value": {
		"cost": 190,
		"effect": upgrade_mults,
		"label": null # label entries are set by createBoard.gd
	},
	"Autobet Delay": {
		"cost": 100,
		"effect": lower_cooldown,
		"label": null
	},
	"Modifier Value": {
		"cost": 300,
		"effect": upgrade_mods,
		"label": null
	}
}
# initial upgrade costs (used to reset the game) 
var initial_costs: Dictionary[String,int] = {
	"Multiplier Value": 190,
	"Autobet Delay": 100,
	"Modifier Value": 300,
}

# runs when the money is changed
func set_money(new_money: float) -> void:
	money = round(new_money*100)/100 # makes sure money stays rounded to two places
	label_change.emit(money) # emits the label_change signal (picked up by setLabel.gd)

func _input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_R): # runs if the R key is pressed
		# the below sets all values back to initial values
		
		money = initial_money
		delay = initial_delay
		
		ball_mods = initial_ball_mods.duplicate()
		mod_deviation = initial_mod_deviation
		mult_vals = initial_mult_vals.duplicate()
		# change the bin labels to the new mult_vals without incrementing mult_vals
		upgrade_mults(0) 
		
		# iterates through the upgrades, resets their cost and changes the label to reflect that
		for key in upgrades:
			var value: Dictionary = upgrades[key]
			value["cost"] = initial_costs[key]
			value["label"].text = key + ": $" + str(value["cost"])
