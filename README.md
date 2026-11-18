# RailPulse

A premium, fast and privacy-friendly Indian Railways companion built with Flutter.
Search a train, open its live running status, check a PNR, or read a station's
departure board — in English, हिन्दी or বাংলা.

RailPulse is **Android-first**, ships a light and dark theme, and never invents
"live" railway data: every response is either real provider data or sample data
that is clearly labelled **Demo data** in the UI.

```
┌──────────────────────┐        HTTPS/HTTP        ┌──────────────────────┐        ┌────────────────┐
│  Flutter app         │  ──────────────────────▶ │  RailPulse proxy     │ ─────▶ │  irctc.dev /   │
│  (no API keys)       │   stable JSON contract   │  Node + Express      │        │  RailKit       │
└──────────────────────┘                          └──────────────────────┘        └────────────────┘
```

The app never talks to a railway provider directly and never contains an API
key. The `backend/` proxy holds the key, caches upstream responses and normalises
provider payloads into one stable contract.

---

## Features

| Area | What it does |
| --- | --- |
| Home | Hero train search, quick actions, recently viewed trains and popular trains |
| Train search | Search by train number or name; search stations by name or code |
| Live status | Current location, delay, next halt, full stop timeline, journey progress, 60-second auto-refresh, date history |
| Train route | Full schedule with arrival/departure, halt times, distance, platform and day dividers |
| PNR | PNR lookup with passenger-wise booking/current status, chart status and recent PNRs |
| Station board | Arrivals/departures for the next 2, 4 or 8 hours with platform and delay |
| Favourites | Save trains locally and reopen them in one tap |
| Settings | Light/dark/system theme, English/हिन्दी/বাংলা, notification preference, data-source diagnostics, cache reset |

Every screen has loading skeletons, empty states, retryable error states and
pull-to-refresh. Timestamps show when data was last updated.

---

## Requirements

- **Flutter 3.50+** (Dart 3.9+) with the Android toolchain (`flutter doctor`)
- **Node.js 20+**
- Android Studio / Android SDK for building an APK
- An API key for **irctc.dev** (default live provider) and/or **RailKit**

The app works fully without a key: the proxy then serves sample data and every
affected screen displays a **Demo data** banner.

---

## 1. Run the backend proxy

```bash
cd backend
npm install
cp .env.example .env
```

Edit `backend/.env`:

```dotenv
PORT=8787

# "irctc" (default) or "railkit"
RAILWAY_PROVIDER=irctc
IRCTC_API_KEY=your_irctc_dev_key

# Only needed when RAILWAY_PROVIDER=railkit
RAILKIT_API_KEY=

# Serve labelled sample data even when a key exists
RAILPULSE_DEMO=0
```

Start it:

```bash
npm start          # or: npm run dev  (watch mode)
```

Verify:

```bash
curl http://localhost:8787/api/health
# {"source":"irctc","ok":true,"mode":"irctc","provider":"irctc","demo":false,...}
```

`source` is `irctc`/`railkit` when live data is served, and `demo` when the
proxy is running on sample data. The app reads this to show or hide the demo
banner.

### Provider selection

- `RAILWAY_PROVIDER=irctc` — uses irctc.dev (`IRCTC_API_KEY`).
- `RAILWAY_PROVIDER=railkit` — uses the optional RailKit SDK (`RAILKIT_API_KEY`).
  The SDK is an optional dependency, so `npm install` still works without it;
  install it explicitly with `npm install railkit` when you want this provider.
- If `RAILWAY_PROVIDER` is omitted, the proxy prefers RailKit when a RailKit key
  exists, otherwise irctc.dev.
- If no key is present, or `RAILPULSE_DEMO=1`, demo mode is used and responses
  are marked `source: "demo"`.

### Deploy the proxy from GitHub (recommended)

GitHub stores and versions the code but does not run Node servers, so the
repository is wired to **Render**, which deploys the backend automatically on
every push.

1. Push this repository to GitHub (see the commands at the end of this file).
2. Create a Render account at <https://render.com> and choose
   **New → Blueprint**, then select the repository.
