extends CanvasLayer

@onready var text: RichTextLabel = $Panel/RichTextLabel
@onready var portrait: TextureRect = $Panel/TextureRect


var dialogue = [
	{
		"image":preload("res://assets/sampletext.png"),
		"text": "test 1"
	},
	{
		"image":preload("res://assets/sampletext.png"),
		"text": "test 2"
	},
	{
		"image":preload("res://assets/sampletext.png"),
		"text": "test 3"
	}
]

var current = 0

func _ready() -> void:
	show_line()
	print("Dialogue ready")

func show_line():
	portrait.texture = dialogue[current].image
	text.text = dialogue[current].text

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		current += 1
		
		if current >= dialogue.size():
			queue_free()
		else:
			show_line()
