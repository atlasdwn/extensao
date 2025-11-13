extends Node2D

@onready var camera: Camera2D = $camera
@onready var player: CharacterBody2D = $player

func _ready() -> void:
	player.follow_camera(camera)

func _process(_delta: float) -> void:
	pass