3. Render reads `render.yaml`, creates the `railpulse-api` service and asks for
   `IRCTC_API_KEY`. Paste it there — never in the repository.
4. Copy the service URL, e.g. `https://railpulse-api.onrender.com`.
5. In the app open **Settings → API server**, enter that URL and tap **Save**.

The app and the proxy are independent: the Flutter app can be installed as an
APK while the proxy runs on Render. Free Render services sleep after inactivity,
so the first request after a pause can take a few seconds.

A `backend/Dockerfile` is included if you prefer Railway, Fly.io, Cloud Run or
any other container host — set `IRCTC_API_KEY`, `RAILWAY_PROVIDER=irctc` and
`PORT=8787` in that platform's secret settings.

### API contract

| Method | Path | Purpose |
| --- | --- | --- |
| GET | `/api/health` | Liveness + current data source |
| GET | `/api/popular` | Curated popular trains (cached 6 h) |
| GET | `/api/trains/search?q=` | Search trains by number or name |
| GET | `/api/trains/:number` | Train profile + full route |
| GET | `/api/trains/:number/live?date=DD-MM-YYYY` | Live running status |
| GET | `/api/pnr/:pnr` | PNR status |
| GET | `/api/stations/search?q=` | Station search |
| GET | `/api/stations/:code/board?hours=2` | Station board (`2`, `4` or `8` hours) |

All responses include `source` and `updatedAt`; errors use a consistent
`{ error: { code, message } }` shape with proper HTTP status codes.

---

## 2. Run the Flutter app

```bash
cd railpulse           # repository root of the app
flutter pub get
flutter gen-l10n       # regenerates lib/l10n/app_localizations*.dart
flutter run
```

### Point the app at your proxy

The default base URL is chosen per platform:

| Target | Default |
| --- | --- |
| Android emulator | `http://10.0.2.2:8787` (host loopback) |
| iOS simulator / desktop | `http://localhost:8787` |

For a **physical phone**, you have two options:

1. **No rebuild needed (recommended):** open **Settings → API server**, enter
   `http://<computer-LAN-IP>:8787` and tap **Save**. The address is stored on the
   device and used for every request.
2. Bake it in at build time:

```bash
flutter run --dart-define=RAILPULSE_API_BASE_URL=http://192.168.1.10:8787
```

The phone and computer must be on the same Wi-Fi network, and the proxy must be
reachable on port `8787`. `10.0.2.2` only works inside the Android emulator.

> Cleartext HTTP is enabled in `android/app/src/main/AndroidManifest.xml` for
> local development. For a public deployment, put the proxy behind HTTPS and
> remove `android:usesCleartextTraffic="true"`.

---

## 3. Build an APK

Debug (quick, installable):

```bash
flutter build apk --debug \
  --dart-define=RAILPULSE_API_BASE_URL=http://10.0.2.2:8787
```

Release (split per ABI, smaller downloads):

```bash
flutter build apk --release --split-per-abi \
  --dart-define=RAILPULSE_API_BASE_URL=https://api.example.com
```

Output: `build/app/outputs/flutter-apk/`. Install with
`adb install -r build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`.

Release signing: generate a keystore, add `android/key.properties`, and wire it
into `android/app/build.gradle.kts`. Never commit the keystore or its passwords.

---

## Project structure

```
railpulse/
├── backend/                     Node proxy (keys live here only)
│   ├── src/
│   │   ├── env.js               Provider / demo selection
│   │   ├── cache.js             TTL response cache
│   │   ├── normalize.js         Provider → stable contract
│   │   ├── railway/
│   │   │   ├── index.js         Active provider switch
│   │   │   ├── irctc.js         irctc.dev provider
│   │   │   ├── railkit.js       RailKit SDK provider
│   │   │   └── provider.js      Shared interface + demo fallback
│   │   ├── demo/                Clearly-labelled sample catalogue
│   │   └── routes/api.js        REST contract
│   └── .env.example
├── lib/
│   ├── app/                     App shell, routing, services, theme
│   ├── core/                    Config, HTTP client, storage, state, formatters
│   ├── features/                Feature-first screens + models + services
│   │   ├── home/
│   │   ├── train_search/
│   │   ├── live_status/
│   │   ├── train_schedule/
│   │   ├── pnr/
│   │   ├── station_status/
│   │   ├── favourites/
│   │   └── settings/
│   ├── l10n/                    English, Hindi and Bengali ARB files
│   └── shared/                  Reusable models and widget kit
└── test/                        Model parsing and widget tests
```

