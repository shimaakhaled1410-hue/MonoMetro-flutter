# 🚇 MonoMetro

An **offline-first** transit guide and route planner for **Greater Cairo**: Metro Lines 1, 2 & 3, Monorail East, and the BRT ring. It calculates the best route, the exact multimodal fare, and walking transfers, all without needing mobile data.

Built with **Flutter** and **GetX**, with a feature-first, layered structure. Bilingual (Arabic / English, RTL / LTR) with light and dark themes.

## 📸 App Showcase

### Plan your trip in seconds · Follow every station and transfer
Fastest and fewest-transfer route options with fare, plus a colour-coded step-by-step timeline.

![Trip planning and station timeline](screenshots/Metro_Freelancing_Project_1.png)

### Pick a station easily · Jump to famous landmarks
Search by name or area, browse by line, or choose a landmark and get its nearest station instantly.

![Station picker and landmarks](screenshots/Metro_Freelancing_Project_2.png)

### Fares for your passenger category · Save and review trips
Standard, Seniors 60+ and Special Needs pricing, with a trip history and detailed trip breakdown.

![Passenger categories and trip history](screenshots/Metro_Freelancing_Project_3.png)

### BRT planner · Offline metro map
Plan BRT trips with the same ease, and view the full network map with no internet connection.

![BRT planner and offline metro map](screenshots/Metro_Freelancing_Project_4.png)

---

## ✨ Features

### 🧭 Smart routing
- **Fastest route** (fewest stops + shortest time) and **Comfort route** (fewest line transfers), both calculated for every search so you can compare them.
- Routing runs on a **weighted graph with Dijkstra's algorithm**. Each node is a *(station, line)* pair, so changing lines is an explicit edge with its own cost. That is what makes transfer-aware routing possible: the Comfort mode simply makes a transfer extremely expensive.
- Supports **branching lines** (Line 3 has branches), **loop lines** (BRT ring) and **pedestrian links** between separate networks.
- Walk-aware transfer: the Stadium ↔ Stadium (Monorail) interchange is modelled as a **10-minute walk** and shown as a walking step in the trip, not as a ride.

### 💰 Accurate multimodal fares
- Station-count **fare tiers** per mode:
  - Metro: 10 / 12 / 15 / 20 EGP
  - Monorail East: 20 / 40 / 55 / 80 EGP
  - BRT: 5 – 35 EGP across 7 tiers
- **Passenger categories:** Standard, Seniors 60+ (half fare, rounded up) and Special Needs (flat fare). BRT fares are fixed for all categories.
- Mixed trips are split into **separate tickets per mode** (e.g. Monorail ticket + Metro ticket) and shown as a clear breakdown in route cards and in history.

### 📍 Location-aware & offline-first
- **Nearest station** from GPS using the Haversine formula, with graceful handling of every failure case (location off, permission denied, denied forever, timeout).
- **Offline search** across station names (English + Arabic), plus a directory of **70+ neighbourhoods** and **landmarks** mapped to their nearest station. Arabic search is normalised (diacritics, alef variants, ya / ta marbuta) so users can type naturally.
- Open any station in **Google Maps** with one tap.

### 🗺️ Trip experience
- Vertical **timeline** with intermediate stops, line colours, travel direction ("towards …") and walking instructions.
- **Network overview** map screen for each line.
- Separate BRT planner tab.

### 📜 Trip history
- Save trips locally with an optional destination tag.
- Saved trips store only their station list and are **rebuilt on demand** into full segments, transfers and fares, which keeps history compact.
- Duplicate-route detection.

### 🌍 Personalisation
- Full **Arabic / English** support with RTL layout and locale persistence.
- **Light / Dark** themes, persisted with `shared_preferences`.
- Animated splash screen, onboarding with passenger-category selection, and a "press back twice to exit" flow.

---

## 🛠️ Tech Stack

| Area | Choice |
|---|---|
| Framework | Flutter (Dart `^3.12`) |
| State management & DI | **GetX** (reactive `Rx` state, `Bindings`, tagged controllers per network) |
| Routing engine | Custom **Dijkstra** over a (station, line) state graph |
| Persistence | `shared_preferences` (settings, trip history) |
| Location | `geolocator`, `geocoding` |
| External maps | `url_launcher` |
| Branding | `flutter_launcher_icons` |
| Release build | R8 minification and resource shrinking enabled |

---

## 🏗️ Architecture

```
lib/
├── app/                  # App widget, initial bindings (dependency injection)
├── core/                 # Theme, localization (AR/EN), constants, utilities
├── data/                 # Static network data: lines, stations, fares, landmarks, areas
├── models/               # Station, TransitLine, TripResult, FareBreakdown, TripHistory …
├── services/             # Pure logic, no UI:
│   ├── metro_graph_service.dart      # Graph build + Dijkstra + trip rebuild
│   ├── fare_calculator_service.dart  # Per-mode tiered fares
│   ├── nearest_station_service.dart  # Haversine nearest station
│   ├── station_search_service.dart   # Normalised bilingual search
│   ├── location_service.dart         # GPS + permission handling
│   └── history_service.dart          # Local persistence
└── features/             # Feature-first UI (views, widgets, controllers)
    ├── planner/   ├── brt/   ├── history/
    ├── settings/  ├── onboarding/  └── navigation/
```

**Design decisions**
- **Services hold all the logic** and have no dependency on widgets, so routing and fare calculation can be unit-tested in isolation.
- **One `MetroController` per network** (rail and BRT), created with GetX tags, so both planners share the same graph service, passenger type and history without duplicating code.
- **Network data is declarative** (`LinesData`, `FareData`): adding a station, line or fare tier means editing data, not algorithms.

---

## 🚀 Getting Started

**Prerequisites:** Flutter SDK (Dart ≥ 3.12), Android Studio or VS Code, Git.

```bash
# 1. Clone the repository
git clone https://github.com/shimaakhaled1410-hue/MonoMetro-flutter.git
cd MonoMetro-flutter

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

---

## 👩‍💻 Author

**Shimaa Khaled**, Flutter Developer
[GitHub](https://github.com/shimaakhaled1410-hue)