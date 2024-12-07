extends Node2D

@export var value: int = 100
@onready var animation : AnimatedSprite2D = $AnimatedSprite2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		GameController.xp_collected(value)
		self.queue_free()

func _ready() -> void:
	animation.play("idle")
