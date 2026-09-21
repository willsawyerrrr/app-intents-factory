# App Intents scripting spike

SwiftUI app exposing `Run Script` and `Run Saved Script` App Intents that execute JavaScript files from the app's Documents folder via JavaScriptCore.

## Build

```sh
cd spike
xcodegen generate
open AppIntentsSpike.xcodeproj   # run on device; team 8558CXPT9G (Personal Team)
```

Simulator: `xcodebuild -project AppIntentsSpike.xcodeproj -scheme AppIntentsSpike -destination 'generic/platform=iOS Simulator' build`.

## Scripts

Plain `.js` files in Documents (Files > On My iPhone > Intents Spike). Define `main(input)`; the return value becomes the result (non-strings are JSON-encoded). Sample scripts are copied on first launch.

Globals: `console.log(...)`, `http.get(url)` (synchronous), `clipboard.read()`, `clipboard.write(text)`, `sleep(ms)`.

## Deferred

- Control Center control: needs a widget extension and shared state (App Group), unavailable on a Personal Team.
- `fetch`/Promises: JavaScriptCore has no event loop here; `http.get` blocks the script thread.

## On-device checklist

- [x] `Run Script` and `Run Saved Script` appear in Shortcuts; phrases work in Siri.
- [x] `Run Saved Script` picker lists the scripts.
- [x] Add a `.js` file via Files; it appears in the picker without relaunching the app.
- [ ] Edit a script in Files; the next run uses the new source.
- [x] Run with the device locked via the Action Button and Siri.
- [x] Background runs are cut off at about 30 s.
- [ ] Dialog and returned value are usable by a following Shortcuts action.
- [x] Bind `Run Saved Script` to the Action Button.
- [ ] Clipboard read from a background run: paste prompt or empty result.
