extends Node2D

## Ambil referensi node UI dan Finish Trigger
#@onready var ui_popup = $PopupUI 
#@onready var ui_victory = $VictoryUI
#@onready var finish_trigger = $FinishTrigger
#
## Variabel buat ngitung udah dapet berapa identitas
#var identitas_terkumpul = 0
#
#func _ready():
	## Sambungin sinyal kalau Player nyentuh garis finish
	#if finish_trigger:
		#finish_trigger.body_entered.connect(_on_finish_masuk)
#
## Fungsi ini bakal dipanggil sama si Item Drop
#func tampilkan_identitas():
	#identitas_terkumpul += 1
	#print("Dapet identitas ke-", identitas_terkumpul)
	#
	## Munculin UI Pop-up (Sementara teksnya static, nanti bisa diganti per anggota)
	#ui_popup.tampilkan_popup("Budi", "123456")
#
## Fungsi kalau Player nyentuh garis finish
#func _on_finish_masuk(body):
	#if body.name == "Player":
		#if identitas_terkumpul >= 4:
			#ui_victory.tampilkan_victory()
		#else:
			#print("Belum bisa menang, identitas kurang! Baru dapet: ", identitas_terkumpul)