### Design system

- Navy `#101828` primary, slate `#18243A` secondary, emerald `#22C55E` accent
- Light background `#F8FAFC`, white cards, 16–20 px radii
- Inter typeface, tabular figures for times
- Green is reserved for live/positive states; amber for delays, red for errors
- Both light and dark palettes are defined in `AppPalette` and exposed through a
  `ThemeExtension`, so widgets never hard-code colours

### Data honesty

- Live endpoints are only shown as live when the proxy reports a live source.
- Demo payloads are labelled on every screen with the **Demo data** banner.
- The last-updated time is always visible next to live content.
- No API keys are bundled in the app; the only network target is the proxy.

---

## Localization

Strings live in `lib/l10n/app_en.arb`, `app_hi.arb` and `app_bn.arb`. After
editing any ARB file run:

```bash
flutter gen-l10n
```

All three locales are selectable in Settings, and the choice persists.

---

## Tests

```bash
flutter analyze
flutter test
```

`test/models_test.dart` covers JSON normalisation, date/time formatting and
model round-trips. `test/widget_test.dart` covers the demo banner and shared
widgets.

---

## Troubleshooting

| Symptom | Fix |
| --- | --- |
| App shows "Backend unreachable" | Start the proxy; open **Settings → API server** and set your LAN IP (not `localhost` / `10.0.2.2` on a real phone) |
| Emulator can't reach the proxy | Use `10.0.2.2`, not `127.0.0.1`; confirm the proxy listens on `0.0.0.0` |
| `NetworkSecurityConfig` / cleartext error | Keep `usesCleartextTraffic` for local HTTP, or serve the proxy over HTTPS |
| Banner says Demo data with a key configured | Verify `RAILWAY_PROVIDER` and the matching key in `backend/.env`, then restart the proxy |
| `flutter gen-l10n` getters missing | Re-run `flutter pub get` then `flutter gen-l10n` |
| PNR/live lookups fail | Provider credits may be exhausted or the PNR/date may be invalid; check the proxy log |

---

## Security notes

- Keep `backend/.env` private; it is gitignored. Never commit real keys.
- The key you used during development should be rotated in the provider
  dashboard before publishing this repository or a build.
- Rate limiting/caching keeps provider credit usage low (live responses are
  cached for roughly 30–45 seconds, schedules for hours).
- PNRs are personal data. The app stores recent PNRs only on the device; the
  proxy does not persist requests.

---

## Publishing this repository

Run these **inside the `railpulse/` folder** (the folder containing this README).
The `.env` file, `node_modules/`, build output and local Android settings are
already gitignored.

```bash
git init
git add .
git commit -m "RailPulse: Flutter app + live railway proxy"
git branch -M main
git remote add origin https://github.com/chandramondal-1/rail-.git
git push -u origin main
```

Check that no secret is staged before pushing:

```bash
git status --short
git diff --cached | grep -i "IRCTC_API_KEY=" || echo "no keys staged"
```

After the push:

- GitHub Actions runs `flutter analyze`, `flutter test` and the backend check.
- The **Android APK** workflow builds `app-debug.apk` and attaches it as a
  downloadable artifact under the Actions tab.
- Render (via `render.yaml`) deploys the proxy, and Settings → API server points
  the app at it.

## Disclaimer

RailPulse is an independent project. It is not affiliated with Indian Railways
or IRCTC. Live data can be delayed or inaccurate — always confirm with official
railway sources before travelling.
