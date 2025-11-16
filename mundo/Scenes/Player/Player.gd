extends CharacterBody2D

class_name Player

const GRAVITY: float = 690.0
const MAX_FALL_VELOCITY: float = 350.0
const HURT_JUMP_VELOCITY : Vector2 = Vector2(0, -130)

@onready var player_camera: Camera2D = $PlayerCamera
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var state_machine: AnimationNodeStateMachinePlayback = \
			$AnimationTree["parameters/playback"]
@onready var debug_label: Label = $Control/DebugLabel
@onready var hurt_timer: Timer = $HurtTimer


@export var _jump_speed: float = -300.0
@export var _run_speed: float = 150.0
@export var camera_min : Vector2i = Vector2i(0, 0)
@export var camera_max : Vector2i = Vector2i(10000, -10000)
@export var _is_atacking: bool = false

var _is_hurt : bool = false
var _is_atack_type_1 : bool = false
var _is_invincible : bool = false

func _ready() -> void:
	set_camera_limits()
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
	#	velocity += get_gravity() * delta	
	velocity.y += GRAVITY * delta
	get_input()	
	#clamp velocity in y to prevent faster fall	
	velocity.y = clampf(velocity.y, _jump_speed, MAX_FALL_VELOCITY)
	move_and_slide()	
	update_debug_label()
	
func get_input() -> void:
	if _is_hurt:
		return
		# jump
	if is_on_floor() and Input.is_action_just_pressed("jump") == true:
		velocity.y = _jump_speed   
		#play_effect(JUMP)
	#move	
	velocity.x = _run_speed * Input.get_axis("moveLeft", "moveRight")
	if not is_equal_approx(velocity.x, 0):
		sprite_2d.flip_h = velocity.x < 0
	process_atack()
		
func update_debug_label() -> void:
	var debug_string = ""
	debug_string += "Floor:%s\n" % [is_on_floor()]
	debug_string += "V: %.1f, %.1f\n" % [velocity.x, velocity.y]
	debug_string += "P: %.1f, %.1f\n" %[global_position.x, global_position.y]
	debug_string += "Atacking: %s, hurt: %s, animation: %s" % [_is_atacking, _is_hurt, state_machine.get_current_node()]
	debug_label.text = debug_string
		
func process_atack() -> void :
	if Input.is_action_pressed("atack1"): 
		_is_atacking = true	
		_is_atack_type_1 = true
		
	if Input.is_action_pressed("atack2"):
		_is_atacking = true	
		_is_atack_type_1 = false
		
	
func receive_hit() -> void : 
	if _is_invincible:
		return
	go_invincible()
	apply_hurt_jump()
	_is_atacking = false

	
func apply_hurt_jump() -> void:
	_is_hurt = true
	velocity = HURT_JUMP_VELOCITY
	hurt_timer.start()
	#play_effect(DAMAGE)

func go_invincible() -> void:
	if _is_invincible:
		return
	_is_invincible = true
	var tween : Tween = create_tween()
	for i in range(3):
		tween.tween_property(sprite_2d, "modulate", Color.TRANSPARENT, 0.5)
		tween.tween_property(sprite_2d, "modulate", Color.WHITE, 0.5)
	tween.tween_property(self, "_is_invincible", false, 0)

func set_camera_limits() -> void:
	player_camera.limit_left = camera_min.x
	player_camera.limit_bottom = camera_min.y
	player_camera.limit_top = camera_max.y
	player_camera.limit_right = camera_max.x

	
func _on_hit_box_area_entered(_area: Area2D) -> void:
	receive_hit()


func _on_hurt_timer_timeout() -> void:
	_is_hurt = false
