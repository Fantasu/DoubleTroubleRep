extends CanvasLayer

onready var bars_animation_player = $BlackBars/AnimationPlayer


func _ready():
	$BlackBars.visible = true
	GameEvents.connect("call_bars", self, "on_bars_called")
	
	
func on_bars_called(type:int):
	match type:
		0:
			bars_animation_player.play("close_bars")
		1:
			bars_animation_player.play("open_bars")
