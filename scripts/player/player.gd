extends CharacterBody2D




## DEFININDO OS VALORES DE MOVIMENTACAO
const speed: float = 240.0
const jump_velocity = -400.0
const dash_speed = 500.0
const dash_duration = 0.3
const gravity = 1200.0

## VALORES PRA FLUIDEZ DE MOVIMENTACAO
@export var acceleration: float = 10.0
@export var desaceleration: float = 12.0

## REFERENCIANDO OS NOS DO LADO
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var dash_timer: Timer = $DashTimer
@onready var dash_cooldown_timer: Timer = $DashCooldownTimer
@onready var remote: RemoteTransform2D = $remote
@onready var hitbox: Area2D = $Sprite2D/hitbox
@onready var health_bar: ProgressBar = $UI/health_bar
@onready var hurtbox: Area2D = $hurtbox

## CONDICOES
var is_attacking: bool = false
var is_dashing: bool = false
var can_dash: bool = true
var dash_vector: Vector2 = Vector2.ZERO
var health = 50
var is_dead = false
var hitbox_active: bool = false
var already_hit: bool = false
var original_hitbox_offset

func _ready() -> void:
	health_bar.value = health
	original_hitbox_offset = hitbox.position.x


func follow_camera(camera):
	var camera_path=camera.get_path()
	remote.remote_path=camera_path

func take_damage(damage):
	if is_dead == false:
		health -= damage
		health_bar.value = health
		if health <= 0:

			is_dead = true
			velocity.x = 0
			animation.play("death")
			hurtbox.set_deferred('monitorable', false)
			
			await get_tree().create_timer(1.5).timeout

			get_tree().change_scene_to_file("res://scenes/game_over_screen.tscn")
#NAO TA DASHANDO E NAO TA NO CHAO, TA "CAINDO"
func _physics_process(delta: float) -> void:
	if not is_on_floor() and not is_dashing:
		velocity.y += gravity * delta

	if not is_dead:
		handle_input(delta)

	move_and_slide()
	animate()
## O NOME JA DIZ HANDLE INPUT, EH PRA LIDAR COM AS ENTRADAS DO JOGADOR
func handle_input(delta: float) -> void:
	if is_dashing:
		velocity = dash_vector * dash_speed
		return

	if Input.is_action_just_pressed("attack") and not is_attacking:
		start_attack()

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	var input_direction := Input.get_axis("ui_left", "ui_right")
	if input_direction < 0:
		sprite.flip_h = true
		hitbox.position.x = -original_hitbox_offset
	elif input_direction >0:
		sprite.flip_h = false
		hitbox.position.x = original_hitbox_offset


	#velocity.x = input_direction * speed

	##logica de aceleracao e desaceleracao pra mais fluidez dosmovimentos
	var target_speed = input_direction * speed

	if input_direction != 0:
		velocity.x = lerp(velocity.x, target_speed, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x , 0.0, desaceleration * delta)
	######
	if Input.is_action_just_pressed("dash") and can_dash and not is_dashing:
		start_dash()

## FUNCOES DE ANIMACAO
func animate() -> void:
	if not is_dead:
		if is_dashing:
			if animation.current_animation != "dash":
				animation.play("dash")
			return

		if is_attacking:
			if animation.current_animation != "attack":
				animation.play("attack")
			return

		if not is_on_floor():
			if velocity.y < 0:
				if animation.current_animation != "jump":
					animation.play("jump")
			else:
				if animation.current_animation != "fall":
					animation.play("fall")
			return
			
		if abs(velocity.x) > 10:
			if animation.current_animation != "run":
				animation.play("run")
		else:
			if animation.current_animation != "idle":
				animation.play("idle")


## FUNCAO DA GRAVIDADE, SE


## FUNCAO DE DASH
func start_dash() -> void:
	is_dashing = true
	can_dash = false

	var x_dir := Input.get_axis("ui_left", "ui_right")

	dash_vector = Vector2(x_dir, 0.0).normalized()

	if dash_vector == Vector2.ZERO:
		if sprite.scale.x < 0:
			dash_vector = Vector2.LEFT
		elif !sprite.scale.x > 0:
			dash_vector = Vector2.RIGHT

	dash_timer.start(dash_duration)
	dash_cooldown_timer.start()


func _on_dash_timer_timeout() -> void:
	is_dashing = false
	velocity.x = 0.0 ## AQUI DEFINE QUE DEPOIS DO DASH A VELOCIDADE VAI PRA 0
	## O QUE TIRA AQUELE BUG DE CONTINUAR ANDANDO (ANIMACAO)DEPOIS DO DASH

func _on_dash_cooldown_timer_timeout() -> void:
	can_dash = true
	
func enable_hitbox():
	hitbox_active = true
	already_hit = false  # reset hit for each attack
	hitbox.set_deferred("monitoring", true)
	hitbox.set_deferred("monitorable", true)
	hitbox.get_node("collision").set_deferred("disabled", false)

func disable_hitbox():
	hitbox_active = false
	hitbox.set_deferred("monitoring", false)
	hitbox.set_deferred("monitorable", false)
	hitbox.get_node("collision").set_deferred("disabled", true)

func start_attack() -> void: ########
	is_attacking = true

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name=="attack":
		is_attacking = false
		

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group('enemies') and is_dashing==false:
		take_damage(5)
		print('colidiu')


func _on_hitbox_area_entered(area: Area2D) -> void:
	if not hitbox_active:
		return  # ignore hits when not on valid attack frames

	if area.name == "hurtbox" and area.get_owner().is_in_group('enemies'):
		var enemy = area.get_owner()
		print(enemy)
		if not already_hit:
			enemy.take_damage(10)
			already_hit = true
