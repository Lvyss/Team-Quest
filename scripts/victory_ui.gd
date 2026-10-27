extends CanvasLayer

@onready var tombol = $Button

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false

	GameManager.victory.connect(_tampilkan_victory)
	tombol.pressed.connect(_on_button_pressed)

func _tampilkan_victory():
	visible = true
	get_tree().paused = true

	for karakter in [$Rofi, $Eka, $Holil, $Andin]:
		karakter.play()

func _on_button_pressed():
	visible = false
	get_tree().paused = false
	GameManager.reset()
	get_tree().reload_current_scene()
