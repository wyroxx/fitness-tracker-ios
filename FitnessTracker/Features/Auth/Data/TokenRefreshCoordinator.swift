import Foundation

@MainActor
final class TokenRefreshCoordinator {
    private let baseURL: String
    private let storage: TokenStorage
    private let session: URLSession
    private var refreshTask: Task<Void, Error>?

    init(baseURL: String, storage: TokenStorage, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.storage = storage
        self.session = session
    }

    func refresh(rejectedAccessToken: String? = nil) async throws {
        if let refreshTask {
            return try await refreshTask.value
        }

        guard let tokens = try storage.read(), !tokens.refreshToken.isEmpty else {
            throw APIError.missingRefreshToken
        }
        if let rejectedAccessToken,
           tokens.accessToken != rejectedAccessToken,
           !tokens.accessToken.isEmpty {
            return
        }

        let task = Task { @MainActor in
            guard let url = URL(string: baseURL + "/auth/refresh") else {
                throw APIError.invalidURL
            }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            request.httpBody = try encoder.encode(RefreshRequest(refreshToken: tokens.refreshToken))

            let (data, response) = try await session.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            guard (200...299).contains(response.statusCode) else {
                throw APIError.httpError(statusCode: response.statusCode)
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let newTokens = try decoder.decode(AuthTokens.self, from: data)
            guard !newTokens.accessToken.isEmpty, !newTokens.refreshToken.isEmpty else {
                throw APIError.invalidResponse
            }
            try storage.save(newTokens)
        }
        refreshTask = task
        defer { refreshTask = nil }
        try await task.value
    }
}

private struct RefreshRequest: Encodable {
    let refreshToken: String
}
