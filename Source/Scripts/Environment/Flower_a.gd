extends StaticBody2D

export var health = 1

func _ready():
	pass

func _on_HurtBox_area_entered(area):
	health -= area.damage
	print("damaged flower by " + str(area.damage)+ " HP (now " + str(health) + " HP)")
	if (health <= 0):
		queue_free()
