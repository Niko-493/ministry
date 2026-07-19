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
	#var dialogue = preload("res://scenes/dialogue/dialogue_box1.tscn").instantiate()
	#get_tree().current_scene.add_child.call_deferred(dialogue)
	#for use in level


func show_line():
	portrait.texture = dialogue[current].image
	text.text = dialogue[current].text

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		print("interact")
		current += 1
		
		if current >= dialogue.size():
			queue_free()
		else:
			show_line()
