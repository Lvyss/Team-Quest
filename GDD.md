# 🎮 Project Summary: Team Quest (Micro Game Intro)

**Genre:** 2D Side-Scrolling Platformer
**Engine:** Godot 4
**Tujuan Game:** Mengumpulkan identitas seluruh anggota tim dengan cara mengalahkan musuh dan mengambil _item drop_, lalu mencapai garis finish untuk memenangkan game.

## 🕹️ Core Gameplay Loop

1. Pemain berjalan dan melompat melewati rintangan (TileMap).
2. Pemain menginjak bagian atas musuh untuk mengalahkannya.
3. Musuh yang mati akan menjatuhkan _item_ (kotak/ramuan).
4. Saat item diambil, game akan _pause_ dan menampilkan Pop-up berisi Foto Pixel, Nama, NIM, dan Role anggota.
5. Setelah 4 identitas terkumpul, pemain menyentuh garis finish (musuh ke-5) untuk memicu layar **Victory**.

---

## 🗂️ Struktur Scenes & Scripts

Berikut adalah pembagian kerja (Jobdesk) dan struktur file untuk mempermudah kolaborasi tim:

### 1. Player (`scenes/player.tscn` & `scripts/player.gd`)

- **Isi Scene:** `CharacterBody2D` (Root), `Sprite2D`, `CollisionShape2D`.
- **Fungsi Script:** Mengatur pergerakan kiri-kanan, lompat, gravitasi, dan animasi karakter.

### 2. Enemy (`scenes/enemy.tscn` & `scripts/enemy.gd`)

- **Isi Scene:** `CharacterBody2D` (Root), `Sprite2D`, `CollisionShape2D` (badan), `Area2D` + `CollisionShape2D` (Hitbox khusus di atas kepala untuk diinjak).
- **Fungsi Script:** Membuat musuh berjalan otomatis bolak-balik. Jika Hitbox atas tersentuh Player, musuh hancur, spawn item, dan Player memantul.

### 3. Item Drop (`scenes/item_drop.tscn` & `scripts/item.gd`)

- **Isi Scene:** `Area2D` (Root), `Sprite2D` (gambar kotak/ramuan), `CollisionShape2D`.
- **Fungsi Script:** Mendeteksi jika disentuh Player. Jika disentuh, item hilang dan memicu munculnya Pop-up identitas.

### 4. UI Pop-up (`scenes/ui_popup.tscn` & `scripts/ui_popup.gd`)

- **Isi Scene:** `CanvasLayer` (Root), `ColorRect` (background gelap), `TextureRect` (Foto Pixel), `Label` (Nama, NIM, Role), `Button` (Lanjut).
- **Fungsi Script:** Menerima data dari item, mengubah gambar dan teks, mem-pause game, dan melanjutkan game saat tombol ditekan.

### 5. UI Victory (`scenes/ui_victory.tscn` & `scripts/ui_victory.gd`)

- **Isi Scene:** `Control` (Root), `Label` ("Team Intro Complete!"), `GridContainer` (Menampilkan 4 foto pixel yang sudah dikumpulkan), `Button` (Main Lagi).
- **Fungsi Script:** Menampilkan daftar seluruh anggota tim jika pemain berhasil menyentuh garis finish.

### 6. Main / Level 1 (`scenes/main.tscn` & `scripts/main.gd`)

- **Isi Scene:** `Node2D` (Root), `TileMap` (Tanah & Background), Instance `Player`, 4 Instance `Enemy`, `Area2D` (Finish Trigger).
- **Fungsi Script:** Menyimpan data siapa saja yang identitasnya sudah didapat. Jika garis finish disentuh dan semua identitas terkumpul, panggil UI Victory.

---

## 🎨 Asset yang Dibutuhkan (Jobdesk Artist)

- **Karakter:** Sprite Player (Diam, Jalan, Lompat).
- **Musuh:** 4 Jenis monster berbeda.
- **Item:** Kotak harta karun atau ramuan.
- **Environment:** TileMap tanah dan rumput.
- **UI:** Desain frame pop-up dan 4 Foto anggota tim yang diubah ke gaya _Pixel Art_ (ukuran 64x64 atau 128x128).

---

## 🚀 Alur Kerja Tim (GitHub & Trello)

