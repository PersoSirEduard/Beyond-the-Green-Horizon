extends StaticBody2D

var dialogBox = load("res://Scripts/UI/DialogBox.tscn").instance()
var label = "Signpost"
var dialog = ["Hey!", "You're finally awake."]

func _on_TriggerBox_area_entered(area):
	dialogBox = load("res://Scripts/UI/DialogBox.tscn").instance()
	var world = get_tree().current_scene
	world.add_child(dialogBox)
	dialogBox.label = label
	dialogBox.dialog = dialog

func _on_TriggerBox_area_exited(area):
	if is_instance_valid(dialogBox):
		dialogBox.closeDialogBox()
