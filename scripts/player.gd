extends Area2D

signal hit
signal damage(lives_remaining)

var player_move = false
var health = 3

@export var speed := 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

const CARDINAL_ONLY := false

var can_shoot = true
@onready var bullet_scene = preload("res://scenes/bullet.tscn")

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
	
	if Input.is_action_pressed("move_right") and player_move == true:
		velocity.x += 1
	if Input.is_action_pressed("move_left") and player_move == true:
		velocity.x -= 1
	if Input.is_action_pressed("move_up") and player_move == true:
		velocity.y -= 1
	if Input.is_action_pressed("move_down") and player_move == true:
		velocity.y += 1
	
	if Input.is_action_pressed("shoot_right") and player_move == true:
		_shoot(Vector2.RIGHT)
	if Input.is_action_pressed("shoot_left") and player_move == true:
		_shoot(Vector2.LEFT)
	if Input.is_action_pressed("shoot_up") and player_move == true:
		_shoot(Vector2.UP)
	if Input.is_action_pressed("shoot_down") and player_move == true:
		_shoot(Vector2.DOWN)


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

func _on_body_entered(_body: Node2D) -> void:
	if health == 3 or health == 2:
		health -= 1
		damage.emit(health)
	elif health == 1:
		health -= 1
		damage.emit(health)
		hide()
		hit.emit()
		$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	$CollisionShape2D.disabled = false

func _on_main_begin() -> void:
	player_move = true

func _on_hit() -> void:
	player_move = false
