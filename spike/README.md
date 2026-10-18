# App Intents spike

SwiftUI app exposing native Swift App Intents to Shortcuts, Siri and the Action Button.

## Build

```sh
cd spike
xcodegen generate
xcodebuild -project AppIntentsSpike.xcodeproj -scheme AppIntentsSpike \
  -destination 'id=<device-udid>' -allowProvisioningUpdates build
xcrun devicectl device install app --device <device-udid> <path to AppIntentsSpike.app>
```

Team 8558CXPT9G (Personal Team). Simulator: `-destination 'generic/platform=iOS Simulator'`.

## TestFlight

Pushes to `main` that touch `spike/**` run `.github/workflows/deploy-ios.yml`, which archives and uploads to TestFlight via the platform repo's `ios-testflight.yml`. It needs:

- Secrets `ASC_KEY_ID`, `ASC_ISSUER_ID`, `ASC_KEY_P8` (App Store Connect API key, Admin role).
- Variable `DEVELOPMENT_TEAM`.
- An App Store Connect app record for `dev.willsawyerrrr.app-intents-factory`.

The build number is the workflow run number; the marketing version is `MARKETING_VERSION` in `project.yml`.

## Intents

- `Hello World`: name in, greeting out.

## On-device checklist

- [ ] `Hello World` appears in Shortcuts under the app.
- [ ] Result feeds a following `Show Result` or `Set Variable` action.
- [ ] Phrase works in Siri: `Say hello in Intents Spike`.
- [ ] Bind the intent to the Action Button; runs while locked.

## How to add an intent

1. Add `Sources/Intents/<Name>Intent.swift` with an `AppIntent`; return `ReturnsValue` and `ProvidesDialog` where useful.
2. Add an `AppShortcut` to `Sources/Intents/AppShortcuts.swift` for Siri and Action Button use.
3. Add any usage strings under `info.properties` in `project.yml`.
4. `xcodegen generate`, then build and install with the commands above.
