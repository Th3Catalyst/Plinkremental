extends Button

# This script handles all functions related to the Autobet button

var auto: bool = false # Whether or not autobet is on
var counter: int = 0 # a frame counter

func _ready() -> void:
	# run _button_pressed when the autobet button is pressed
	$".".pressed.connect(_button_pressed) 

func _button_pressed() -> void:
	auto = not auto  # toggles autobet
	if auto: # change the autobet button sprite to reflect the other auto state
		$".".icon = preload("res://res/autoOff.png")
	else:
		$".".icon = preload("res://res/autoOn.png")

func _process(delta: float) -> void: 
	counter += 1 # increment the counter every frame
	# once the delay is over and auto is on, reset the counter
	# and send the drop ball signal (picked up by dropBall.gd)
	if auto and counter >= Game.delay: 
		counter = 0
		Game.drop.emit()
