extends Node

var peg_scene: PackedScene = preload("res://scenes/peg.tscn")
var ball_scene: PackedScene = preload("res://scenes/ball.tscn")

var money: float

var height: float = 1500.0
var rows: float = 15.0
var center: float = 2900.0
var top: float = 400.0
var spacing_v: float = height/rows
var spacing_h: float = spacing_v/sqrt(0.75)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_SPACE):
		var ball: Node2D = Game.ball_scene.instantiate()
		add_child(ball)
		ball.position = Vector2(center+randf_range(-spacing_h*0.7,spacing_h*0.7), 0)
		for child in ball.get_child(0).get_children():
			child.scale *= spacing_h/100
