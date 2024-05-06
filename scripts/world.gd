extends Node2D

@export var pickUpSword : PackedScene

@export var playerScript = "res://scripts/Player.gd"




func _on_sword_reload_timer_timeout():
		var pps = pickUpSword.instantiate()
		print("içerideki timmer")
		add_child(pps)
		var swordPick = get_parent().get_node("SwordPickup")
		pps.transform = swordPick.transform
