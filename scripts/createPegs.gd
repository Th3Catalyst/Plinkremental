extends Node2D

var height: int = 1500
var rows: int = 15
var center: int = 2900
var top: int = 400
var spacing_v: float = height/rows
var spacing_h: float = spacing_v/sqrt(0.75)


func _ready() -> void:
	Game.pegs_center = center
	
	for i in range(rows):
		for j in range(3+i):
			var peg: Node2D = Game.peg_scene.instantiate()
			add_child(peg)
			for child in peg.get_child(0).get_children():
				child.scale *= spacing_h/100
			peg.position = Vector2(center-(spacing_h/2)*i+spacing_h*(j-1), top+spacing_v*i)

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_SPACE):
		$SPACE_text.visible = false
		var ball: Node2D = Game.ball_scene.instantiate()
		add_child(ball)
		ball.position = Vector2(center+randf_range(-spacing_h*0.7,spacing_h*0.7), 0)
		for child in ball.get_child(0).get_children():
			child.scale *= spacing_h/100
		
