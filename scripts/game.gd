extends Node

var peg_scene: PackedScene = preload("res://scenes/peg.tscn")
var ball_scene: PackedScene = preload("res://scenes/ball.tscn")
var bin_scene: PackedScene = preload("res://scenes/bin.tscn")

var height: float = 1500.0
var rows: float = 15.0
var center: float = 2900.0
var top: float = 400.0
var spacing_v: float = height/rows
var spacing_h: float = spacing_v/sqrt(0.75)
var bet: float = 10

signal label_change
var money: float = 200:
	set = set_money

func set_money(new_money: float) -> void:
	money = new_money
	label_change.emit(money)


func _input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_SPACE) and money >= bet:
		var ball: Node2D = Game.ball_scene.instantiate()
		ball.set_meta("Value", bet) 
		money -= bet
		add_child(ball)
		ball.position = Vector2(randfn(center, spacing_h*0.3), top-70)
		for child in ball.get_child(0).get_children():
			child.scale *= spacing_h/100
