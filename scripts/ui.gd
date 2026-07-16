extends CanvasLayer

func _ready() -> void:
	var dialogue = preload("res://scenes/dialogue/dialogue_box1.tscn").instantiate()
	get_tree().current_scene.add_child.call_deferred(dialogue)
	
