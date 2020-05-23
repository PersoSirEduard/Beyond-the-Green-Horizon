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
