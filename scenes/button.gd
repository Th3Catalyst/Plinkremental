extends Button

var auto: bool = false
var counter: int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".pressed.connect(_button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _button_pressed() -> void:
	auto = not auto
	if auto:
		$".".icon = preload("res://res/autoOff.png")
	else:
		$".".icon = preload("res://res/autoOn.png")
	
func _process(delta: float) -> void:
	counter += 1
	print(counter)
	if auto and not counter % 100:
		print(auto)
		counter = 0
		Game.drop.emit()
