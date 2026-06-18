extends CharacterBody2D

@onready var enemy_raycast: RayCast2D = $EnemyRaycast
@onready var enemy_shoot: AudioStreamPlayer2D = $EnemyShoot
@onready var enemy_notifer: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var Player = get_tree().get_first_node_in_group("Player")
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var enemy_muzzle_flash: Sprite2D = $EnemyMuzzleFlash
@onready var enemy_muzzle_flash_timer: Timer = $EnemyMuzzleFlashTimer


var enemy_health = 100
var enemy_alive = true
var shoot_timer = 0.0
var fire_rate = 0.6
var enemy_speed = 100
var enemy_idle = true

func _ready():
	shoot_timer = randf_range(1.0, fire_rate)

func die():
	enemy_alive = false
	$Sprite2D.texture = preload("res://assets/enemy_dead.png")
	$CollisionShape2D.disabled = true
	$CollisionShape2D2.disabled = true
	print("enemy died")
	

func enemy_fire():
	if randf() < 0.8:
		Player.player_health -= 100

func _physics_process(delta: float) -> void:
	if enemy_alive == true:
		if enemy_health <=0:
			die()
	
	if enemy_notifer.is_on_screen():
		if enemy_alive == true:
			
	 
			look_at(Player.global_position)
			
			shoot_timer -= delta

			var collider = enemy_raycast.get_collider()
			if enemy_raycast.is_colliding():
				if shoot_timer <=0:
					if nav_agent.target_position.distance_to(Player.global_position) > 32:
						if collider is TileMapLayer:
							pass
						elif collider is CharacterBody2D:
							enemy_shoot.play()
							enemy_muzzle_flash.visible = true
							enemy_muzzle_flash_timer.start()
							enemy_fire()
							Player.update_health_ui()
							shoot_timer = fire_rate
			if enemy_idle == true:
				enemy_idle = false
			else:
				pass
							
	if enemy_alive == true:
		if enemy_idle == false:
			var dist = global_position.distance_to(Player.global_position)
			if dist > 100:
				nav_agent.target_position = Player.global_position
				var next_pos = nav_agent.get_next_path_position()
				var direction = (next_pos - global_position).normalized()
				velocity = direction * enemy_speed
				move_and_slide()
			else:
				velocity = Vector2.ZERO
		


func _on_enemy_muzzle_flash_timer_timeout() -> void:
	enemy_muzzle_flash.visible = false
	
