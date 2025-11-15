extends State

var can_transition: bool = false
@onready var hitbox: Area2D = $"../../hitbox"

func enter():
	super.enter()
	combo()

func attack(move):
	animation_player.play("attack" + move)
	var overlapping_areas = hitbox.get_overlapping_areas()

	for area in overlapping_areas:
		if area.name=="hurtbox":
			var parent = area.get_owner()
			if parent.name=="player":
				print(area.name)
				print(parent.name,move)

	await animation_player.animation_finished


func combo():
	var move_set = ["1","1","2"]
	for i in move_set:
		await attack(i)


		
func transition():
	if owner.direction.length() > 110:
		get_parent().change_state("Follow")
		


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name=="attack2":
		combo()
