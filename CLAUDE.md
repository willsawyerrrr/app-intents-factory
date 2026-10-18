# CLAUDE.md

Conventions shared across willsawyerrrr.dev projects live in `../../CLAUDE.md`.

## Architecture

- Native Swift App Intents only. Each new behaviour is a Swift `AppIntent` in `app/Sources/Intents/`, rebuilt with Xcode and installed on the device. No script runtimes or DSLs.
- The Xcode project is generated from `app/project.yml` with `xcodegen`; `*.xcodeproj` and `Info.plist` are not committed.
- Bundle ID: `dev.willsawyerrrr.app-intents-factory`.

## Build

See `app/README.md`. CI runs pre-commit and builds the app for the iOS Simulator; the `CI Status` job aggregates every other CI job, and `main`'s ruleset requires a pull request (squash merges only) and that check, and blocks force pushes and deletion. Add any new CI job to its `needs:`.

## Deploy

Pushes to `main` touching `app/**` upload to TestFlight via `.github/workflows/deploy-ios.yml` (platform's `ios-testflight.yml`). Details in `app/README.md`. The workflow is not part of `CI Status`.

## Docs

Keep `docs/app-intents-feasibility.md` and `app/README.md` in sync with the code: adding an intent updates the app's intent list; changing scope updates the feasibility doc's roadmap section.
