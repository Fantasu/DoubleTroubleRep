extends ActorManager


func _ready():
	GameEvents.connect("actor_stuned", self, "on_stun_trade")


func on_stun_trade(actor):
	if actor is Hero and not villain._actual_state == villain.STATE_STUNED:
		change_to_villain()
	
	elif actor is Villain and not hero._actual_state == hero.STATE_STUNED:
		change_to_hero()
	
	else:
		get_tree().reload_current_scene()

