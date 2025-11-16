extends CharacterBody2D

class_name EnemyBase

@export var points: int = 1
@export var speed: float = 30.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var _gravity: float = 800.0
var _player_ref: Player

#dfunc _ready() -> void:
	#if _player_ref == null:
	#	queue_free()
		

func flip_me() -> void:
	animated_sprite_2d.flip_h = \
		_player_ref.global_position.x > global_position.x
		
	
func die() -> void:
	set_physics_process(false)
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	pass # Replace with function body.


func _on_hit_box_area_entered(_area: Area2D) -> void:
	die()
