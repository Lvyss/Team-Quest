extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# Cuma peduli kalau yang nabrak punya fungsi "mati" (yaitu Player)
	if body.has_method("mati"):
		body.mati()
