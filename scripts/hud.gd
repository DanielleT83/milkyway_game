extends CanvasLayer

@onready var lives: HBoxContainer = $HBoxContainer
#Notifies "main" node that the button has been pressed
signal start_game
var heart = preload("res://.godot/imported/Heart Icon.png-8570349ca4f13d2141c49ee1ebb23bbb.ctex")

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	# Wait until the Message Timer has counted down
	await $MessageTimer.timeout
	
	$Message.text = "Dodge the Creeps!"
	$Message.show()
	#Make a one-shot timer and wait for it to finish
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)
	
func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()

func _on_message_timer_timeout():
	$Message.hide()

func _on_player_damage(lives_remaining):
	for i in range(lives.get_child_count()):
		lives.get_child(i).visible = i < lives_remaining
	
