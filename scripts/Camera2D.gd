extends Camera2D


@export var player : CharacterBody2D
@onready var size : Vector2i = get_viewport_rect().size

func _ready():
	updatePosition()
	
func _physics_process(delta):
	updatePosition()
	
func updatePosition():
	var currentCell : Vector2i = Vector2i(player.global_position) / size
	global_position = currentCell * size
