extends CanvasLayer


func _ready():
	GameEvents.connect("fadeout", self, "playanim")


func playanim():
	$Fade/AnimationPlayer.play("fadeout")
