# Mobile FPS Aim Trainer (Godot)

A complete **Aimlab-style Gridshot aim trainer** built from scratch in **Godot 4.x**.  
This project focuses on core FPS aim-training mechanics with clean visuals and mobile/PC support.

The goal of this project is learning, experimentation, and building a solid technical foundation for FPS-style aim trainers.

![alt text](https://github.com/DevStrikerTech/Mobile-FPS-Aim-Trainer/blob/main/aim_trainer.gif?raw=true)

---

## 🎯 Project Overview

This aim trainer replicates the **core feel of Aimlab Gridshot**:

- Fixed center crosshair
- Camera-based aiming (not cursor aiming)
- Raycast-based hit detection
- Single active target at a time
- Randomized target positions
- Score, timer, and accuracy tracking
- End-of-session summary screen

Designed to work on:
- **PC (mouse input)**
- **Mobile (touch input)**

---

## ✨ Features

### Gameplay
- Fixed **center crosshair**
- **Mouse look** (PC)
- **Touch look** (Mobile)
- Shoot using **screen center**
- Gridshot-style target spawning
- Single-weapon setup
- Static training arena

### Scoring System
- Score increases on every hit
- Total shots tracked
- Accuracy calculated as:
  ```
  (hits / shots) * 100
  ```

### UI
- Live score counter
- Countdown timer
- Live accuracy display
- Full-screen end screen overlay
- Final score and accuracy shown clearly

### Visuals
- Minimalist arena (floor, walls, ceiling)
- Simple glowing targets
- Hit animation using tweens
- Clear contrast between targets and environment

---

## 🕹 Controls

### PC
- **Mouse Move** – Aim (camera rotation)
- **Left Click** – Shoot
- **ESC** – Release mouse cursor

### Mobile
- **Drag Finger** – Aim
- **Tap Screen** – Shoot

---

## 🧠 How Aiming Works

- The crosshair is **always fixed at screen center**
- Player aims by rotating the camera
- Shooting always fires a ray from screen center
- Cursor is hidden and locked during gameplay

This matches how professional aim trainers function.

---

## 🧩 Scene Structure

```
Main (Node3D)
├── Camera3D
├── WorldEnvironment
├── Targets
├── UI
│   ├── ScoreLabel
│   ├── TimerLabel
│   ├── AccuracyLabel
│   ├── Crosshair
│   └── EndScreen
│       └── EndBox
│           ├── TitleLabel
│           ├── FinalScoreLabel
│           └── FinalAccLabel
├── Floor
├── Ceiling
└── DirectionalLight3D
```

---

## 📜 Scripts

### `main.gd`
Handles:
- Camera look logic (mouse & touch)
- Cursor capture and release
- Raycasting and hit detection
- Target spawning
- Score, timer, and accuracy logic
- End screen display

### `target.gd`
Handles:
- Target hit animation
- Target cleanup after hit

---

## 🛠 Built With

- **Godot Engine 4.5.x**
- **GDScript**
- Forward+ Renderer

---

## 🚀 Future Improvements

Optional ideas for expansion:
- Restart button
- Difficulty modes
- Moving targets
- Target size variation
- Sensitivity settings menu
- Sound effects & hit markers
- Session history / stats tracking

---

## 📌 Notes

This project was built as a **learning-focused prototype**.  
The visuals are intentionally minimal to emphasize mechanics and performance.

---

## 📄 License

MIT

---

Happy aiming 🎯
