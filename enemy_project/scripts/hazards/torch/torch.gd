extends Node2D
class_name Torch

signal state_changed(state)

enum States{OFF, ON}
export (States) var actual_state = States.ON


func _ready():
	$Detector.connect("body_entered", self, "detect_actor")
	update_animation()


func _process(_delta):
	if $VisibilityNotifier2D.is_on_screen():
		self.visible = true
		if actual_state == States.ON:
			$Light2D.enabled = true
			$SmokeParticle.emitting = true
	else:
		self.visible = false
		$Light2D.enabled = false
		$SmokeParticle.emitting = false
	

func update_animation():
	if actual_state == States.ON:
		$AnimationPlayer.play("on")
		$Light2D.enabled = true
		$SmokeParticle.emitting = true
	
	elif actual_state == States.OFF:
		$AnimationPlayer.play("off")
		$Light2D.enabled = false
		$SmokeParticle.emitting = false
	

func detect_actor(body):
	if body is Hero:
		if actual_state == States.OFF:
			$AnimationPlayer.play("on")
			actual_state = States.ON
			$Light2D.visible = true
			emit_signal("state_changed")

