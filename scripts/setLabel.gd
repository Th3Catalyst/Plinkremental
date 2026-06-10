extends Label

# This script handles changing the money label

func set_label(money: float) -> void:
	# changes the money text to reflect the new money value
	$".".text = "Money: $%s " % [int(money)] 
	
func _ready() -> void:
	# run the set_label function when the label_change signal is received (sent by game.gd)
	Game.connect("label_change", set_label)
