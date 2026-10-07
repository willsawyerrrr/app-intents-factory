# CLAUDE.md

Conventions shared across willsawyerrrr.dev projects live in `../../CLAUDE.md`.

## Architecture

- Native Swift App Intents only. Each new behaviour is a Swift `AppIntent` in `spike/Sources/Intents/`, rebuilt with Xcode and installed on the device. No script runtimes or DSLs.
- The Xcode project is generated from `spike/project.yml` with `xcodegen`; `*.xcodeproj` and `Info.plist` are not committed.
- Bundle ID: `dev.willsawyerrrr.app-intents-spike`.

## Build

See `spike/README.md`. CI runs pre-commit and builds the spike for the iOS Simulator; the `CI Status` job aggregates every other CI job, and `main`'s ruleset requires only that check. Add any new CI job to its `needs:`.

## Docs

Keep `docs/app-intents-feasibility.md` and `spike/README.md` in sync with the code: adding an intent updates the spike's intent list; changing scope updates the feasibility doc's spike section.
