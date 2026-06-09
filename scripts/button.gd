extends Button

var auto: bool = false
var counter: int = 0

func _ready() -> void:
	$".".pressed.connect(_button_pressed)

func _button_pressed() -> void:
	auto = not auto
	if auto:
		$".".icon = preload("res://res/autoOff.png")
	else:
		$".".icon = preload("res://res/autoOn.png")

func _process(delta: float) -> void:
	counter += 1
	if auto and not counter % Game.delay:
		counter = 0
		Game.drop.emit()
