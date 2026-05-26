extends Node2D

func _ready() -> void:
	for i in range(Game.rows):
		for j in range(3+i):
			var peg: Node2D = Game.peg_scene.instantiate()
			add_child(peg)
			for child in peg.get_child(0).get_children():
				child.scale *= Game.spacing_h/100
			peg.position = Vector2(Game.center-(Game.spacing_h/2)*i+Game.spacing_h*(j-1), Game.top+Game.spacing_v*i)

func _input(_event: InputEvent) -> void:
	# i dont like putting this here because this script is
	# for creating the pegs and this does something completely different
	# but putting this in game.gd makes it not work
	# and i have no idea why
	if Input.is_key_pressed(KEY_SPACE):
		$SPACE_text.visible = false
