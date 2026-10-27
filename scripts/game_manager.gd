extends Node

signal victory
signal identitas_didapat(data)

const TARGET_KILL = 5

# GANTI path ini: klik kanan file .tscn di FileSystem -> Copy Path
const POPUP_SCENE = preload("res://scenes/popup_ui.tscn")
const VICTORY_SCENE = preload("res://scenes/victory_ui.tscn")

var identitas_list = [
	{"nama": "Rofi", "deskripsi": "240533610013", "animasi": "Rofi", "skala": 1.4, "offset": Vector2(0, 0)},
	{"nama": "Eka", "deskripsi": "240533605728", "animasi": "Eka", "skala": 0.4, "offset": Vector2(0, 0)},
	{"nama": "Holil", "deskripsi": "240533603507", "animasi": "Holil", "skala": 2.1, "offset": Vector2(0, 0)},
	{"nama": "Andin", "deskripsi": "240533604808", "animasi": "Andin", "skala": 1.4, "offset": Vector2(0, 0)},
]

var antrian = []
var jumlah_kill = 0

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS   # <-- baru, biar ESC jalan saat pause
	reset()
	_buat_ui.call_deferred()

func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ESCAPE:
			get_tree().quit()
			
func _buat_ui():
	var layer = CanvasLayer.new()
	layer.layer = 100
	layer.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(layer)
	layer.add_child(POPUP_SCENE.instantiate())
	layer.add_child(VICTORY_SCENE.instantiate())
	print("UI dibuat oleh GameManager")

func reset():
	jumlah_kill = 0
	antrian = identitas_list.duplicate()
	antrian.shuffle()

# Mengembalikan nomor kill ini (1, 2, 3, ...)
func musuh_dibunuh() -> int:
	jumlah_kill += 1
	print("Kill: ", jumlah_kill, "/", TARGET_KILL)
	return jumlah_kill

func item_diambil(nomor_kill: int):
	print("item diambil, dari kill ke-", nomor_kill)
	if nomor_kill >= TARGET_KILL:
		victory.emit()
		return

	if antrian.is_empty():
		antrian = identitas_list.duplicate()
		antrian.shuffle()
	identitas_didapat.emit(antrian.pop_back())

# Masih dipanggil PopupUI, tidak perlu melakukan apa-apa
func popup_ditutup():
	pass
