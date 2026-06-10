extends Node

var peg_scene: PackedScene = preload("res://scenes/peg.tscn")
var ball_scene: PackedScene = preload("res://scenes/ball.tscn")
var bin_scene: PackedScene = preload("res://scenes/bin.tscn")

var height: float = 1700.0
var rows: float = 15.0
var center: float = 3200.0
var top: float = 400.0
var spacing_v: float = height/rows
var spacing_h: float = spacing_v/sqrt(0.75)

signal label_change
signal drop
var money: float = 200.0:
	set = set_money
var initial_money: float = money
var delay: int = 400 #frames
var initial_delay: int = delay

var ball_mods: Array[float] = [0.0, 0.5, 1.0, 2.0, 5.0, 8.0, 10.0, 15.0, 25.0, 50.0]
var initial_ball_mods: Array[float] = ball_mods.duplicate()
var mod_deviation: float = 1.0
var initial_mod_deviation: float = mod_deviation
var mult_vals: Array[float] = [110,41,10,5,3,1.5,1,0.7,0.3,0.3,0.7,1,1.5,3,5,10,41,110]
var initial_mult_vals: Array[float] = mult_vals.duplicate()
var bins: Array[Node2D] = []


func upgrade_mults(add_mult: float = 0.2) -> void:
	for i in range(mult_vals.size()):
		var val: float = mult_vals[i]
		var bin: Node2D = bins[i]
		val += val * add_mult
		mult_vals[i] = val
		
		bin.set_meta("multiplier",val)
		if val < 100:
			bin.get_child(1).get_child(1).text = str(round(Game.mult_vals[i]*10)/10) + "x"
		else:
			bin.get_child(1).get_child(1).text = str(int(val)) + "x"

func lower_cooldown() -> void:
	delay *= 0.8 

func upgrade_mods() -> void:
	for i in range(1, ball_mods.size()):
		ball_mods[i] = round(ball_mods[i] * 1.3 * 10) / 10
	mod_deviation += 0.4
	

var upgrades: Dictionary[String,Dictionary] = {
	"Multiplier Value": {
		"cost": 190,
		"effect": upgrade_mults,
		"label": null
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
var initial_costs: Dictionary[String,int] = {
	"Multiplier Value": 190,
	"Autobet Delay": 100,
	"Modifier Value": 300,
}


func set_money(new_money: float) -> void:
	money = round(new_money*100)/100
	label_change.emit(money)

func _input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_R):
		money = initial_money
		delay = initial_delay
		
		ball_mods = initial_ball_mods.duplicate()
		mod_deviation = initial_mod_deviation
		mult_vals = initial_mult_vals.duplicate()
		print(initial_mult_vals)
		upgrade_mults(0)
		
		for key in upgrades:
			var value: Dictionary = upgrades[key]
			value["cost"] = initial_costs[key]
			value["label"].text = key + ": $" + str(value["cost"])
