extends CharacterBody2D
@onready var player: CharacterBody2D = $"../player"
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var progress_bar: ProgressBar = $UI/ProgressBar
@onready var collision: CollisionShape2D = $collision
@onready var hurtbox: Area2D = $hurtbox
@onready var hurtbox_collision: CollisionShape2D = $hurtbox/collision
@onready var hitbox: Area2D = $hitbox

var direction : Vector2
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	set_physics_process(false)
	original_collision_offset = collision.position.x
	original_hurtbox_offset = hurtbox.position.x
	original_hitbox_offset = hitbox.scale.x

	
@export var health:= 100
var is_dead = false
func take_damage(damage: int):
	if is_dead == false:
		health -= damage
		print("took ",damage)
		print("vida: ",health)
		if health <= 0:
			hurtbox.monitorable = false
			find_child("FiniteStateMachine").change_state("Death")
			is_dead = true
			
			await get_tree().create_timer(1.5).timeout
			
			get_tree().change_scene_to_file("res://scenes/win_screen.tscn")
			
			
var original_collision_offset
var original_hurtbox_offset
var original_hitbox_offset

func _process(_delta):
	direction = player.position - position

	if direction.x < 0:
		animated_sprite.flip_h = true
		collision.position.x = -original_collision_offset
		hurtbox.position.x = -original_hurtbox_offset
		hitbox.scale.x = -original_hitbox_offset
	else:
		animated_sprite.flip_h = false
		collision.position.x = original_hurtbox_offset
		hurtbox.position.x = original_hurtbox_offset
		hitbox.scale.x = original_hitbox_offset

func _physics_process(delta: float):
	var horizontal_dir = sign(direction.x)
	velocity = Vector2(horizontal_dir * 40, 0)
	move_and_collide(velocity * delta)
	move_and_collide(velocity * delta)
	
