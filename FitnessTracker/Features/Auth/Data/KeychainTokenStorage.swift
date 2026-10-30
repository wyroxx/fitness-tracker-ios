import Foundation
import KeychainAccess

final class KeychainTokenStorage: TokenStorage {
    private let keychain = Keychain(
        service: "com.example.FitnessTracker.auth"
    )
    .accessibility(.whenUnlockedThisDeviceOnly)

    func save(_ tokens: AuthTokens) throws {
        let data = try JSONEncoder().encode(tokens)
        try keychain.set(data, key: "tokens")
    }

    func read() throws -> AuthTokens? {
        guard let data = try keychain.getData("tokens") else {
            return nil
        }

        return try JSONDecoder().decode(AuthTokens.self, from: data)
    }

    func clear() throws {
        try keychain.remove("tokens")
    }
}