1.  **Trello:** Dibagi menjadi 3 list (To Do, Doing, Done). Setiap anggota punya kartu tugasnya masing-masing.
2.  **Git Branching:** Tidak ada yang nge-push langsung ke `main`. Wajib bikin branch (contoh: `feature/player-movement`, `feature/ui-popup`, `art/enemy-sprites`).
3.  **Pull Request:** Setelah selesai, ajukan PR ke `main` untuk di-review oleh anggota lain sebelum di-merge.

===================================================================================================================================================

# 🛠️ Technical Guide: Team Quest (Godot 4)

Dokumen ini adalah panduan teknis mendetail untuk implementasi setiap _Scene_ dan _Script_ pada project **Team Quest**. Panduan ini dibuat agar setiap anggota tim dapat mengerjakan bagiannya secara mandiri tanpa kebingungan.

---

## 1. Player (`scenes/player.tscn` & `scripts/player.gd`)

### 📝 Deskripsi Scene

Scene ini adalah karakter utama yang dikendalikan oleh pemain. Player harus bisa berjalan, melompat, dan merespons tabrakan dengan musuh/lingkungan.

### 🌳 Struktur Node (Scene Tree)

- `CharacterBody2D` (Root, nama: **Player**)
  - `Sprite2D` (Visual karakter, gunakan aset pixel art)
  - `CollisionShape2D` (Bentuk kotak/capsule seukuran badan player)
  - `AnimationPlayer` (Untuk animasi idle, walk, jump)

### ⚙️ Detail Script (`player.gd`)

**Tipe Script:** `extends CharacterBody2D`

**Variabel Utama yang Dibutuhkan:**

- `const SPEED = 300.0` (Kecepatan jalan)
- `const JUMP_VELOCITY = -450.0` (Kekuatan lompat)
- `var gravity` (Mengambil nilai dari Project Settings)

**Fungsi Utama:**

- `_physics_process(delta)`:
  - Menerapkan gravitasi (`velocity.y += gravity * delta`) jika tidak menyentuh lantai.
  - Mendeteksi input lompat (`Input.is_action_just_pressed("ui_accept")`).
  - Menggerakkan karakter (`velocity.x = direction * SPEED`).
  - Memanggil `move_and_slide()`.

---

## 2. Enemy (`scenes/enemy.tscn` & `scripts/enemy.gd`)

### 📝 Deskripsi Scene

Musuh yang berjalan otomatis bolak-balik. Memiliki area khusus di kepala yang jika diinjak oleh player, akan memicu kematian musuh dan spawn item.

### 🌳 Struktur Node (Scene Tree)

- `CharacterBody2D` (Root, nama: **Enemy**)
  - `Sprite2D` (Visual monster)
  - `CollisionShape2D` (Hitbox badan, untuk menabrak player dari samping)
  - `Area2D` (Nama: **HitboxAtas** - Area khusus di kepala)
    - `CollisionShape2D` (Bentuk kotak tipis di atas kepala)

### ⚙️ Detail Script (`enemy.gd`)

**Tipe Script:** `extends CharacterBody2D`

**Variabel Utama:**

- `var direction = 1` (Arah jalan, 1 = kanan, -1 = kiri)
- `const SPEED = 100.0`
- `@export var item_to_drop: PackedScene` (Slot untuk memasukkan scene item drop di Inspector)

**Fungsi Utama:**

- `_physics_process(delta)`: Menggerakkan musuh (`velocity.x = direction * SPEED`). Gunakan `RayCast2D` untuk mendeteksi ujung tebing atau tembok, jika kena, balikkan arah (`direction *= -1`).

**Mekanisme Diinjak (Signal Connection):**

- Hubungkan signal `body_entered` dari node `HitboxAtas` ke script ini.
- Jika yang masuk adalah `Player`:
  1. Spawn item: `var item = item_to_drop.instantiate(); get_parent().add_child(item); item.global_position = global_position`
  2. Hapus musuh: `queue_free()`

---

## 3. Item Drop (`scenes/item_drop.tscn` & `scripts/item.gd`)

### 📝 Deskripsi Scene

Kotak atau ramuan yang muncul setelah musuh dikalahkan. Jika diambil, akan memicu UI Pop-up identitas.

### 🌳 Struktur Node (Scene Tree)

- `Area2D` (Root, nama: **ItemDrop**)
  - `Sprite2D` (Visual kotak/ramuan)
  - `CollisionShape2D` (Area sentuh)

### ⚙️ Detail Script (`item.gd`)

**Tipe Script:** `extends Area2D`

