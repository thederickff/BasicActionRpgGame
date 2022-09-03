extends Node2D

onready var sprite = $Sprite
onready var animatedSprite = $AnimatedSprite

func _ready():
	animatedSprite.visible = false

func _on_animated_sprite_animation_finished():
	queue_free()

func _on_hurtbox_area_entered(area):
	sprite.visible = false
	animatedSprite.visible = true
	animatedSprite.play("default")
