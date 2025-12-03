extends Area2D

@export var speed = 400

var velocity = Vector2(1,0)

signal kill

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.x * speed * delta
	position += transform.y * speed * delta

func _on_body_entered(body):
	if body.is_in_group("mobs"):
		hide()
		kill.emit()
	
