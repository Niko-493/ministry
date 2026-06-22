extends CharacterBody2D

@export var speed = 120
@export var friction = 0.4
@export var acceleration = 0.45
@onready var raycast_shoot: RayCast2D = $RaycastShoot
@onready var shoot_sound: AudioStreamPlayer2D = $ShootSound
@onready var reload_sound: AudioStreamPlayer2D = $ReloadSound
@onready var ammo_label: Label = $"../UI/Ammo"
@onready var health_label: Label = $"../UI/Health"
@onready var muzzle_flash: Sprite2D = $MuzzleFlash
@onready var muzzle_flash_timer: Timer = $MuzzleFlashTimer
@onready var enemies = get_tree().get_nodes_in_group("Enemies")
@onready var crosshair: Sprite2D = $Crosshair
@onready var hitmarker_timer: Timer = $HitmarkerTimer
@onready var reload_timer: Timer = $ReloadTimer
@onready var firerate_timer: Timer = $FirerateTimer

var player_health = 100
var ammo = 64
var spare_mag = 4
var is_reloading = false

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
func get_input():
	var input = Vector2()
	
	if Input.is_action_pressed("shoot"):
		for e in enemies:
			if randf() < 0.01:
				e.enemy_idle = false
		if is_reloading == false:
			if firerate_timer.is_stopped():
				if ammo >= 1:
					ammo -= 1
					shoot_sound.pitch_scale = randf_range(0.95, 1.05)
					shoot_sound.play()
					muzzle_flash.visible = true
					muzzle_flash_timer.start()
					firerate_timer.start()
					update_ammo_ui()
					if raycast_shoot.is_colliding():
						var collider = raycast_shoot.get_collider()
						if collider is TileMapLayer:
							pass
						elif collider is CharacterBody2D:
							collider.enemy_health -= 75
							crosshair.modulate = Color.RED
							hitmarker_timer.start()
				
	if Input.is_action_pressed('move_right'):
		input.x += 1
		$AnimatedSprite2D2.play('walk')
	if Input.is_action_pressed('move_left'):
		input.x -= 1
		$AnimatedSprite2D2.play('walk')
	if Input.is_action_pressed('move_down'):
		input.y += 1
		$AnimatedSprite2D2.play('walk')
	if Input.is_action_pressed('move_up'):
		input.y -= 1
		$AnimatedSprite2D2.play('walk')
	
	if Input.is_action_just_pressed("reload"):
		if spare_mag >=1:
			ammo = 64
			spare_mag -= 1
			update_ammo_ui()
			reload_sound.play()
			$AnimatedSprite2D.play('reload')
			is_reloading = true
			reload_timer.start()
			
	return input

func _physics_process(delta):
	var direction = get_input()
	
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * speed, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
	move_and_slide()
	
	if player_health <= 0:
		player_death()
	
func player_death():
	get_tree().reload_current_scene()

func update_ammo_ui():
	ammo_label.text = str(ammo) + " / " + str(spare_mag)
	
func update_health_ui():
	health_label.text = str(player_health)
	
func _on_muzzle_flash_timer_timeout():
	muzzle_flash.visible = false
	
	
func _on_hitmarker_timer_timeout():
	crosshair.modulate = Color.WHITE

func _on_reload_timer_timeout() -> void:
	is_reloading = false
	

func _on_firerate_timer_timeout() -> void:
	firerate_timer.stop()
