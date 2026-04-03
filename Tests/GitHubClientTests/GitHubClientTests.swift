import Testing
@testable import GitHubClient
import OpenAPIURLSession
import Foundation

@Suite("GitHubClient Tests")
struct GitHubClientTests {

    @Test("Client can be initialized with GitHub API URL")
    func clientInitialization() throws {
        let serverURL = try #require(URL(string: "https://api.github.com"))
        let transport = URLSessionTransport()

        let client = Client(serverURL: serverURL, transport: transport)
        #expect(true)  // Successfully created without error
    }

    @Test("Client can be initialized with custom server URL")
    func clientWithCustomServerURL() throws {
        let customURL = try #require(URL(string: "https://github.enterprise.com"))
        let transport = URLSessionTransport()

        let client = Client(serverURL: customURL, transport: transport)
        #expect(true)  // Successfully created without error
    }

    @Test("Multiple client instances can be created independently")
    func multipleClients() throws {
        let url1 = try #require(URL(string: "https://api.github.com"))
        let url2 = try #require(URL(string: "https://github.enterprise.com"))

        let client1 = Client(serverURL: url1, transport: URLSessionTransport())
        let client2 = Client(serverURL: url2, transport: URLSessionTransport())

        #expect(true)  // Both clients created successfully
    }
}
