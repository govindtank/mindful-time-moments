# 🌿 Mindful Time Moments

> A beautiful Flutter web mindfulness and meditation app — track your mood, breathe, meditate, and relax.

[![Deploy](https://github.com/govindtank/mindful-time-moments/actions/workflows/deploy.yml/badge.svg)](https://github.com/govindtank/mindful-time-moments/actions)
[![Flutter](https://img.shields.io/badge/Flutter-3.24.0-blue?logo=flutter)](https://flutter.dev)
[![Platform](https://img.shields.io/badge/Platform-Web-cyan?logo=google-chrome)](https://govindtank.github.io/mindful-time-moments/)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

**🌐 Live Demo:** [https://govindtank.github.io/mindful-time-moments/](https://govindtank.github.io/mindful-time-moments/)

---

## ✨ Features

### 🧘 Meditation Timer
- Customizable session durations (3, 5, 10, 15, 20, 30 minutes)
- Visual countdown with pulsing animation
- Start, pause, and reset controls
- Session completion celebration

### 🌬️ Breathing Exercises
- **Box Breathing** (4-4-4-4) — balance and calm
- **4-7-8 Relaxing** — deep relaxation
- **Energizing** (2-4) — quick energy boost
- **Calm** (6-6) — extended peaceful breathing
- Animated visual circle guide

### 📊 Mood Tracker
- 5-level mood scale with emoji indicators
- Optional notes for each entry
- 7-day mood trend chart
- Recent entries history
- Persistent local storage

### 🎵 Relaxation Zone
- Ambient sound visualization
- 6 sound types (Rain, Ocean, Wind, Fire, Forest, Space)
- Live audio wave visualizer
- Daily affirmations

### 🎨 Design
- Beautiful gradient backgrounds
- Material 3 design system
- Smooth animations (fade-in, scale, slide)
- Fully responsive for web
- Calming color palette (purples, teals, blues)

---

## 📂 Project Structure

```
lib/
├── main.dart                 # Entry point
├── app.dart                  # App config & navigation
├── models/
│   └── mood_entry.dart       # Mood data model
├── services/
│   └── mood_service.dart     # Mood persistence
├── screens/
│   ├── home_screen.dart      # Dashboard
│   ├── meditation_screen.dart # Meditation timer
│   ├── breathing_screen.dart  # Breathing exercises
│   ├── mood_tracker_screen.dart # Mood tracking
│   └── relaxation_screen.dart  # Relaxation zone
└── widgets/
    ├── animated_card.dart    # Animated card widget
    └── gradient_background.dart # Gradient backgrounds
```

---

## 🛠️ Tech Stack

- **Flutter 3.24.0** (Web)
- **Material 3** Design System
- **Provider** for state management
- **fl_chart** for mood visualization
- **shared_preferences** for local persistence
- **google_fonts** (Poppins font family)
- **GitHub Actions** for CI/CD

---

## 🚀 Getting Started

```bash
# Clone the repository
git clone https://github.com/govindtank/mindful-time-moments.git
cd mindful-time-moments

# Install dependencies
flutter pub get

# Run locally
flutter run -d chrome

# Build for web
flutter build web --release --base-href /mindful-time-moments/
```

---

## 🔄 CI/CD Pipeline

Every push to `main` automatically:
1. Checks out the latest code
2. Sets up Flutter 3.24.0
3. Installs dependencies
4. Builds the web app
5. Deploys to GitHub Pages

---

## 📱 Screenshots

| Home | Meditation | Breathing |
|------|-----------|-----------|
| Feature dashboard | Timer with animations | Pattern selector |
| Mood tracker | 7-day chart | Relaxation |

---

## 📄 License

MIT License — feel free to use and modify!

---

*Made with 💜 using Flutter*
