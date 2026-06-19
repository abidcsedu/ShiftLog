# ShiftLog

A private, **local-only** attendance, work-from-home and leave tracker for a single
employee. No login, no backend, no GPS — every record lives on the device in SQLite.

Built around a **Sunday–Thursday work week** (Friday + Saturday weekend, editable), with a
month-wise **8h 30m per working day** target and a heat-map calendar.

## Features

**Attendance**
- **Sign In / Sign Out** with multiple sessions per day; the day's total is the cumulative
  sum of every session and ticks live (with seconds) while a session is open.
- **Work modes** per session — Office, WFH, Outside Office — chosen from a dropdown.
- **Add / edit / delete** any session, including backfilling past days.

**Limits & balances**
- **WFH limits** — max 2 / month and 12 / year, counted at the day level; Sign In is
  blocked once a cap is hit.
- **Leave** — gender-based yearly allocation (Male 25 / Female 30); log Half (−0.5) or
  Full (−1.0) day.

**Work week & holidays**
- **Weekend** = Friday + Saturday by default, editable in Settings.
- **Monthly target** = expected working days × 8h 30m, where expected days = Sun–Thu,
  minus days you mark as a **Holiday** (office closed) and minus leaves, plus any weekend
  you actually work. The current month counts only up to today.
- **Per-day overrides** — tap a calendar day: a working day can be marked a **Holiday**,
  a weekend can be marked a **Working day** (a swap). Working a weekend overrides its color.

**Insights & history**
- **Insights** — monthly summary (worked vs required, surplus/shortfall, expected days,
  WFH days) with a daily-hours bar chart and target line.
- **History** — a **heat-map calendar** (Sunday-first; weekends gold, holidays rose, worked
  days tinted by hours and override everything; WFH/leave markers) plus a grouped list and
  a leave log.

**App & data**
- Bottom-nav UI (Home / Insights / History / Settings); gradient hero with a goal-oriented
  progress ring; light / dark theme (persisted; follows system by default).
- **Local backup & restore** — JSON export/import (share sheet + file picker) and CSV export.

## Tech stack

| Concern   | Choice |
|-----------|--------|
| Framework | Flutter (Material 3) |
| Local DB  | [Drift](https://drift.simonbinder.eu/) over SQLite (type-safe, reactive) |
| State     | [Riverpod](https://riverpod.dev/) |
| Routing   | [go_router](https://pub.dev/packages/go_router) (`StatefulShellRoute`) |
| Charts    | [fl_chart](https://pub.dev/packages/fl_chart) |
| Sharing   | share_plus · file_picker · path_provider |

## Project structure

```
lib/
  main.dart                 # app entry, theme wiring
  app/router.dart           # bottom-nav shell + routes
  data/
    database.dart           # Drift tables + migrations (schema v4)
    repository.dart          # single data seam over Drift (swap for cloud later)
  domain/
    enums.dart, models.dart # framework-free types
    work_logic.dart         # pure, unit-tested business logic
  state/providers.dart      # Riverpod providers
  ui/
    theme.dart              # Material 3 design system + per-mode visuals
    setup_screen.dart       # first-run (gender / restore backup)
    dashboard_screen.dart   # Home
    monthly_screen.dart     # Insights
    history_screen.dart     # History (calendar + list + leaves)
    settings_screen.dart    # Settings
    backup_actions.dart     # export / import helpers
    widgets/                # CounterCard, ModeChip, ProgressRing, SessionEditor
```

Business logic operates on plain `WorkSession` / `LeaveEntry` models; the repository maps
Drift rows to/from them, so moving to a cloud backend later means reimplementing only
`repository.dart`.

## Run

Prerequisites: Flutter SDK and an Android/iOS device or emulator.

```bash
flutter pub get
dart run build_runner build      # generate Drift code (database.g.dart)
flutter test                     # unit tests for the business logic
flutter run                      # launch on a connected device/emulator
```

> On an Apple-silicon Android emulator, build for arm64:
> `flutter build apk --release --target-platform android-arm64`

## Tests

Pure business logic is unit-tested in `test/` — cumulative daily hours, WFH month/year
caps, holiday balance, calendar-year boundaries, expected working days (weekend / overrides
/ leaves), the monthly target, JSON backup round-trip, and the formatters.

## Branches

- `main` — stable release
- `develop` — integration branch
- `feature/*` — feature branches; open a PR into `develop`, then merge `develop → main` for
  a release (tagged, e.g. `v1.0.0`).
