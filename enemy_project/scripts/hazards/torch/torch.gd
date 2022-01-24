extends Node2D


func _ready():
	$VisibilityNotifier2D.connect("viewport_entered", self, "on_screen_entered")
	$VisibilityNotifier2D.connect("viewport_exited", self, "on_screen_exited")
	$Light2D.visible = true
	$SmokeParticle.emitting = true
#	$VillainDetector.connect("body_entered", self, "destroy_light")


#func destroy_light(body):
#	if body is Villain:
#		body.animationtree.travel("destroy_torch")
#		$AnimationPlayer.play("off")


func on_screen_entered(_viewport):
	self.visible = true
	$SmokeParticle.emitting = true


func on_screen_exited(_viewport):
	self.visible = false
	$SmokeParticle.emitting = false
