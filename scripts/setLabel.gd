extends Label


func set_label(money: float) -> void:
	$".".text = "Money: $%s " % [int(money)]
	
func _ready() -> void:
	Game.connect("label_change", set_label)
