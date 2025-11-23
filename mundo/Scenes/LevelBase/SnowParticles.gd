extends GPUParticles2D

class_name SnowParticles

@export var emission_offset : float = 200.0
var player

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _process(delta: float) -> void:
	if player:
		global_position.x = player.global_position.x
		global_position.y = player.global_position.y - emission_offset
