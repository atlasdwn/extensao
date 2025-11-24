extends State

func enter():
	super.enter()

	animation_player.play("death")

	# Espera a anim de morte
	await animation_player.animation_finished

	# TRAVA aqui: impede voltar pra idle
	animation_player.pause()  # melhor que stop()

	# Espera 1 segundo
	await get_tree().create_timer(1.0).timeout

	# Troca de cena
	get_tree().change_scene_to_file("res://scenes/win_screen.tscn")
