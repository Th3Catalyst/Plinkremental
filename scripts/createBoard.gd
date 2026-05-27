extends Node2D

func _ready() -> void:
	# Pegs
	for i in range(Game.rows):
		for j in range(3+i):
			var peg: Node2D = Game.peg_scene.instantiate()
			add_child(peg)
			for child in peg.get_child(0).get_children():
				child.scale *= Game.spacing_h/100
			peg.position = Vector2(Game.center-(Game.spacing_h/2)*i+Game.spacing_h*(j-1), Game.top+Game.spacing_v*i)
			
	# Bins
	for i in range(Game.rows+3):
		var bin = Game.bin_scene.instantiate()
		add_child(bin)
		bin.position = Vector2(
			Game.center-((Game.rows+2)/2)*Game.spacing_h + Game.spacing_h*i, 
			Game.top+Game.height
		)

func _input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_SPACE):
		$SPACE_text.visible = false
