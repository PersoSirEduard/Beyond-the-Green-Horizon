# Diary of the game development

* ## Animation of the player
  ![Basic player animations](/Diary/character.gif)
```python
func move_state(delta):
	direction = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		direction.y = -1
	if Input.is_action_pressed("ui_down"):
		direction.y = 1
	if Input.is_action_pressed("ui_right"):
		direction.x = 1
	if Input.is_action_pressed("ui_left"):
		direction.x = -1
	direction = direction.normalized()
	
	if (direction != Vector2.ZERO):
		attackDirection = direction
		animationState.travel("Run")
		animationTree.set("parameters/Run/blend_position", direction)
		animationTree.set("parameters/Idle/blend_position", direction)
		animationTree.set("parameters/Attack/blend_position", direction)
		velocity += direction * ACCELERATION * delta
		velocity = velocity.clamped(MAX_SPEED * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("ui_attack"):
		state = ATTACK
```
* ## Creation of the animated tile-based land with nature
  ![This is where the green comes from](/Diary/animated_nature%20and%20character.gif)
  
* ## Creation of an animated dialog box
  ![Hey...](/Diary/dialogbox.gif)
```python
extends Polygon2D

onready var descriptionBox = $Description
onready var labelBox = $Label
onready var animationPlayer = $AnimationPlayer

var dialog = ["Page 1", "Page 2"]
var label = "Label"
var page = 0

func _ready():
	descriptionBox.set_bbcode(dialog[page])
	descriptionBox.set_visible_characters(0)
	set_process_input(true)
	labelBox.text = label
	animationPlayer.play("FadeIn")
	
func _input(event):
	if event is InputEventMouseButton && event.is_pressed() || Input.is_action_just_pressed("ui_accept"):
		if descriptionBox.get_visible_characters() >= descriptionBox.get_total_character_count():
			if page < dialog.size() - 1:
				page += 1
				descriptionBox.set_bbcode(dialog[page])
				descriptionBox.set_visible_characters(0)
			else:
				closeDialogBox()
		else:
			descriptionBox.set_visible_characters(descriptionBox.get_visible_characters())

func _on_Timer_timeout():
	descriptionBox.set_visible_characters(descriptionBox.get_visible_characters() + 1)
	labelBox.text = label
	descriptionBox.set_bbcode(dialog[page])

func closeDialogBox():
	animationPlayer.play("FadeOut")

func _on_FadeOut_completed():
	queue_free()
```
* ## Creating player collisions and attacks
  ![Chop Chop](/Diary/chop_chop_trees.gif)
  * ### Tree code:
  ```python
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
  ```
* ## Creating creature (Slimes)
  ![Slimy](/Diary/monster_slime.gif)
