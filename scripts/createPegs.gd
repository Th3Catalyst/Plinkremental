extends Node2D

var peg_scene: PackedScene = preload("res://scenes/peg.tscn")
var ball_scene: PackedScene = preload("res://scenes/ball.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(5):
		for j in range(3+i):
			var peg: Node2D = peg_scene.instantiate()
			add_child(peg)
			peg.position = Vector2(700-50*i+100*j, 70+100*i)

func _input(ev):
	if Input.is_key_pressed(KEY_SPACE):
		var ball: Node2D = ball_scene.instantiate()
		add_child(ball)
		ball.position = Vector2(800+randf_range(-100,100), 0)
		
