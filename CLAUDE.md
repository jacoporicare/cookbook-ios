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
Writes to `GraphQL/schema.graphqls`.
Production has `introspection: false`, so the schema can only be fetched from a local API. The server and web client live in the sibling `cookbook` monorepo — start it there with `pnpm dev:api`.

**Regenerate GraphQL code after schema changes:**
```bash
./API/apollo-ios-cli generate
```

## Architecture

**Deployment target:** iOS 26+

**Pattern:** SwiftUI with `@Observable` stores over a protocol-based service layer

**Key directories:**
- `App/Model/` - Pure domain types (`Recipe`, `RecipeDraft`, `LoadingStatus`, ...). No UI, no networking
- `App/Stores/` - `@Observable` app state (`RecipeStore`, `CurrentUserStore`, `Routing`)
- `App/Services/` - Protocol + Apollo implementation per concern, plus `AppServices` (the composition root)
- `App/Network/` - `ApolloClientFactory` and the auth interceptors
- `App/Views/` - One folder per screen area; `Views/Common/` for shared pieces
- `API/` - Separate Swift Package for Apollo-generated GraphQL types
- `GraphQL/` - Hand-written `.graphql` operations and `schema.graphqls` (codegen inputs, not app sources)
- `Configuration/` - Build configuration files (Development.xcconfig, Production.xcconfig)
- `fastlane/` - CI/CD automation

**View pattern:** One `...Screen` per screen, reading stores from `@Environment`. Presentational
subviews take plain values. There is no Screen/Template split and no per-screen view model - form
state is `@State` on the screen itself.

**Dependency injection:** `AppServices.live()` builds the one Apollo client and the concrete
services in `ZradelnikApp.init`, and injects them into the stores' initialisers. Views get stores
via `@Environment`, and the image uploader via `@Environment(\.imageUploader)`. Nothing outside
`AppServices` constructs a client or reaches for a singleton, so previews and tests can swap in
stubs (see `PreviewData.swift`).

**Network layer (`App/Network/`):**
- `ApolloClientFactory.make(tokenStore:)` builds the single client, called only from `AppServices`
- SQLite-backed normalized cache; cache keys come from `SchemaConfiguration` (by `id`), which is what
  makes a mutation returning `RecipeDetails` update the list without a refetch
- `AuthorizationHeaderInterceptor` (an `HTTPInterceptor`) adds the bearer token;
  `UnauthenticatedInterceptor` (a `GraphQLInterceptor`) clears it on an `Unauthenticated` error and
  posts `.zradelnikUnauthenticated`, which `CurrentUserStore` listens for. Both are composed with
  `DefaultInterceptorProvider.shared` in `NetworkInterceptorProvider`
- Token stored in the Keychain behind the `TokenStore` protocol (`KeychainTokenStore`)

**GraphQL:**
- Queries/mutations in `GraphQL/` as `.graphql` files; schema in `GraphQL/schema.graphqls`
- All generated code - schema types, fragments AND operations - lands in the `API` package
  (`operations: inSchemaModule`), so adding an operation needs no Xcode project changes at all.
  Files using generated types need `import API`
- `API/Package.swift` is **generated** by codegen (`moduleType: swiftPackage`) - do not hand-edit it.
  To change the Apollo version, replace `API/apollo-ios-cli` with the matching release from
  https://github.com/apollographql/apollo-ios/releases and re-run `generate`
- The GraphQL `Int` scalar maps to Swift `Int32` in **input objects** (spec-correct) while output
  fields stay `Int?` - `RecipeDraft.toRecipeInput()` converts
- Config in `apollo-codegen-config.json`
- `API/Sources/Schema/SchemaConfiguration.swift` and `API/Sources/Schema/CustomScalars/Date.swift`
  are generated once and then hand-edited (cache keys by `id`; ISO8601 date parsing via the Sendable
  `ISO8601FormatStyle`). Codegen will not overwrite them, but changing an output path makes it emit
  fresh stubs elsewhere - port the customizations over if that ever happens

