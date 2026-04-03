# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

GitHubClient is a Swift package that provides a strongly-typed client for the GitHub REST API. It uses Apple's Swift OpenAPI Generator to generate Swift types and client code from the official GitHub OpenAPI specification.

**Key Details**:
- **Language**: Swift 6.0 with strict concurrency enabled
- **Package Manager**: SPM (Swift Package Manager)
- **Platforms**: iOS 13+, macOS 10.15+
- **OpenAPI Generator**: Generates types and HTTP client from spec

## Architecture

### Code Generation Workflow

The project uses Swift OpenAPI Generator via a **manual generation script**:

1. **Source of Truth**: `Sources/GitHubClient/openapi.yml` — the GitHub REST API OpenAPI specification
2. **Generator Config**: `Sources/GitHubClient/openapi-generator-config.yml` — controls what gets generated:
   - `types` — generates Swift models/types for API schemas
   - `client` — generates the API client
   - `accessModifier: public` — all generated types are public
3. **Generated Output**: Script creates Swift code in `Sources/GitHubClient/Generated/`
4. **Manual Approach**: Uses the script instead of build plugin to avoid conflicts

### Directory Structure

```
Sources/GitHubClient/
  ├── openapi.yml                    # GitHub API spec (source of truth)
  ├── openapi-generator-config.yml   # Generator configuration
  └── Generated/
      ├── Client.swift               # Generated API client (not in git)
      └── Types.swift                # Generated types and models (not in git)

Tests/GitHubClientTests/
  └── GitHubClientTests.swift        # Test suite (uses Swift Testing)

scripts/
  └── generate-github-client.sh       # Code generation script for CI
```

### Runtime Dependencies

- **OpenAPIRuntime** — Core client infrastructure (request/response handling)
- **OpenAPIURLSession** — URLSession-based HTTP transport layer

### Development Dependencies

- **Swift OpenAPI Generator** — CLI tool for code generation (used by `./scripts/generate-github-client.sh`)

## Common Development Tasks

### Build the Package

```bash
swift build
```

### Run Tests

```bash
swift test
```

Run a specific test:

```bash
swift test --filter GitHubClientTests.TestName
```

### View Generated Code

After running the generation script, generated code is available in:

- `Sources/GitHubClient/Generated/Client.swift` — The API client
- `Sources/GitHubClient/Generated/Types.swift` — All generated types and models

To understand what's generated, examine these files directly or look at `openapi.yml` to see the API definitions.

### Regenerate Code from Updated Spec

Use the provided generation script (recommended):

```bash
./scripts/generate-github-client.sh
```

This script:
- Validates required files exist
- Creates output directory if needed
- Runs the generator with correct configuration
- Verifies generated files

Or regenerate manually with the correct file extensions:

```bash
swift run swift-openapi-generator generate \
  --output-directory Sources/GitHubClient/Generated \
  --config Sources/GitHubClient/openapi-generator-config.yml \
  Sources/GitHubClient/openapi.yml
```

**Note**: Always use `.yml` extension, not `.yaml`.

### Modify Generator Behavior

Edit `Sources/GitHubClient/openapi-generator-config.yml`:

```yaml
generate:
  - types      # Include/exclude types generation
  - client     # Include/exclude client generation
accessModifier: public  # Control visibility of generated code
```

Available options are documented in the [Swift OpenAPI Generator documentation](https://github.com/apple/swift-openapi-generator).

## Key Conventions

### Testing

- Use **Swift Testing** framework (`@Test` macro, `#expect` assertions)
- Place tests in `Tests/GitHubClientTests/`
- No XCTest unless absolutely necessary

### Generated Code

- **Do not manually edit** generated code — changes will be overwritten at next build
- If you need to modify client behavior, extend the generated code via extensions or wrappers
- To change generated code, modify the spec (`openapi.yml`) or generator config

### Module Structure

The package exports a single target: `GitHubClient`. All generated types and the client are part of this module. Import as:

```swift
import GitHubClient
```

## Manual Generation Strategy

The project uses manual code generation rather than a build plugin to avoid build conflicts:

- Generated code is created by the `./scripts/generate-github-client.sh` script
- Files are placed in `Sources/GitHubClient/Generated/` (listed in `.gitignore`)
- No build plugin is configured in `Package.swift`
- CI/CD systems should run the generation script **before** building the package
- This approach prevents "multiple producers" conflicts during incremental builds

## Documentation References

- [Swift OpenAPI Generator Repo](https://github.com/apple/swift-openapi-generator)
- [GitHub REST API Specification](https://docs.github.com/en/rest)
- [Swift Package Manager Documentation](https://swift.org/package-manager/)
