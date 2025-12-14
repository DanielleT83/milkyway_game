extends Area2D

@export var bullet_speed = 400
var direction = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if direction == Vector2.ZERO:
		return
	position += direction * bullet_speed * delta
	
	# Remove bullet if off-screen
	if position.x < 0 or position.y < 0 or position.x > 1152 or position.y > 648:
		queue_free()
	
	

func _on_body_entered(body: Node):
	if body.is_in_group("mobs"):
		body.queue_free()
		queue_free()
	
