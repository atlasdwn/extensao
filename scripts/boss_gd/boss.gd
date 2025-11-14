extends CharacterBody2D
@onready var player: CharacterBody2D = $"../player"
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var progress_bar: ProgressBar = $UI/ProgressBar
@onready var collision: CollisionShape2D = $collision
@onready var hurtbox: Area2D = $hurtbox
@onready var hurtbox_collision: CollisionShape2D = $hurtbox/collision


var direction : Vector2

var health:= 10:
	set (value):
		health = value
		progress_bar.value=value
		if value <= 0:
			progress_bar.visible = false
			find_child("FiniteStateMachine").change_state("Death")

var original_collision_offset
var original_hurtbox_offset

func _ready():
	set_physics_process(false)
	original_collision_offset = collision.position.x
	original_hurtbox_offset = hurtbox.position.x
	
func _process(_delta):
	direction = player.position - position

	if direction.x < 0:
		animated_sprite.flip_h = true
		collision.position.x = -original_collision_offset
		hurtbox.position.x = -original_hurtbox_offset
	else:
		animated_sprite.flip_h = false
		collision.position.x = original_hurtbox_offset
		hurtbox.position.x = original_hurtbox_offset

func _physics_process(delta: float):
	velocity = direction.normalized() * 80
	move_and_collide(velocity * delta)
	

func take_damage():
	health -= 2
