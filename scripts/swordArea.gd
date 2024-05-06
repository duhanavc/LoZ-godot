extends Area2D

var speed = 100
var dmg 


func setDamage(damage):
	print(damage)
	dmg = damage


func _on_timer_timeout():
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("enemy"):
		body.dealDamage(dmg)
		

func _physics_process(delta):
	position += transform.x * speed * delta 

