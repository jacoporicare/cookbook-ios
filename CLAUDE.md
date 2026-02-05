# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Zradelnik is a Czech cookbook iOS app built with SwiftUI. It uses GraphQL (Apollo iOS) for networking, features recipe browsing with Instant Pot filtering, recipe tracking (mark as cooked), and web-based authentication.

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

**Fetch GraphQL schema (requires local server at localhost:4000):**
```bash
./API/apollo-ios-cli fetch-schema
```

**Regenerate GraphQL code after schema changes:**
```bash
./API/apollo-ios-cli generate
```

## Architecture

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

## Configuration

Build-time configuration via xcconfig files:
- `Development.xcconfig`: Uses `api-test.zradelnik.cz`
- `Production.xcconfig`: Uses `api.zradelnik.cz`

Access config values via `Configuration.value(for:)`.

## Key Conventions

- Use `zradelnikLocale` for Czech-aware string sorting/grouping
- Use `CachedAsyncImage` for recipe images
- Instant Pot recipes are filtered by the `"Instant Pot"` tag
- Authentication uses `WebAuthenticationSession` redirecting to a custom URL scheme
