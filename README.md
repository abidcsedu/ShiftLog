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
- **Project / ticket tagging** — tag a session to a project/client/ticket; a selector on
  Home tags the next sign-in, the editor autocompletes from past projects, and Insights
  breaks down monthly hours **by project**.
- **Add / edit / delete** any session (with an optional note), including backfilling past days.
- **Break-even time** — while clocked in, Home shows "Leave by 6:42 PM" to hit the target.
- **Forgot-to-clock-out** — a session open over 16h shows a banner to end it.
- **Home-screen widget** — shows today's office time and a Sign In / Sign Out button that
  toggles the session in the background, without opening the app.

**Office hours & schedule**
- **Office hours** (start/end times) define the daily target; **Ramadan mode** switches to a
  shorter alternate schedule.

**Notifications & reminders**
- **Live notification** while clocked in, plus clock-in/out confirmations.
- **Scheduled reminders** (Settings → Reminders) — a daily sign-in reminder at the office
  start time, a sign-out reminder at the end time, and a weekly Sunday summary.

**Notes**
- A **Notes** tab for **daily journal** and **meeting** notes — title, body, tags, an
  action-item checklist, pin, and search / filter.
- **Folders & subfolders** organise notes; drill in to a folder, file a note anywhere,
  and rename/delete (delete reparents its contents — nothing is lost). A seamless
  title-into-body editor like a modern notes app. All of it is included in backups.

**Limits & balances**
- **WFH limits** — max 2 / month and 12 / year, counted at the day level; Sign In is
  blocked once a cap is hit.
- **Typed leave** — Casual (15), Sick (10), Parental (10) and Maternity (112, female-only),
  pro-rated by join date; apply over a date range (full or half day) with live balances.

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
- Bottom-nav UI (Home / Notes / Insights / History / Settings); a calm, neutral Home hero
  with a goal-oriented progress ring; light / dark theme (persisted; follows system by default).
- **App lock** — optional device biometric/PIN to open the app.
- **Local backup & restore** — JSON export/import (share sheet + file picker, including
  sessions, leaves, overrides and notes) and CSV export.

## Tech stack

| Concern   | Choice |
|-----------|--------|
| Framework | Flutter (Material 3) |
| Local DB  | [Drift](https://drift.simonbinder.eu/) over SQLite (type-safe, reactive) |
| State     | [Riverpod](https://riverpod.dev/) |
| Routing   | [go_router](https://pub.dev/packages/go_router) (`StatefulShellRoute`) |
| Charts    | [fl_chart](https://pub.dev/packages/fl_chart) |
| Notifications | flutter_local_notifications · timezone · flutter_timezone |
| Widget    | [home_widget](https://pub.dev/packages/home_widget) |
| Security  | [local_auth](https://pub.dev/packages/local_auth) (biometric/PIN) |
| Sharing   | share_plus · file_picker · path_provider |

## Project structure

```
lib/
  main.dart                 # app entry, theme wiring, widget/reminder sync, app lock
  app/router.dart           # bottom-nav shell + routes
  data/
    database.dart           # Drift tables + migrations (schema v8)
    repository.dart          # single data seam over Drift (swap for cloud later)
  domain/
    enums.dart, models.dart # framework-free types
    work_logic.dart         # pure, unit-tested business logic
  services/
    notification_service.dart # live + scheduled notifications (timezone-aware)
    widget_service.dart       # home-screen widget sync + background toggle
  state/providers.dart      # Riverpod providers
  ui/
    theme.dart              # Material 3 design system + per-mode visuals
    setup_screen.dart       # first-run (gender / restore backup)
    dashboard_screen.dart   # Home
    monthly_screen.dart     # Insights
    history_screen.dart     # History (calendar + list + leaves)
    notes_screen.dart       # Notes list (daily / meeting)
    note_editor_screen.dart # Note editor with checklist
    settings_screen.dart    # Settings
    backup_actions.dart     # export / import helpers
    widgets/                # CounterCard, ModeChip, ProgressRing, SessionEditor
```

Business logic operates on plain `WorkSession` / `LeaveRecordModel` / `NoteModel` types; the
repository maps Drift rows to/from them, so moving to a cloud backend later means
reimplementing only `repository.dart`.

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
