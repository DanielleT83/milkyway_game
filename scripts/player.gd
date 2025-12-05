extends Area2D

signal hit

@export var speed := 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

const CARDINAL_ONLY := false

var can_shoot = true
@onready var bullet_scene = preload("res://scenes/bullet.tscn")
var shoot_dir = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	if screen_size == Vector2.ZERO:
		screen_size = get_viewport().get_visible_rect().size

func _shoot(dir: Vector2):
	if not can_shoot:
		return
	@warning_ignore("shadowed_variable", "confusable_local_usage")
	
	if dir == Vector2.ZERO:
		return
	
	var bullet = bullet_scene.instantiate()
	bullet.position = position
	bullet.direction = dir.normalized()
	get_parent().add_child(bullet)
	
	can_shoot = false
	await get_tree().create_timer(0.4).timeout
	can_shoot = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	var shoot_dir = Vector2.ZERO
	
	if Input.is_action_pressed("move_right") and player_move == true:
		velocity.x += 1
	if Input.is_action_pressed("move_left") and player_move == true:
		velocity.x -= 1
	if Input.is_action_pressed("move_up") and player_move == true:
		velocity.y -= 1
	if Input.is_action_pressed("move_down") and player_move == true:
		velocity.y += 1
	
	if Input.is_action_pressed("shoot_right") and player_move == true:
		shoot_dir.x = 1
	if Input.is_action_pressed("shoot_left") and player_move == true:
		shoot_dir.x = -1
	if Input.is_action_pressed("shoot_up") and player_move == true:
		shoot_dir.y = -1	
	if Input.is_action_pressed("shoot_down") and player_move == true:
		shoot_dir.y = 1
	
	if CARDINAL_ONLY and shoot_dir != Vector2.ZERO:
		if abs(shoot_dir.x) >= Vector2.ZERO:
			shoot_dir.y = 0
			shoot_dir.x = sign(shoot_dir.x)
		else:
			shoot_dir.x = 0
			shoot_dir.y = sign(shoot_dir.y)

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "Walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "Up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
	
	if shoot_dir != Vector2.ZERO:
		_shoot(shoot_dir)

func _on_body_entered(_body: Node2D) -> void:
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	$CollisionShape2D.disabled = false

var player_move = false

func _on_main_begin() -> void:
	player_move = true


func _on_hit() -> void:
	player_move = false
