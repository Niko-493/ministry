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
		"text": "test 1"
	},
	{
		"image":preload("res://assets/sampletext.png"),
		"text": "test 1"
	}
]

var current = 0

func _ready() -> void:
	show_line()

func show_line():
	portrait.texture = dialogue[current].image
	text.text = dialogue[current].text
