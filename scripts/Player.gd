extends CharacterBody2D

#region aktarmalar
@export var speed = 45 
@onready var animationPlayer = $AnimationPlayer
@onready var attackCooldown = $attackCooldown
@onready var dealAttackTimer = $dealAttackTimer
@export var sword: PackedScene
#@export var pickUpSword : PackedScene

#endregion

#region Variables
var currentDir = "none"
var attackDetector = false #atak tuşuna basıldı mı basılmadı mı 
var canEnemyAttack = true #düşman saldırı gerçekleştirebilir mi 
var health = 100
var isPlayerAlive = true
var enemyInAttackRange = false # düşman saldırı menzili
#sword
var dmg# fırlatılan kılıcın hasarı.
var amount = 3
var swordPickedUp =false
var currentRoom = 1
#endregion


func player():
	pass

func handleInput():
	
	var moveDir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down" )
	velocity = moveDir * speed

func updateAnim():
	if velocity.length() == 0:
		if attackDetector == false:
			animationPlayer.stop()# 0-45 değer aralığı ;
	else:
		if attackDetector == false:
			var dir = "Up" 
			$HandPos.rotation_degrees = 90
			if velocity.x > 0 :
				dir = "Right" 
				$HandPos.rotation_degrees = 0
			elif velocity.x < 0:
				dir = "Left" 
				$HandPos.rotation_degrees = 180
			elif velocity.y < 0: 
				dir = "Down" 
				$HandPos.rotation_degrees = -90
			animationPlayer.play("walk" + dir)

func shoot():
	var s = sword.instantiate()
	add_child(s)
	s.setDamage(dmg)
	s.transform = $HandPos.transform
	s.position = $HandPos.global_position #handposun anlık pozisyonunu alıyoruz 

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		if amount > 0:
			amount = amount -1
			shoot()

func PlayerAttackAnim(): 
	if Input.is_action_just_pressed("attack"):
		Global.playerCurrentAttack = true
		attackDetector = true
		var dir = currentDir
		if velocity.x > 0 :
			dir = "Right"
			dealAttackTimer.start()
			animationPlayer.play("attack"+ dir)
		elif velocity.x < 0:
			dir = "Left"
			dealAttackTimer.start()
			animationPlayer.play("attack" + dir)
		elif velocity.y > 0:
			dir ="Up"
			dealAttackTimer.start()
			animationPlayer.play("attack" + dir)	
		elif velocity.y < 0:
			dir = "Down"
			dealAttackTimer.start()
			animationPlayer.play("attack" + dir)	

func isAlive():
	if health <= 0:
		isPlayerAlive = false
		health = 0
		self.queue_free()

func _physics_process(delta): #// iki frame arasında geçen süre # fizik sürecine dağir ettiğimiz yer
	handleInput()
	updateAnim()
	move_and_slide()
	PlayerAttackAnim()
	isAlive()
	enemyAttack()
	print(swordPickedUp)

func _on_hit_box_body_entered(body):
	if body.has_method("enemy"):
		enemyInAttackRange = true

func _on_hit_box_body_exited(body):
	if body.has_method("enemy"):
		enemyInAttackRange = false

func enemyAttack(): #düşmanın bize vurması
	if enemyInAttackRange and canEnemyAttack == true:
		health = health - 20
		canEnemyAttack = false
		attackCooldown.start()
		print(health)

func _on_deal_attack_timer_timeout():
	dealAttackTimer.stop()
	Global.playerCurrentAttack = false
	attackDetector = false 

func _on_attack_cooldown_timeout():
	canEnemyAttack = true

func hurt():
	$"../Enemy/AudioStreamPlayer2D".play()
	$"../HUD/hpBar".value -= 0.5
	if $"../HUD/hpBar".value == 0:
		get_tree().reload_current_scene()

func healed():
	if $"../HUD/hpBar".value == 3:
		return false
	else:
		$"../HUD/hpBar".value += 0.5
		return true


func pickSword():
	if amount < 3 :
		amount = amount + 1
		swordPickedUp = true
		$swordReloadTimer.start()


func _on_sword_reload_timer_timeout():
	
	print("sword picked up false oldu")
	

