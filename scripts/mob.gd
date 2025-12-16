extends RigidBody2D

@onready var bullet_scene = preload("res://scenes/mobBullet.tscn")

var dir_options = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]

@onready var bullet_timer: Timer = $Timer
var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.randomize()
	start_random_timer()
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = mob_types.pick_random()
	$AnimatedSprite2D.play()
			
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _shoot(dir: Vector2):
	if dir == Vector2.ZERO:
		return
		
	var bullet = bullet_scene.instantiate()
	bullet.add_to_group("bullets")

	bullet.position = global_position + dir
	bullet.direction = dir.normalized()
	
	get_parent().add_child(bullet)

func start_random_timer():
	var min_time = 0.4
	var max_time = 4.0
	
	var random_time: float = rng.randf_range(min_time, max_time)
	
	bullet_timer.wait_time = random_time
	bullet_timer.one_shot = true
	bullet_timer.start()
	
func _on_timer_timeout():
	var dir = dir_options.pick_random()
	_shoot(dir)
	start_random_timer()
