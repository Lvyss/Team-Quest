extends CanvasLayer


@onready var label = $Label
@onready var sprite = $AnimatedSprite2D
@onready var tombol = $Button

var posisi_dasar = Vector2.ZERO

func _ready():
	print("PopupUI siap")
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	posisi_dasar = sprite.position

	# Cegah tombol dobel terpicu (klik Enter pada tombol yang fokus)
	tombol.focus_mode = Control.FOCUS_NONE

	GameManager.identitas_didapat.connect(_tampilkan)
	tombol.pressed.connect(_tutup)

func _unhandled_input(event):
	if not visible:
		return
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
			get_viewport().set_input_as_handled()
			_tutup()

func _tampilkan(data):
	print("popup dipanggil: ", data.nama)
	label.text = data.nama + "\n" + data.deskripsi

	sprite.scale = Vector2.ONE * data.get("skala", 1.0)
	sprite.position = posisi_dasar + data.get("offset", Vector2.ZERO)

	if sprite.sprite_frames and sprite.sprite_frames.has_animation(data.animasi):
		sprite.play(data.animasi)
	else:
		push_warning("Animasi tidak ditemukan: " + data.animasi)

	visible = true
	get_tree().paused = true

func _tutup():
	visible = false
	get_tree().paused = false
	GameManager.popup_ditutup()
