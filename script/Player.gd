
extends CharacterBody2D

const SPEED: float = 300.0
const JUMP_VELOCITY: float = -400.0
const MAX_JUMPS: int = 2

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var jumps_left: int = MAX_JUMPS


func _ready() -> void:
	jumps_left = MAX_JUMPS
	play_animation("Idle")


func _physics_process(delta: float) -> void:
	# Gravitasi
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Reset jumlah lompatan saat mendarat
	if is_on_floor():
		jumps_left = MAX_JUMPS

	# Input gerakan
	var direction: float = Input.get_axis("kiri", "kanan")

	if direction != 0.0:
		velocity.x = direction * SPEED
		sprite.flip_h = direction < 0.0
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED)

	# Jump dan Double Jump
	if Input.is_action_just_pressed("Jump") and jumps_left > 0:
		velocity.y = JUMP_VELOCITY
		jumps_left -= 1

		if jumps_left == MAX_JUMPS - 1:
			play_animation("Jump")
		else:
			play_animation("Double_Jump")

	# Update gerakan fisika
	move_and_slide()

	# Atur animasi berdasarkan kondisi karakter
	if not is_on_floor():
		if velocity.y > 0.0:
			# Fall hanya ketika karakter turun
			play_animation("Fall")
		else:
			# Pertahankan animasi lompatan saat naik
			if sprite.animation.strip_edges().to_lower() != "jump" \
			and sprite.animation.strip_edges().to_lower() != "double_jump" \
			and sprite.animation.strip_edges().to_lower() != "wall_jump":
				if jumps_left == MAX_JUMPS - 1:
					play_animation("Jump")
				else:
					play_animation("Double_Jump")
	else:
		# Mendarat: Run jika bergerak, Idle jika diam
		if direction != 0.0 and abs(velocity.x) > 10.0:
			play_animation("Run")
		else:
			play_animation("Idle")


# Memainkan animasi dan mengabaikan spasi di nama
func play_animation(animation_name: String) -> void:
	if sprite.sprite_frames == null:
		return

	var animations: PackedStringArray = \
		sprite.sprite_frames.get_animation_names()

	for anim_name in animations:
		if anim_name.strip_edges().to_lower() == animation_name.strip_edges().to_lower():
			if sprite.animation != anim_name:
				sprite.play(anim_name)
			return
