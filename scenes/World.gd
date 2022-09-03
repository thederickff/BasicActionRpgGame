extends Node2D

onready var player = $YSort/Player

func _on_Area2D_body_entered(body):
	player.reset_velocity()
	player.MAX_SPEED = player.MAX_SPEED / 2
	player.set_collision_mask_bit(0, false)
	player.set_can_roll(false)

func _on_Area2D_body_exited(body):
	player.MAX_SPEED = player.MAX_SPEED * 2
	player.set_collision_mask_bit(0, true)
	player.set_can_roll(true)
