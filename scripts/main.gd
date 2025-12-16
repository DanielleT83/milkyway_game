extends Node

@export var mob_scene: PackedScene
var score

@export var bullet_scene: PackedScene

@onready var player = $Player
@onready var hud = $HUD

signal begin

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.damage.connect(hud._on_player_damage)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func game_over():
	$Music.stop()
	$DeathSound.play()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	
func new_game():
	$Music.play()
	score = 0
	$Player.start($StartPosition.position)
	$Player.show()
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("bullets", "queue_free")
	


func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()
	
	#Choose a random location on Path2D
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	#Set mob's position to random location
	mob.position = mob_spawn_location.position
	
	#Set mob's direction perpendicular to path direction
	var direction = mob_spawn_location.rotation + PI / 2
	
	#Add randomness to direction
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	#Choose velocity
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	#Spawn mob
	add_child(mob)

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	begin.emit()
