extends CharacterBody2D

@onready var enemy_raycast: RayCast2D = $EnemyRaycast
@onready var enemy_shoot: AudioStreamPlayer2D = $EnemyShoot
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var enemy_muzzle_flash: Sprite2D = $EnemyMuzzleFlash
@onready var enemy_muzzle_flash_timer: Timer = $EnemyMuzzleFlashTimer
@onready var enemy_reaction_timer: Timer = $EnemyReactionTimer
@onready var enemy_fire_timer: Timer = $EnemyFireTimer
@onready var detection_range: Area2D = $DetectionRange
@onready var attack_range: Area2D = $AttackRange
@onready var Player = get_tree().get_first_node_in_group("Player")
@onready var enemy_detect_raycast: RayCast2D = $EnemyDetectRaycast


var enemy_health = 100
var enemy_speed = 100
var enemy_shot_delay = false
var enemy_reaction_delay = false
var player_in_range = false

enum State {IDLE, CHASE, ATTACK, DEAD}
var current_state = State.IDLE
	
func _ready() -> void:
	enemy_reaction_timer.start()

func _physics_process(delta: float) -> void:
	match current_state:
		State.IDLE:
			idle_state()
		State.CHASE:
			chase_state(delta)
		State.ATTACK:
			attack_state(delta)
		State.DEAD:
			dead_state()
			
	if enemy_health <= 0:
		current_state = State.DEAD
		
		
	enemy_detect_raycast.target_position = Player.global_position - enemy_detect_raycast.global_position
	enemy_detect_raycast.force_raycast_update()
	var collider = enemy_detect_raycast.get_collider()
	if collider == Player:
		if player_in_range == true:
			if current_state == State.IDLE:
				current_state = State.CHASE
	
	
func idle_state():
	velocity = Vector2.ZERO
	
	
func chase_state(delta):
	look_at(Player.global_position)		
	nav_agent.target_position = Player.global_position
	var next_pos = nav_agent.get_next_path_position()
	var direction = (next_pos - global_position).normalized()
	velocity = direction * enemy_speed
	move_and_slide()
	$AnimatedSprite2D2.play('walk')
	$AnimatedSprite2D.play("aiming")

func attack_state(delta):
	look_at(Player.global_position)
	var collider = enemy_raycast.get_collider()
	enemy_reaction_timer.start()
	print("reaction timer started")
	if enemy_shot_delay == false:
		if collider == Player:
			enemy_shoot.play()
			enemy_muzzle_flash.visible = true
			enemy_muzzle_flash_timer.start()
			enemy_fire_timer.start()
			Player.update_health_ui()
			enemy_shot_delay = true
			if randf() < 0.5:
				Player.player_health -= 50		
				Player.update_health_ui()
							
func dead_state():
	$AnimatedSprite2D.play('dead')
	$AnimatedSprite2D2.play('idle')
	$CollisionShape2D.disabled = true
	$CollisionShape2D2.disabled = true
	
	

func _on_detection_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_range = true


func _on_attack_range_body_entered(body: Node2D) -> void:
	if current_state == State.CHASE:
		if body.is_in_group("Player"):
			current_state = State.ATTACK

func _on_attack_range_body_exited(body: Node2D) -> void:
	if current_state == State.ATTACK:
		if body.is_in_group("Player"):
			current_state = State.CHASE


func _on_enemy_muzzle_flash_timer_timeout() -> void:
	enemy_muzzle_flash.visible = false
	

func _on_enemy_fire_timer_timeout() -> void:
	enemy_shot_delay = false
	

func _on_enemy_reaction_timer_timeout() -> void:
	pass
