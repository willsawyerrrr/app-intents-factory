# App Intents spike

SwiftUI app exposing native Swift App Intents to Shortcuts, Siri and the Action Button.

## Build

```sh
cd spike
xcodegen generate
xcodebuild -project AppIntentsSpike.xcodeproj -scheme AppIntentsSpike \
  -destination 'id=00008150-00027DD02E20401C' -allowProvisioningUpdates build
xcrun devicectl device install app --device 00008150-00027DD02E20401C <path to AppIntentsSpike.app>
```

Team 8558CXPT9G (Personal Team). Simulator: `-destination 'generic/platform=iOS Simulator'`.

## Intents

- `Fetch Page Title`: URLSession; URL in, page title out.
- `Create Text File`: text and file name in, `.txt` `IntentFile` out.

Not included: clipboard access. `UIPasteboard` reads from a background run are subject to the paste prompt, so a locked-device run cannot be relied on.

## On-device checklist

- [ ] Both intents appear in Shortcuts under the app.
- [ ] `Fetch Page Title` with `https://example.com`: dialog and result show `Example Domain`.
- [ ] `Fetch Page Title` result feeds a following `Show Result` or `Set Variable` action.
- [ ] `Create Text File` result feeds `Save File` or `Share`.
- [ ] Phrases work in Siri: `Fetch a page title in Intents Spike`, `Create a text file in Intents Spike`.
- [ ] Bind an intent to the Action Button.

## How to add an intent

1. Add `Sources/Intents/<Name>Intent.swift` with an `AppIntent`; return `ReturnsValue` and `ProvidesDialog` where useful.
2. Add an `AppShortcut` to `Sources/Intents/AppShortcuts.swift` for Siri and Action Button use.
3. Add any usage strings under `info.properties` in `project.yml`.
4. `xcodegen generate`, then build and install with the commands above.
