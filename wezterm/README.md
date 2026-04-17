# Konfigurasi Wezterm Power User

Konfigurasi ini menyediakan setup power-user dengan Ctrl+Space sebagai prefix leader key.

## Setup

```bash
ln -sf ~/dotconfig/wezterm/config.lua ~/.config/wezterm/config.lua
```

## Daftar Shortcut

### Prefix Key
- **Ctrl+Space** - Leader key (timeout 1000ms)

### Navigasi Pane
| Shortcut | Aksi |
|----------|------|
| `Leader + h` | Pane kiri |
| `Leader + j` | Pane bawah |
| `Leader + k` | Pane atas |
| `Leader + l` | Pane kanan |
| `Leader + m` | Toggle pane zoom |

### Split Pane
| Shortcut | Aksi |
|----------|------|
| `Leader + -` | Split vertikal |
| `Leader + \` | Split horizontal |
| `Leader + x` | Tutup pane |

### Navigasi Tab
| Shortcut | Aksi |
|----------|------|
| `Leader + Tab` | Tab berikutnya |
| `Leader + Shift + Tab` | Tab sebelumnya |
| `Leader + t` | Tab baru |
| `Leader + w` | Tutup tab |
| `Leader + 0` | Aktivasi key table number_tab |

### Resize Pane
| Shortcut | Aksi |
|----------|------|
| `Leader + r` | Mode resize pane |

Dalam mode resize:
| Shortcut | Aksi |
|----------|------|
| `h/j/k/l` | Resize 1 kolom/baris |
| `H/J/K/L` | Resize 5 kolom/baris |
| `Escape` | Keluar mode resize |

### Mode Scroll
| Shortcut | Aksi |
|----------|------|
| `Leader + s` | Aktifkan scroll mode |

Dalam mode scroll:
| Shortcut | Aksi |
|----------|------|
| `j/d` | Scroll turun |
| `k/u` | Scroll naik |
| `h` | Scroll kiri |
| `l` | Scroll kanan |
| `g` | Ke paling atas |
| `G` | Ke paling bawah |
| `/` | Mode search |
| `Escape` | Keluar |

### Copy Mode
| Shortcut | Aksi |
|----------|------|
| `Leader + y` | Aktifkan copy mode |

Dalam mode copy:
| Shortcut | Aksi |
|----------|------|
| `v` | Move down |
| `V` | Select line |
| `y` | Copy |
| `h/j/k/l` | Navigasi |
| `w/b` | Word forward/back |
| `0/$` | Awal/akhir baris |
| `Escape` | Keluar |

### Lainnya
| Shortcut | Aksi |
|----------|------|
| `Leader + f` | Search |
| `Leader + f + Shift` | Floating terminal |
| `Leader + Enter` | Tab baru |
| `Leader + ,` | Quick switch |
| `Ctrl + Shift + c` | Copy |
| `Ctrl + Shift + v` | Paste |
| `Ctrl + Shift + t` | Tab baru |
| `Ctrl + 1-9` | Pindah tab |

### Default Key Table
- `resize_pane` - Resize pane
- `scroll_mode` - Scroll mode
- `copy_mode` - Copy mode
- `search_mode` - Search mode
- `number_tab` - Pilih tab 0-9
- `quick_switch` - Quick switch workspace