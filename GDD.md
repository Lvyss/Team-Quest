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
