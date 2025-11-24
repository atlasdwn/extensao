extends State

func _enter_tree():
	randomize()

func enter():
	super.enter()
	animation_player.play("follow")
	owner.set_physics_process(true)
	
func exit():
	super.exit()
	owner.set_physics_process(false)

func transition():
	if owner.direction.length() < 120:
		get_parent().change_state("Attack")
	elif owner.direction.length() > 380:
		var chance = randi() % 2
		match chance:
			0:
				get_parent().change_state("Summon")
			1:
				get_parent().change_state("Teleport")
