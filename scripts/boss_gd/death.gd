extends State

func enter():
	super.enter()
	animation_player.play("death")
	await animation_player.animation_finished
	owner.queue_free()
