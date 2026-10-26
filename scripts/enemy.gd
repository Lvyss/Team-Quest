extends CharacterBody2D

# Pengaturan gerakan Enemy
@export var patrol_speed: float = 40.0
@export var patrol_distance: float = 60.0
@export var gravity: float = 980.0

# Kekuatan pantulan Player setelah menginjak Enemy
@export var bounce_velocity: float = -280.0

# Diisi ketika scene item drop sudah tersedia
@export var item_scene: PackedScene

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var body_collision: CollisionShape2D = $CollisionShape2D
@onready var top_hitbox: Area2D = $TopHitbox

var start_x: float
var direction: float = 1.0
var dead: bool = false


func _ready() -> void:
	start_x = global_position.x

	top_hitbox.body_entered.connect(
		_on_top_hitbox_body_entered
	)

	if sprite.sprite_frames != null:
		if sprite.sprite_frames.has_animation("move"):
			sprite.play("move")


func _physics_process(delta: float) -> void:
	if dead:
		return

	# Gravitasi
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0.0

	# Gerakan bolak-balik
	velocity.x = patrol_speed * direction

	move_and_slide()

	# Berbalik ketika menyentuh dinding
	if is_on_wall():
		direction *= -1.0

	# Batas patroli kanan
	if global_position.x >= start_x + patrol_distance:
		global_position.x = start_x + patrol_distance
		direction = -1.0

	# Batas patroli kiri
	elif global_position.x <= start_x - patrol_distance:
		global_position.x = start_x - patrol_distance
		direction = 1.0

	# Membalik sprite sesuai arah gerak
	sprite.flip_h = direction < 0.0


func _on_top_hitbox_body_entered(body: Node2D) -> void:
	if dead:
		return

	# Hanya mendeteksi Player
	if not body.is_in_group("player"):
		return

	# Player harus berupa CharacterBody2D
	if body is CharacterBody2D:
		# Velocity positif berarti bergerak ke bawah
		if body.velocity.y > 0.0:
			body.velocity.y = bounce_velocity
			await _die()


func _die() -> void:
	if dead:
		return

	dead = true
	velocity = Vector2.ZERO

	# Matikan collision
	body_collision.set_deferred("disabled", true)
	top_hitbox.set_deferred("monitoring", false)

	# Putar animasi kematian bawaan RVROS
	if sprite.sprite_frames != null:
		if sprite.sprite_frames.has_animation("die"):
			sprite.play("die")
			await sprite.animation_finished
		else:
			await get_tree().create_timer(0.15).timeout
	else:
		await get_tree().create_timer(0.15).timeout

	# Buat item drop jika scene sudah dihubungkan
	if item_scene != null:
		var item: Node = item_scene.instantiate()

		get_parent().add_child(item)

		if item is Node2D:
			item.global_position = global_position

	# Hapus Enemy setelah animasi selesai
	queue_free()
