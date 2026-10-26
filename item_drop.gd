
extends Area2D

signal item_collected(title: String, description: String)

@export var item_title: String = "Memory Fragment"
@export_multiline var item_description: String = "Kamu menemukan sebuah Memory Fragment!"

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var collected: bool = false


func _ready() -> void:
	animated_sprite.play("idle")
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if collected:
		return

	if not body.is_in_group("player"):
		return

	collected = true
	collision_shape.set_deferred("disabled", true)

	item_collected.emit(item_title, item_description)
	queue_free()
