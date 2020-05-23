extends StaticBody2D

export var health = 100

onready var animationPlayer = $AnimationPlayer

func _ready():
	pass

func _on_HurtBox_area_entered(area):
	health -= area.damage
	animationPlayer.play("Shake")
	print("damaged tree by " + str(area.damage)+ " HP (now " + str(health) + " HP)")
	if (health <= 0):
		queue_free()
		var world = get_tree().current_scene
		var choppedTree = load("res://Scripts/Environment/Chopped_Tree.tscn").instance()
		world.get_node("YSort").add_child(choppedTree)
		choppedTree.global_position = global_position
