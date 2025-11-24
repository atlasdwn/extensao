extends State

var can_transition: bool = false

func enter():
	super.enter()
	animation_player.play("teleport")
	await animation_player.animation_finished
	can_transition = true
	
func teleport():
	var new_x = player.position.x + 40
	var current_y = owner.position.y
	owner.position = Vector2(new_x, current_y)
	
func transition():
	if can_transition:
		can_transition = false
		if owner.direction.length() <= 120:
			get_parent().change_state("Attack")
		elif owner.direction.length() > 120:
			get_parent().change_state("Follow")
