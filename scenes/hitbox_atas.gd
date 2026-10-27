extends Area2D

func _ready():
	# Ini wajib biar bisa deteksi tabrakan
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# Cek kalau yang nabrak itu Player
	if body.name == "Player":
		# Panggil fungsi mati di musuh
		get_parent().mati_diinjak()
		# Bikin player mantul ke atas
		body.velocity.y = -300 
