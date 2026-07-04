extends Control

@onready var rich_text_label: RichTextLabel = $RichTextLabel
@onready var texture_rect: TextureRect = $TextureRect

var dialogue_index := 0
var dialogues = [
	"dialogue1",
	"dialogue2",
	"dialogue3"
]

func _process(delta):
	if Input.is_action_just_pressed("interact"):
		if dialogue_index < dialogues.size():
			rich_text_label.text = str(dialogues[dialogue_index])
			dialogue_index += 1
		else:
			get_tree().change_scene_to_file("res://scenes/main.tscn")
