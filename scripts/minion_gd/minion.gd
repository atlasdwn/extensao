extends CharacterBody2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var player = get_parent().find_child("player")
@onready var health = 10
@onready var hurtbox: Area2D = $hurtbox

func _ready():
	set_physics_process(false)
	await animation.animation_finished
	set_physics_process(true)
	animation.play("idle")
	
func _physics_process(_delta):
		var direction = player.position - position
		velocity = direction.normalized() * 100
		move_and_slide()

func take_damage(damage):
	health -= damage
	if health <= 0:
		queue_free()

func _on_hurtbox_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.name =="player":
		parent.take_damage(5)
		print('palyer tomou: 5')
		queue_free()
