extends Area2D

const GRAVITY = 900.0
const TINGGI = 8.0          # jarak titik tengah item ke dasar
const MASK_TANAH = 1        # layer tempat tile/lantai berada
const JEDA_AMBIL = 0.6      # detik sebelum item bisa diambil

var velocity = Vector2.ZERO # diisi oleh Enemy saat item dilempar
var nomor_kill = 0          # diisi oleh Enemy (kill ke berapa)
var mendarat = false
var sudah_diambil = false
var bisa_diambil = false

func _ready():
	monitoring = true

	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

	# Efek naik-turun pada sprite
	var tween = create_tween().set_loops()
	tween.tween_property($Sprite2D, "position:y", -4.0, 0.5)
	tween.tween_property($Sprite2D, "position:y", 4.0, 0.5)

	# Setelah jeda, item boleh diambil
	await get_tree().create_timer(JEDA_AMBIL).timeout
	bisa_diambil = true

	# Cek player yang sudah berdiri di atas item saat jeda selesai
	for body in get_overlapping_bodies():
		_on_body_entered(body)

func _physics_process(delta):
	if mendarat:
		return

	velocity.y += GRAVITY * delta
	var dari = global_position
	var ke = dari + velocity * delta

	if velocity.y > 0:
		var query = PhysicsRayQueryParameters2D.create(dari, ke + Vector2(0, TINGGI))
		query.collision_mask = MASK_TANAH
		query.collide_with_areas = false
		var exclude = []

		for i in 4:
			query.exclude = exclude
			var hasil = get_world_2d().direct_space_state.intersect_ray(query)
			if hasil.is_empty():
				break
			if hasil.collider is CharacterBody2D:
				exclude.append(hasil.rid)
				continue
			global_position = Vector2(ke.x, hasil.position.y - TINGGI)
			mendarat = true
			return

	global_position = ke

func _on_body_entered(body):
	if sudah_diambil or not bisa_diambil:
		return
	if body.name == "Player" or body.is_in_group("player"):
		sudah_diambil = true
		print("ITEM DIAMBIL!")
		GameManager.item_diambil(nomor_kill)
		queue_free()
