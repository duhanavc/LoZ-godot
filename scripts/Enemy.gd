extends CharacterBody2D

var speed = 27
@export var nav : NavigationAgent2D

@export var maxX : float
@export var minX : float
@export var maxY : float
@export var minY : float

var player = null

@onready var visual = $aniSprite

@export var rcArray: Array[RayCast2D]
var targetPos = null

func _ready():
	nav.path_desired_distance = 1.0
	nav.target_desired_distance = 1.0
	call_deferred("actor_setup")
 
func actor_setup():
	await get_tree().physics_frame
	
	setRandomPosition()




func _on_enemy_visible_area_body_entered(body):
	if body.name == "Player":
		player = body


func _on_enemy_visible_area_body_exited(body):
	if body.name == "Player":
		player = null
		setRandomPosition()

func setMovementTarget(targetPos : Vector2):
	nav.target_position = targetPos

func setRandomPosition():
	var random = RandomNumberGenerator.new()
	var rndX = random.randf_range(minX, maxX)
	var rndY = random.randf_range(minY,maxY)
	
	nav.target_position = Vector2(rndX, rndY)

func _physics_process(delta):
	if nav.is_navigation_finished():
		visual.play("idle")
		await get_tree().create_timer(0.5).timeout
		setRandomPosition()
		return
	
	var currentAgentPosition : Vector2 = global_position
	var nextPathPosition : Vector2 = nav.get_next_path_position()
	var direction : Vector2 = currentAgentPosition.direction_to(nextPathPosition)

	var x = snappedi(direction.x, 1)
	var y = snappedi(direction.x, 1)
	var Axis := Vector2(x,y)

	if Axis == Vector2(1,0):
		visual.play("walkRight")
	elif Axis == Vector2(-1,0):
		visual.play("walkLeft")
	elif Axis == Vector2(0,-1):
		visual.play("walkDown")
	elif Axis == Vector2(0,1):
		visual.play("walkUp")

	velocity = currentAgentPosition.direction_to(nextPathPosition) * speed
	move_and_slide()
	

func _process(delta):
	if player != null:
		targetPos= player.global_position
		setMovementTarget(targetPos)


