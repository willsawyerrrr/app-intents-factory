# CLAUDE.md

Conventions shared across willsawyerrrr.dev projects live in `../../CLAUDE.md`.

## Architecture

- Native Swift App Intents only. Each new behaviour is a Swift `AppIntent` in `app/Sources/Intents/`, rebuilt with Xcode and installed on the device. No script runtimes or DSLs.
- The Xcode project is generated from `app/project.yml` with `xcodegen`; `*.xcodeproj` and `Info.plist` are not committed.
- Bundle ID: `dev.willsawyerrrr.app-intents-factory`.

## Build

See `app/README.md`. CI runs pre-commit and builds the app for the iOS Simulator; the `CI Status` job aggregates every other CI job, and `main`'s ruleset requires a pull request (squash merges only) and that check, and blocks force pushes and deletion. Add any new CI job to its `needs:`.

## Runtime parity

The app builds with Xcode 26.6 in CI, local development and TestFlight deploys: `ci.yml` pins `macos-26` and `maxim-lobanov/setup-xcode` to `26.6`, and `.xcode-version` records it. Bump them together.

CI runs pre-commit on Python 3.15, pinned by `.python-version` (the local toolchain).

## Deploy

Pushes to `main` touching `app/**` upload to TestFlight via `.github/workflows/deploy-ios.yml` (platform's `ios-testflight.yml`). Credentials come from a 1Password Environment; details in `app/README.md`. The workflow is not part of `CI Status`.

## Docs

Keep `docs/app-intents-feasibility.md` and `app/README.md` in sync with the code: adding an intent updates the app's intent list; changing scope updates the feasibility doc's roadmap section.
