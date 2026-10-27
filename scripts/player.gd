extends CharacterBody2D

# Pengaturan Fisika
const SPEED = 250.0
const JUMP_VELOCITY = -320.0
const DOUBLE_JUMP_VELOCITY = -380.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Variabel status
var jump_count = 0
const MAX_JUMPS = 2
var is_dead = false

@onready var anim = $AnimatedSprite2D

func _physics_process(delta):
	if is_dead:
		return

	# 1. Gravitasi
	if not is_on_floor():
		velocity.y += gravity * delta

	# 2. Reset jumlah lompat
	if is_on_floor():
		jump_count = 0

	# 3. Logika Lompat
	if Input.is_action_just_pressed("Jump"):
		if jump_count < MAX_JUMPS:
			if jump_count == 0:
				velocity.y = JUMP_VELOCITY
			else:
				velocity.y = DOUBLE_JUMP_VELOCITY
				anim.play("Double_Jump")
			jump_count += 1

	# 4. Logika Jalan
	var direction = Input.get_axis("kiri", "kanan")
	if direction:
		velocity.x = direction * SPEED
		if direction > 0:
			anim.flip_h = false
		else:
			anim.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# 5. Animasi Jalan/Loncat
	if anim.animation != "Double_Jump" or is_on_floor():
		if not is_on_floor():
			if velocity.y < 0:
				anim.play("Jump")
			else:
				anim.play("Fall")
		elif direction != 0:
			anim.play("Run")
		else:
			anim.play("Idle")

	# 6. Eksekusi gerakan
	move_and_slide()


func mati():
	if is_dead: return

	print("Player Mati!")
	is_dead = true

	if anim and anim.sprite_frames.has_animation("Hit"):
		anim.play("Hit")

	velocity = Vector2.ZERO

	await get_tree().create_timer(1.0).timeout

	GameManager.reset()   # reset hitungan kill saat mati
	get_tree().reload_current_scene()
