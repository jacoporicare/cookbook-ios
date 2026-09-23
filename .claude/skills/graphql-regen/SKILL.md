---
name: graphql-regen
description: Fetch GraphQL schema and regenerate Apollo iOS types
---

# GraphQL Regeneration

The API must be running locally first — production has introspection disabled, so
`fetch-schema` only works against `localhost:4000`. Start it from the sibling
`cookbook` monorepo with `pnpm dev:api`.

Run these steps in order:
1. `./API/apollo-ios-cli fetch-schema` — pulls latest schema from the local server
2. `./API/apollo-ios-cli generate` — regenerates Swift types into API/Sources/

After generation, verify the build still compiles:
```
xcodebuild -scheme Zradelnik -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 18 Pro' build
```

Never hand-edit files in API/Sources/ — always regenerate.

If you added an operation, generation creates a new file in `App/GraphQL/`. The Xcode
project uses explicit file references, so register it in `project.pbxproj` by hand
(`PBXBuildFile`, `PBXFileReference`, group children, Sources phase) or the build will
not see it.
