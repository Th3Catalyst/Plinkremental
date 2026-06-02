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

signal label_change
var money: float = 200:
	set = set_money

func set_money(new_money: float) -> void:
	money = round(new_money*100)/100
	label_change.emit(money)
