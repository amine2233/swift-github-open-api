# GitHubClient

A Swift package that provides a strongly-typed client for the [GitHub REST API](https://docs.github.com/en/rest).

## Overview

GitHubClient is an auto-generated Swift library for interacting with GitHub's REST API. It uses Apple's [Swift OpenAPI Generator](https://github.com/apple/swift-openapi-generator) to generate type-safe Swift code directly from the official GitHub OpenAPI specification.

## Features

- **Type-Safe API**: Compile-time checked API calls
- **Auto-Generated**: Code generated from the official GitHub OpenAPI spec
- **Swift 6**: Leverages modern Swift features and strict concurrency
- **Async/Await**: Built on async/await for modern concurrent code
- **Cross-Platform**: iOS 13+, macOS 10.15+

## Installation

### Swift Package Manager

Add this to your `Package.swift`:

```swift
.package(url: "https://github.com/amine2233/swift-github-open-api", from: "1.0.0")
```

Or in Xcode: File → Add Packages → paste the repository URL.

## Usage

```swift
import GitHubClient
import OpenAPIURLSession

// Create a client
let client = Client(
    serverURL: URL(string: "https://api.github.com")!,
    transport: URLSessionTransport()
)

// Make API calls
let repos = try await client.repos_list_for_authenticated_user()
```

## OpenAPI Specification

This library is generated from the official GitHub REST API OpenAPI specification:

📖 **Source**: [GitHub REST API Description](https://github.com/github/rest-api-description/blob/main/descriptions/api.github.com/api.github.com.yaml)

The OpenAPI spec is automatically downloaded and used to generate the Swift client code. This ensures the library stays up-to-date with the latest GitHub API changes.

## Development

### Generate Code

To regenerate Swift code from the OpenAPI specification:

```bash
./scripts/generate-github-client.sh
```

See [CLAUDE.md](./CLAUDE.md) for more detailed development instructions.

### Build

```bash
swift build
```

### Test

```bash
swift test
```

## Project Structure

```
Sources/GitHubClient/
  ├── openapi.yml                    # GitHub API specification
  ├── openapi-generator-config.yml   # Generator configuration
  └── Generated/
      ├── Client.swift               # Generated API client
      └── Types.swift                # Generated types and models

Tests/GitHubClientTests/
  └── GitHubClientTests.swift        # Test suite
```

## Swift Version

- **Minimum**: Swift 6.0
- **Current**: Swift 6.3
- **Language Mode**: Swift 6 (strict concurrency enabled)

## Dependencies

- [swift-openapi-runtime](https://github.com/apple/swift-openapi-runtime) - Client infrastructure
- [swift-openapi-urlsession](https://github.com/apple/swift-openapi-urlsession) - URLSession transport
- [swift-openapi-generator](https://github.com/apple/swift-openapi-generator) - Code generator (build plugin)

## Documentation

- [Swift OpenAPI Generator Docs](https://swiftpackageindex.com/apple/swift-openapi-generator/documentation/openapigenerator)
- [GitHub REST API Docs](https://docs.github.com/en/rest)

## License

MIT — See LICENSE for details

## Contributing

This is an auto-generated library. To contribute:

1. Report issues with the generated API
2. Suggest improvements to the generation process
3. For API issues, report them to [GitHub's REST API Description](https://github.com/github/rest-api-description)

## Related

- [Swift OpenAPI Generator](https://github.com/apple/swift-openapi-generator)
- [GitHub REST API Documentation](https://docs.github.com/en/rest)
- [GitHub REST API Description](https://github.com/github/rest-api-description)
