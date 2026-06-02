extends Node2D

# temporary until formulas are made for this
var mult_vals: Array[float] = [3,41,10,5,3,1.5,1,0.7,0.5,0.5,0.7,1,1.5,3,5,10,41,3]

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
		bin.set_meta("multiplier", mult_vals[i])
		if mult_vals[i] < 1:
			bin.get_child(1).get_child(1).text = str(mult_vals[i]) + "x"
		else:
			bin.get_child(1).get_child(1).text = str(int(mult_vals[i])) + "x"
		bin.position = Vector2(
			Game.center-((Game.rows+2)/2)*Game.spacing_h + Game.spacing_h*i, 
			Game.top+Game.height
		)

func _input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_SPACE):
		$SpaceText.visible = false
