# Cue

Convenient desktop wrapper around your personal Apple Music library.

---

## 1. Overview
Cue is a macOS application that signs you in with MusicKit, fetches your on-device / cloud library, and lets you browse albums and play tracks using the native `ApplicationMusicPlayer`.  The codebase follows a clean, layered architecture (Domain ⟷ Data ⟷ Presentation) and is ready to grow without rewrites.

## 2. Current MVP
* Authenticate with Apple Music (first-launch permission prompt).
* Fetch local & cloud library (albums → songs).
* Browse albums in a SwiftUI grid.
* Play any track via system media keys / Control Centre.

## 3. Architecture in Brief
* **Domain Layer** – Pure Swift entities & use-cases, no Apple frameworks.
* **Data Layer** – MusicKit-backed repository (`AppleMusicLibraryRepository`).
* **Presentation** – SwiftUI + MVVM + Flow Coordinator.
* **DI** – Lightweight factory (`AppFactory`) injected via `Environment`.
* **Reactive** – Native `async/await`, Combine only where it adds value.

> See `/Core`, `/Features`, and the diagram in `Docs/architecture.drawio` (soon).

## 4. Project Structure
```
Cue/
├─ App/                  # AppDelegate, entry point
├─ Core/
│  ├─ Domain/            # Entities, Repositories, UseCases
│  └─ Data/              # AppleMusic implementation, cache (future)
├─ Features/             # Library, AlbumDetail, Player …
├─ Resources/            # Assets & localisation
├─ Extensions/
└─ Tests/
```

## 5. Getting Started
1. **Requirements**: macOS 13+, Xcode 15+, active Apple Music subscription for cloud content.
2. ```bash
   git clone https://github.com/your-org/Cue.git && cd Cue
   make bootstrap            # lints + formats via swift-lint & swift-format
   open Cue.xcodeproj        # run the macOS scheme
   ```
3. On first launch macOS will prompt for Apple Music access; choose "OK".

### SPM Dependencies
The project is SPM-only: swift-lint, swift-format, CombineSchedulers, SnapshotTesting (tests).

## 6. Build & Release Pipeline
Fastlane tasks are defined in `/fastlane/Fastfile`:
* `fastlane lint`   – Format & lint (CI gate).
* `fastlane test`   – Run unit + UI tests.
* `fastlane beta`   – Codesign, notarise, upload to TestFlight.
* `fastlane release`– Tag, build, notarise, and create a GitHub release.

CI runs on GitHub Actions (`.github/workflows/ci.yml`).

## 7. Contributing
* Create feature branch → PR.  Each PR must pass `lint` and `test` lanes.
* Commit hooks run swift-lint/format automatically (`.git/hooks/pre-commit`).
* Please keep UI strings in `Resources/Localizable.strings`.

## 8. Roadmap (Post-MVP)
| Priority | Feature                   |
|---------:|---------------------------|
| ⭐️⭐️⭐️ | CoreData cache, offline mode |
| ⭐️⭐️  | Search (catalog + local)     |
| ⭐️⭐️  | Playlist editing             |
| ⭐️     | Menu-bar mini-player        |
| ⭐️     | iOS / iPad Catalyst build   |

## 9. License
Cue is released under the MIT License.  See `LICENSE` for details.
