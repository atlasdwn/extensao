extends CharacterBody2D

class_name Enemy

const GRAVITY: float = 690.0


@onready var sprite: Sprite2D = $Sprite2D
@onready var fall_raycast: RayCast2D = $FallRaycast
@onready var debug_label: Label = $DebugLabel
@onready var attack_detection: Area2D = $AttackDetection
@onready var attack_colision: Area2D = $AttackColision
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var damage_timer: Timer = $DamageTimer

@export var initial_speed : float = 30.0
@export var life : int = 20


var player_is_detected : bool = false
var is_being_hit : bool = false
var is_dead : bool = false
var is_invincible : bool = false

var speed: float = 0.0


func _ready() -> void:
	speed = initial_speed


func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta
	velocity.x = speed if !sprite.flip_h else -speed
	move_and_slide()
	flip()
	fill_debug_text()



func flip() -> void :
	if is_on_wall() or !fall_raycast.is_colliding():
		sprite.flip_h = !sprite.flip_h
		fall_raycast.position.x = -fall_raycast.position.x
		attack_detection.position.x = -attack_detection.position.x
		attack_colision.position.x = -attack_colision.position.x		


func fill_debug_text() -> void:
	debug_label.text = ""
	debug_label.text += "is_on_wall : %s \n" % is_on_wall()
	debug_label.text += "is_colliding : %s \n" % fall_raycast.is_colliding()
	debug_label.text += "player_is_detected: %s" % player_is_detected


func _on_attack_detection_area_entered(_area: Area2D) -> void:
	if player_is_detected: 
		return
	player_is_detected = true
	speed = 0 
	

func _on_attack_detection_area_exited(_area: Area2D) -> void:
	player_is_detected = false
	speed = initial_speed
	
	
func _on_hitbox_area_entered(_area: Area2D) -> void:
	take_damage(10)

	
func go_invincible() -> void:
	if is_invincible:
		return
	is_invincible = true
	var tween : Tween = create_tween()
	for i in range(3):
		tween.tween_property(sprite, "modulate", Color.TRANSPARENT, 0.5)
		tween.tween_property(sprite, "modulate", Color.WHITE, 0.5)
	tween.tween_property(self, "is_invincible", false, 0)
	

func take_damage(amount: int) -> void: 
	if is_invincible or is_dead:
		return
	
	go_invincible()
	apply_hurt_jump()
	life -= amount 
	print("Vida do inimigo: ", life) 
	morte() 

func apply_hurt_jump() -> void:
	is_being_hit = true
	damage_timer.start()


func _on_damage_timer_timeout() -> void:
		is_being_hit = false

func morte() -> void:
	if life <= 0:
		is_dead = true 
		velocity = Vector2.ZERO 
		animation_player.play("death")
		await animation_player.animation_finished
		queue_free()
	

func _on_attack_colision_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
			body.take_damage(10)
