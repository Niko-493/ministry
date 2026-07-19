extends CanvasLayer

@onready var text: RichTextLabel = $Panel/RichTextLabel
@onready var portrait: TextureRect = $Panel/TextureRect


var dialogue = [
	{
		"image":preload("res://assets/placeholder1.png"),
		"text": "…"
	},
	{
		"image":preload("res://assets/placeholder2.png"),
		"text": "What is it?"
	},
	{
		"image":preload("res://assets/placeholder1.png"),
		"text": "They killed the priests..."
	},
	{
		"image":preload("res://assets/placeholder2.png"),
		"text": "There is nothing we can do for them now, Keep moving."
	},
	{
		"image":preload("res://assets/placeholder1.png"),
		"text": "...Okay."
	}
]

var current = 0

func _ready() -> void:
	show_line()
	print("Dialogue ready")
	get_tree().paused = true
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
			get_tree().paused = false
		else:
			show_line()
