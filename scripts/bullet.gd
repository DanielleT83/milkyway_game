extends Area2D

@export var bullet_speed = 400

var direction = Vector2.ZERO

func _physics_process(delta):
	position.x += bullet_speed * delta
	position.y += bullet_speed * delta
	
#	removes if offscreen:
	if position.x > 1152 or position.x < 0:
		queue_free()
	if position.y > 648 or position.y < 0:
		queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if direction == Vector2.ZERO:
		return
	position += direction * bullet_speed * delta
	
	if position.x < 0 or position.y < 0 or position.x > 1152 or position.y > 648:
		queue_free()
	

func _on_body_entered(body):
	if body.is_in_group("mobs"):
		hide()
		$CollisionPolygon2D.set_deferred("disabled", true)
	
