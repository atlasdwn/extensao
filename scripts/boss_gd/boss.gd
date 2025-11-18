extends CharacterBody2D
@onready var player: CharacterBody2D = $"../player"
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var progress_bar: ProgressBar = $UI/ProgressBar
@onready var collision: CollisionShape2D = $collision
@onready var hurtbox: Area2D = $hurtbox
@onready var hurtbox_collision: CollisionShape2D = $hurtbox/collision
@onready var hitbox: Area2D = $hitbox
@onready var ray_cast_2d: RayCast2D = $AnimatedSprite2D/RayCast2D
@export var SPEED: int = 50
@export var CHASE_SPEED: int = 150
@export var ACCELERATION: int = 300

var direction : Vector2
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var right_bounds: Vector2
var left_bounds: Vector2

func _ready():
	set_physics_process(false)
	original_collision_offset = collision.position.x
	original_hurtbox_offset = hurtbox.position.x
	original_hitbox_offset = hitbox.scale.x
	right_bounds = self.position + Vector2(-125,0)
	left_bounds = self.position + Vector2(125,0)
	
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
	velocity = direction.normalized() * 80
	move_and_collide(velocity * delta)
	
