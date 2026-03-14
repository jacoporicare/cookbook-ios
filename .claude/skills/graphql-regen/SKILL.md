---
name: graphql-regen
description: Fetch GraphQL schema and regenerate Apollo iOS types
---

# GraphQL Regeneration

Run these steps in order:
1. `./API/apollo-ios-cli fetch-schema` — pulls latest schema from the server
2. `./API/apollo-ios-cli generate` — regenerates Swift types into API/Sources/

After generation, verify the build still compiles:
```
xcodebuild -scheme Zradelnik -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build
```

Never hand-edit files in API/Sources/ — always regenerate.
