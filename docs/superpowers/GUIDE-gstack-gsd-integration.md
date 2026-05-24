# Integrasi GStack × GSD × Superpower

> Panduan orkestrasi tiga sistem untuk workflow agentik yang seamless.

## Filosofi Integrasi

| Sistem | Peran | Metaphor |
|--------|-------|----------|
| **GSD** | Project manager & workflow engine | "Apa yang harus dikerjakan, kapan, dan sejauh mana progress?" |
| **GStack** | Quality gate & technical toolkit | "Apakah ini berfungsi dengan benar? Apakah siap deploy?" |
| **Superpower** | Execution engine | "Eksekusi task satu per satu dengan subagent." |

**Aturan emas:** GSD memutuskan *apa* dan *kapan*. Superpower mengeksekusi *bagaimana*. GStack memverifikasi *apakah benar*.

---

## Alur Kerja Ideal

```
GSD: /gsd-new-project        → Inisialisasi ROADMAP.md + PROJECT.md
GSD: /gsd-plan-phase         → Buat PLAN.md untuk phase aktif

     ↓ (handoff ke execution)

Superpower: subagent-driven-development
            → Eksekusi PLAN.md task-by-task
            → Update checkbox & STATE.md per task

     ↓ (setiap milestone atau task selesai)

GStack: /qa                  → Verifikasi behavioral correctness
GStack: /review              → Code review diff
GStack: /design-review       → (jika ada UI/UX)

     ↓ (semua gate lolos)

GSD: /gsd-verify-work        → Conversational UAT
GStack: /ship                → PR, CHANGELOG, VERSION bump
GStack: /land-and-deploy     → Merge & production verification

     ↓ (sebelum session berakhir)

GStack: /context-save        → Simpan state penuh
```

---

## Skill Routing: Kapan Trigger Apa?

Tambahkan ke `AGENTS.md`:

```markdown
## Skill Routing — Superpower + GStack + GSD

### GSD (Planning & Tracking)
- Inisialisasi proyek baru         → /gsd-new-project
- Lihat progress & next step       → /gsd-progress --next
- Tambah/edit phase di roadmap    → /gsd-phase
- Buat rencana detail phase       → /gsd-plan-phase
- Eksekusi plan terstruktur       → /gsd-execute-phase

### Superpower (Execution)
- Eksekusi PLAN.md task-by-task   → superpowers:subagent-driven-development
- Eksekusi cepat (skip review)    → superpowers:executing-plans

### GStack (Quality Gates)
- Bug / unexpected behavior       → /investigate
- Test site / app behavior        → /qa (test + fix loop)
- Report bugs only (no fix)       → /qa-only
- Code review sebelum merge       → /review
- Visual QA / polish              → /design-review
- Auto-review pipeline            → /autoplan
- Deploy ke production            → /ship atau /land-and-deploy

### Bridge (Session Management)
- Simpan progress session         → /context-save
- Lanjutkan session sebelumnya    → /context-restore
```

---

## Pattern Handoff Optimized

### Pattern 1: Phase Gate (Recommended)
Setiap phase GSD memiliki quality gate sebelum lanjut phase berikutnya.

```markdown
## Phase 3: Implementasi Core Feature

### Pre-execution
- [ ] /gsd-plan-phase → generate PLAN.md
- [ ] /autoplan → review plan dari CEO + Eng + Design + DX perspective

### Execution
- [ ] superpowers:subagent-driven-development → eksekusi PLAN.md

### Quality Gates (per milestone)
- [ ] /qa → behavioral testing
- [ ] /review → diff review
- [ ] /gsd-verify-work → UAT konfirmasi

### Exit Gate
- [ ] /ship → create PR
- [ ] /context-save → archive session
```

### Pattern 2: Continuous Checkpoint
Gunakan saat phase panang (multi-session).

```
Task A selesai → /context-save "feat/auth-login done"
Task B selesai → /context-save "feat/auth-logout done"
...
Phase selesai  → /ship + /context-save "phase-3-complete"
```

### Pattern 3: Context Recovery
Saat session baru dimulai:

```
/context-restore              → Muat state terakhir
/gsd-progress --forensic      → Audit integritas
/gsd-progress --next           → Lanjutkan task berikutnya
```

---

## Anti-Pattern yang Harus Dihindari

| Anti-Pattern | Bahaya | Solusi |
|--------------|--------|--------|
| Superpower eksekusi tanpa GSD plan | Scope creep, task tidak ter tracking | Selalu jalankan /gsd-plan-phase dulu |
| Skip /qa karena "saya yakin" | Regression di production | /qa adalah gate wajib pre-ship |
| Tidak /context-save sebelum break | Kehilangan konteks, duplicate work | /context-save setiap session end |
| GSD phase tanpa exit criteria | Phase tidak pernah selesai | Definisikan /gsd-verify-work criteria di PLAN.md |
| Mix planning & execution dalam 1 session | Cognitive overload, plan tidak tersimpan | Pisahkan: plan session → save → execute session |

---

## Checklist Integrasi untuk Repo Baru

- [ ] Buat `AGENTS.md` dengan skill routing rules (copy dari atas)
- [ ] Buat `ROADMAP.md` via `/gsd-new-project`
- [ ] Konfigurasi continuous checkpoint: `gstack-config set checkpoint_mode continuous`
- [ ] Test end-to-end: buat 1 phase kecil → plan → execute → qa → ship
