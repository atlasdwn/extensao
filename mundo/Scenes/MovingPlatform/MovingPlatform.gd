extends PathFollow2D

class_name MovingPlatform

@export var move_speed : float = 50.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	progress +=  move_speed * delta
	