**Sinyal Kustom (Custom Signal):**

- `signal item_collected(data_id)` -> _Wajib dideklarasikan di baris paling atas script._

**Fungsi Utama:**

- Hubungkan signal `body_entered` ke script ini.
- Jika Player menyentuh item:
  1. Emit sinyal: `item_collected.emit()` (Bisa disisipi ID unik, misal: 1 untuk anggota 1).
  2. Hapus item dari layar: `queue_free()`.

---

## 4. UI Pop-up Identitas (`scenes/ui_popup.tscn` & `scripts/ui_popup.gd`)

### 📝 Deskripsi Scene

Layar yang muncul tiba-tiba (overlay) saat item diambil. Menghentikan sementara game (pause) dan menampilkan identitas anggota tim.

### 🌳 Struktur Node (Scene Tree)

- `CanvasLayer` (Root, nama: **UIPopup**)
  - `ColorRect` (Background hitam semi-transparan, set ukuran menutupi layar)
  - `TextureRect` (Menampilkan Foto Pixel, set posisi di tengah)
  - `Label` (Teks Nama, NIM, Role, posisikan di bawah foto)
  - `Button` (Teks "Lanjut", posisikan di bawah teks)

### ⚙️ Detail Script (`ui_popup.gd`)

**Tipe Script:** `extends CanvasLayer`

**Fungsi Utama:**

- `func _ready()`: Sembunyikan UI ini saat game pertama kali dimulai (`self.hide()`).
- `func show_popup(foto: Texture2D, nama: String, nim: String)`:
  1. Ubah isi `TextureRect` dan `Label`.
  2. Tampilkan UI (`self.show()`).
  3. Pause game (`get_tree().paused = true`).
- `func _on_button_pressed()`: (Hubungkan dari signal button `pressed`)
  1. Sembunyikan UI (`self.hide()`).
  2. Lanjutkan game (`get_tree().paused = false`).

---

## 5. UI Victory (`scenes/ui_victory.tscn` & `scripts/ui_victory.gd`)

### 📝 Deskripsi Scene

Layar akhir saat pemain menyentuh garis finish setelah mengumpulkan 4 identitas. Menampilkan daftar seluruh anggota tim.

### 🌳 Struktur Node (Scene Tree)

- `Control` (Root, nama: **UIVictory**)
  - `ColorRect` (Background penuh)
  - `Label` (Teks "TEAM KAMI")
  - `GridContainer` (Wadah untuk menaruh foto-foto yang udah didapat)
  - `Button` (Teks "Main Lagi")

### ⚙️ Detail Script (`ui_victory.gd`)

**Tipe Script:** `extends Control`

**Fungsi Utama:**

- `func _ready()`: Pause game dan tampilkan layar.
- `func _on_button_pressed()`: Reload scene utama untuk mulai ulang game (`get_tree().reload_current_scene()`).

---

## 6. Main / Level 1 (`scenes/main.tscn` & `scripts/main.gd`)

### 📝 Deskripsi Scene

Panggung utama tempat semua elemen digabungkan. Mengatur alur game secara keseluruhan.

### 🌳 Struktur Node (Scene Tree)

- `Node2D` (Root, nama: **Main**)
  - `TileMap` (Lantai, tanah, platform)
  - `Player` (Instance dari `player.tscn`)
  - `Enemy1`, `Enemy2`, `Enemy3`, `Enemy4` (Instance dari `enemy.tscn`)
  - `FinishTrigger` (`Area2D` tak terlihat di ujung map)
  - `UIPopup` (Instance dari `ui_popup.tscn`)
  - `UIVictory` (Instance dari `ui_victory.tscn`)

### ⚙️ Detail Script (`main.gd`)

**Tipe Script:** `extends Node2D`

**Variabel Utama:**

- `var total_identitas = 0` (Penghitung berapa item yang udah diambil)

**Fungsi Utama:**

- `func _on_item_collected(foto, nama, nim)`: (Dihubungkan ke sinyal dari item)
  1. Tambah `total_identitas += 1`.
  2. Panggil fungsi `show_popup` di node `UIPopup`.
- `func _on_finish_trigger_body_entered(body)`: (Dihubungkan dari node FinishTrigger)
  1. Jika `body` adalah Player DAN `total_identitas >= 4`: Tampilkan node `UIVictory`.
  2. Jika kurang dari 4: (Bisa tambahkan logika UI peringatan "Identitas belum lengkap!").
