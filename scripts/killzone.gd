extends Area2D

@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	if body.name =='player':
		print("You died")
		timer.start()


func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/game_over_screen.tscn")
