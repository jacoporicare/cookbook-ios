# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Zradelnik is a Czech cookbook iOS app built with SwiftUI. It uses GraphQL (Apollo iOS) for networking, features recipe browsing with sous-vide filtering, recipe tracking (mark as cooked), and web-based authentication.

## Build Commands

**Build the app:**
```bash
xcodebuild -scheme Zradelnik -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build
```

**Run tests:** No test targets currently configured.

**Deploy to TestFlight:**
```bash
bundle exec fastlane ios beta
```

**Fetch GraphQL schema (requires the API running at localhost:4000):**
```bash
./API/apollo-ios-cli fetch-schema
```
Production has `introspection: false`, so the schema can only be fetched from a local API. The server and web client live in the sibling `cookbook` monorepo — start it there with `pnpm dev:api`.

**Regenerate GraphQL code after schema changes:**
```bash
./API/apollo-ios-cli generate
```

## Architecture

**Deployment target:** iOS 26+

**Pattern:** SwiftUI + MVVM with Observable stores

**Key directories:**
- `App/` - Main iOS app source code
- `API/` - Separate Swift Package for Apollo-generated GraphQL types
- `Configuration/` - Build configuration files (Development.xcconfig, Production.xcconfig)
- `fastlane/` - CI/CD automation

**View pattern:** Screen/Template pairs where Screen manages navigation and state, Template is the reusable UI component.

**State management:**
- `RecipeStore` - Recipes list, Apollo cache watchers
- `CurrentUserStore` - Authentication state
- `Routing` - Navigation stack state
- Stores are passed via `@EnvironmentObject`

**Network layer (`App/Network/`):**
- `Network.shared.apollo` - Singleton Apollo client
- SQLite-backed normalized cache
- Custom interceptors for auth token injection and 401 handling
- Token stored in Keychain via `ZKeychain` enum

**GraphQL:**
- Queries/mutations in `App/GraphQL/` as `.graphql` files
- Schema in `App/GraphQL/schema.graphqls`
- Generated types output to `API/` package
- Config in `apollo-codegen-config.json`
- Adding an operation creates a new file in `App/GraphQL/` that must be registered in `project.pbxproj` by hand (see Gotchas)

## Configuration

Build-time configuration via xcconfig files:
- `Development.xcconfig`: Uses `api.zradelnik.cz`
- `Production.xcconfig`: Uses `api.zradelnik.cz`

Both point at production — there is no separate dev API, so a simulator build talks to live data.

Access config values via `Configuration.value(for:)`.

## Key Conventions

- Use `zradelnikLocale` for Czech-aware string sorting/grouping
- Use `CachedAsyncImage` for recipe images
- `Recipe.imageUrl` is a bare S3 key prefix, not a fetchable URL. Use `listImageUrl` / `gridImageUrl` / `fullImageUrl`, which append a pre-generated `<width>.webp` rendition. Widths must stay in sync with `RENDITION_WIDTHS` (`api/src/imageProcessing.ts`) and `web/image-loader.js` in the `cookbook` monorepo
- Image upload is presign-based: `CreateImageUpload` mutation → `PUT` the original to the returned S3 URL → submit `key` as `imageId` to create/update
- Tapping the already-selected tab scrolls its list to the top for free since iOS 18 — do not reimplement it. The custom `tabSelection` binding in `ZradelnikApp` exists only to detect re-selection for pop-to-root, which SwiftUI does not report
- Each recipe tab owns its navigation path (`Routing.recipeListStack` / `sousVideListStack`), so the two tabs keep separate stacks
- Sous-vide recipes are filtered by the `"sous-vide"` tag (via `Recipe.sousVideTag`)
- Authentication uses `WebAuthenticationSession` redirecting to a custom URL scheme

## Dependencies (SPM)

- `apollo-ios` 1.25.3 - GraphQL client with SQLite-backed cache
- `KeychainAccess` - Secure token storage
- `swift-markdown-ui` - Markdown rendering for recipe directions
- `swiftui-cached-async-image` 2.1.1 - Async image loading with caching. Pinned: 2.1.2's manifest declares `swift-tools-version:5.6` but uses `.visionOS(.v1)` (needs 5.9), so SwiftPM silently rejects it and falls back

## Gotchas

- `Network.swift` uses `try!` for config — will crash if `API_BASE_URL` is missing
- `LoginScreenView` is deprecated — use `SettingsScreenView` (WebAuthenticationSession) for auth
- Generated Apollo code in `API/Sources/` should not be edited manually
- The Xcode project uses explicit file references, not synchronized groups, so a new source file needs `PBXBuildFile`, `PBXFileReference`, group-children and Sources-phase entries in `project.pbxproj`. The `xcodeproj` gem is not installed, so this is a manual text edit; verify with `plutil -lint Zradelnik.xcodeproj/project.pbxproj`
- No tap automation available: `simctl` has no tap command and `osascript` lacks assistive access, so UI behaviour has to be verified by hand in the simulator
