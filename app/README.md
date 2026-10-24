# App Intents Factory

SwiftUI app exposing native Swift App Intents to Shortcuts, Siri and the Action Button.

## Build

```sh
cd app
xcodegen generate
xcodebuild -project AppIntentsFactory.xcodeproj -scheme AppIntentsFactory \
  -destination 'id=<device-udid>' -allowProvisioningUpdates build
xcrun devicectl device install app --device <device-udid> <path to AppIntentsFactory.app>
```

Team 8558CXPT9G (Personal Team). Simulator: `-destination 'generic/platform=iOS Simulator'`.

## TestFlight

Pushes to `main` that touch `app/**` run `.github/workflows/deploy-ios.yml`, which archives and uploads to TestFlight via the platform repo's `ios-testflight.yml`. It needs:

- A 1Password Environment containing `ASC_KEY_ID`, `ASC_ISSUER_ID`, `ASC_KEY_P8` (App Store Connect API key, Admin role) and `DEVELOPMENT_TEAM`, loaded in CI with workload identity.
- Repository variables `OP_WORKLOAD_ID` and `OP_ENVIRONMENT_ID`, and repository secret `OP_INTEGRATION_KEY`.
- An App Store Connect app record for `dev.willsawyerrrr.app-intents-factory`.

The Environment ID is in the 1Password app: Developer > View Environments > Manage environment > Copy environment ID. Export it as `OP_ENVIRONMENT_ID` to run commands against the Environment locally, e.g. `op run --environment "$OP_ENVIRONMENT_ID" -- <cmd>`.

The build number is the workflow run number; the marketing version is `MARKETING_VERSION` in `project.yml`.

## Intents

- `Hello World`: name in, greeting out.

## On-device checklist

- [ ] `Hello World` appears in Shortcuts under the app.
- [ ] Result feeds a following `Show Result` or `Set Variable` action.
- [ ] Phrase works in Siri: `Say hello in App Intents Factory`.
- [ ] Bind the intent to the Action Button; runs while locked.

## How to add an intent

1. Add `Sources/Intents/<Name>Intent.swift` with an `AppIntent`; return `ReturnsValue` and `ProvidesDialog` where useful.
2. Add an `AppShortcut` to `Sources/Intents/AppShortcuts.swift` for Siri and Action Button use.
3. Add any usage strings under `info.properties` in `project.yml`.
4. `xcodegen generate`, then build and install with the commands above.
