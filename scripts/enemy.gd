extends CharacterBody2D

const SPEED_PATROLI = 40.0
const SPEED_KEJAR = 80.0
const GRAVITY = 900.0
const JARAK_JALAN = 80.0

# Harus file SCENE (.tscn), bukan .gd. Sesuaikan path.
const ITEM_SCENE = preload("res://scenes/item_drop.tscn")

var arah_jalan = 1
var is_dead = false
var player_di_dekat = false
var player_ref: Node2D = null
var posisi_awal = 0.0
var sedang_balik = false

@onready var anim = $AnimatedSprite2D
@onready var deteksi_player = $DeteksiPlayer
@onready var top_hitbox = $TopHitbox

func _ready():
	posisi_awal = global_position.x
	deteksi_player.body_entered.connect(_on_deteksi_player_body_entered)
	deteksi_player.body_exited.connect(_on_deteksi_player_body_exited)
	top_hitbox.body_entered.connect(_on_top_hitbox_body_entered)

func _on_deteksi_player_body_entered(body):
	if body.is_in_group("player"):
		player_di_dekat = true
		player_ref = body

func _on_deteksi_player_body_exited(body):
	if body.is_in_group("player"):
		player_di_dekat = false
		player_ref = null

func _on_top_hitbox_body_entered(body):
	if is_dead:
		return
	if body.is_in_group("player"):
		mati_diinjak()
		if "velocity" in body:
			body.velocity.y = -250.0

func _physics_process(delta):
	if is_dead:
		return

	if not is_on_floor():
		velocity.y += GRAVITY * delta

	if player_di_dekat and is_instance_valid(player_ref):
		kejar_player()
	else:
		patroli()

	if velocity.x < 0:
		anim.flip_h = true
	elif velocity.x > 0:
		anim.flip_h = false

	if anim.sprite_frames and anim.sprite_frames.has_animation("Move"):
		anim.play("Move")

	move_and_slide()

func patroli():
	velocity.x = arah_jalan * SPEED_PATROLI

	if global_position.x > posisi_awal + JARAK_JALAN:
		arah_jalan = -1
	elif global_position.x < posisi_awal - JARAK_JALAN:
		arah_jalan = 1

	if is_on_wall() and not sedang_balik:
		balik_arah()

func kejar_player():
	var selisih = player_ref.global_position.x - global_position.x

	if abs(selisih) > 4.0:
		velocity.x = sign(selisih) * SPEED_KEJAR
	else:
		velocity.x = 0

	if is_on_wall():
		velocity.x = 0

func balik_arah():
	sedang_balik = true
	arah_jalan *= -1
	await get_tree().create_timer(0.2).timeout
	sedang_balik = false

func mati_diinjak():
	is_dead = true
	var nomor = GameManager.musuh_dibunuh()
	drop_item(nomor)
	velocity.x = 0

	if anim.sprite_frames and anim.sprite_frames.has_animation("Die"):
		anim.play("Die")

	$CollisionShape2D.set_deferred("disabled", true)
	top_hitbox.set_deferred("monitoring", false)
	deteksi_player.set_deferred("monitoring", false)

	await get_tree().create_timer(0.5).timeout
	queue_free()

func drop_item(nomor: int):
	var item = ITEM_SCENE.instantiate()
	item.position = global_position + Vector2(0, -10)
	item.nomor_kill = nomor

	# Lempar ke atas dan ke samping acak, sisanya diurus gravitasi item
	var arah_lempar = 1 if randf() > 0.5 else -1
	item.velocity = Vector2(arah_lempar * randf_range(50.0, 90.0), -220.0)

	get_parent().add_child.call_deferred(item)
