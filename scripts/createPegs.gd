extends Node2D

var peg_scene: PackedScene = preload("res://scenes/peg.tscn")
var ball_scene: PackedScene = preload("res://scenes/ball.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var first_peg: Node2D
	
	for i in range(5):
		for j in range(i+1):
			var peg: Node2D = peg_scene.instantiate()
			add_child(peg)
			
			### if we could make all these magic numbers variables that would be great max ###
			peg.position = Vector2(700-50*i+100*j, 70+100*i)
			
			if i == 0 and j == 0:
				first_peg = peg
	
	Game.pegs_center = first_peg.position.x;

func _input(ev):
	if Input.is_key_pressed(KEY_SPACE):
		var ball: Node2D = ball_scene.instantiate()
		add_child(ball)
		ball.position = Vector2(Game.pegs_center+randf_range(-100,100), 0)
		