## Configuration

Build-time configuration via xcconfig files:
- `Development.xcconfig`: Uses `api.zradelnik.cz`
- `Production.xcconfig`: Uses `api.zradelnik.cz`

Both point at production — there is no separate dev API, so a simulator build talks to live data.

Access config values via `Configuration.value(for:)`.

## Key Conventions

- Use `zradelnikLocale` for Czech-aware string sorting/grouping
- Use `CachedAsyncImage` for recipe images
- `Recipe.matches(_:)` is the single definition of "matches a search term" (diacritic-insensitive, title + ingredients)
- `Recipe.imageUrl` is a bare S3 key prefix, not a fetchable URL. Use `listImageUrl` / `gridImageUrl` / `fullImageUrl`, which append a pre-generated `<width>.webp` rendition. Widths must stay in sync with `RENDITION_WIDTHS` (`api/src/imageProcessing.ts`) and `web/image-loader.js` in the `cookbook` monorepo
- Image upload is presign-based: `CreateImageUpload` mutation → `PUT` the original to the returned S3 URL → submit `key` as `imageId` to create/update
- Navigation paths hold `RecipeRoute` (an id), never a `Recipe`. Pushed screens read the recipe back from `RecipeStore`, so a mutation that lands in the Apollo cache refreshes them with no write-back into the path. Do not put model values in a navigation path
- Tapping the already-selected tab scrolls its list to the top for free since iOS 18 — do not reimplement it. The custom `tabSelection` binding in `ZradelnikApp` exists only to detect re-selection for pop-to-root, which SwiftUI does not report
- Each tab owns its navigation path (`Routing.recipeListPath` / `sousVidePath` / `searchPath`), so tabs keep separate stacks
- Sous-vide recipes are filtered by the `"sous-vide"` tag (via `Recipe.sousVideTag`)
- Authentication defaults to `WebAuthenticationSession` redirecting to a custom URL scheme; the native form is still wired up behind `authMethod` in `SettingsScreen.swift`

## Dependencies (SPM)

- `apollo-ios` 2.4.0 - GraphQL client with SQLite-backed cache. Async-first: `fetch`/`perform` are `async throws` and return `GraphQLResponse`, `watch` is `async`. Pinned `exact` by the **generated** `API/Package.swift`, so the pin follows whatever `API/apollo-ios-cli` version you run
- `KeychainAccess` - Secure token storage
- `swift-markdown-ui` - Markdown rendering for recipe directions
- `swiftui-cached-async-image` 2.1.1 - Async image loading with caching. Pinned: 2.1.2's manifest declares `swift-tools-version:5.6` but uses `.visionOS(.v1)` (needs 5.9), so SwiftPM silently rejects it and falls back

## Gotchas

- `ApolloClientFactory` deliberately `fatalError`s if `API_BASE_URL` is missing from the Info.plist
- Both login flows are live and interchangeable: flip `authMethod` in `SettingsScreen.swift` between `.web` (ASWebAuthenticationSession, the default) and `.native` (`LoginScreen`, username/password against the `login` mutation). The web flow returns the access token in a redirect query param, which is implicit-flow shaped rather than a PKCE code exchange
- Generated Apollo code in `API/Sources/` should not be edited manually, except the two hand-customized files noted under GraphQL above
- `App/` is a **file-system-synchronized group**, so adding, renaming or deleting a source file needs no `project.pbxproj` edit — just create the file. The only membership exception is `App/Zradelnik-Info.plist`. If the project ever does need editing by hand, the `xcodeproj` gem is not installed, so verify with `plutil -lint Zradelnik.xcodeproj/project.pbxproj`
- `Shared/Assets.xcassets` is an unreferenced leftover; the live catalog is `App/Resources/Assets.xcassets`
- No tap automation available: `simctl` has no tap command and `osascript` lacks assistive access, so UI behaviour has to be verified by hand in the simulator
