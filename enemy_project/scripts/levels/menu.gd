extends Control

export (PackedScene) var cutscene


func _ready():
	$CenterContainer/MarginContainer/VBoxContainer/Button.grab_focus()
	$CenterContainer/MarginContainer/VBoxContainer/Button.connect("button_down", self, "start_game")
	$CenterContainer/MarginContainer/VBoxContainer/Button2.connect("button_down", self, "quit_game")


func change_scene():
	get_tree().change_scene_to(cutscene)

func start_game():
#	$AudioBlip.play()
	$AnimationPlayer.play("play")
	
func quit_game():
#	$AudioBlip.play()
	get_tree().quit()
