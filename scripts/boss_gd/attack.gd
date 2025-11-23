extends State

var can_transition: bool = false
@onready var hitbox: Area2D = $"../../hitbox"
var hitbox_active: bool = false
var already_hit: bool = false


func enter():
	super.enter()
	combo()


func enable_hitbox():
	hitbox_active = true
	already_hit = false  # reset hit for each attack
	hitbox.set_deferred("monitoring", true)
	hitbox.set_deferred("monitorable", true)
	hitbox.get_node("CollisionShape2D").set_deferred("disabled", false)

func disable_hitbox():
	hitbox_active = false
	hitbox.set_deferred("monitoring", false)
	hitbox.set_deferred("monitorable", false)
	hitbox.get_node("CollisionShape2D").set_deferred("disabled", true)



func attack(move):
	animation_player.play("attack" + move)
	await animation_player.animation_finished  # still needed



func combo():
	var move_set = ["1","1","2"]
	for i in move_set:
		await attack(i)


		
func transition():
	if owner.direction.length() > 110:
		get_parent().change_state("Follow")
	if player.is_dead == true:
		get_parent().change_state('Win')
		


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name=="attack2":
		combo()


func _on_hitbox_area_entered(area: Area2D) -> void:
	if not hitbox_active:
		return  # ignore hits when not on valid attack frames

	if area.name == "hurtbox" and area.get_owner() == player:

			if not already_hit:
				player.take_damage(10)
				already_hit = true
