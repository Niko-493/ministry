extends Node2D

@onready var pause_menu: Control = $PauseMenu


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause_menu.visible = false
	var dialogue = preload("res://scenes/dialogue/dialogue_box1.tscn").instantiate()
	get_tree().current_scene.add_child.call_deferred(dialogue)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause_game"): 
		toggle_pause()

func toggle_pause():
	pause_menu.visible = true
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_un_pause_pressed() -> void:
	pause_menu.visible = false
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _on_return_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	
