import Foundation

struct IgnoredResponse: Decodable {}

final class APIClient {
    private let baseURL: String
    private let tokenStorage: TokenStorage
    
    init(baseURL: String, tokenStorage: TokenStorage) {
        self.baseURL = baseURL
        self.tokenStorage = tokenStorage
    }
    
    func get<T: Decodable>(_ endpoint: String) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let data = try await execute(request)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return try decoder.decode(T.self, from: data)
    }
    
    func post<Body: Encodable, Response: Decodable>(
        _ endpoint: String,
        body: Body,
        requiresAuth: Bool = true
    ) async throws -> Response {
        guard let url = URL(string: baseURL + endpoint) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        request.httpBody = try encoder.encode(body)
        
        let data = try await execute(request, requiresAuth: requiresAuth)

        if let ignoredResponse = IgnoredResponse() as? Response {
            return ignoredResponse
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return try decoder.decode(Response.self, from: data)
    }
    
    private func authorize(_ request: inout URLRequest) throws {
        guard let tokens = try tokenStorage.read(), !tokens.accessToken.isEmpty else {
            throw APIError.missingAccessToken
        }
        request.setValue("Bearer \(tokens.accessToken)", forHTTPHeaderField: "Authorization")
    }
    
    private func execute(
        _ originalRequest: URLRequest,
        requiresAuth: Bool = true
    ) async throws -> Data {
        var request = originalRequest
        
        if requiresAuth {
            try authorize(&request)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        if httpResponse.statusCode == 401 && requiresAuth {
            try await refreshTokens()
            try authorize(&request)
            
            let (retryData, retryResponse) = try await URLSession.shared.data(for: request)
            
            guard let retryHTTP = retryResponse as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            guard (200...299).contains(retryHTTP.statusCode) else {
                throw APIError.httpError(statusCode: retryHTTP.statusCode)
            }
            return retryData
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.httpError(statusCode: httpResponse.statusCode)
        }

        return data
    }
    
    private func refreshTokens() async throws {
        guard let tokens = try tokenStorage.read(), !tokens.refreshToken.isEmpty else {
            throw APIError.missingAccessToken
        }

        let newTokens: AuthTokens = try await post(
            "/auth/refresh",
            body: RefreshRequest(refreshToken: tokens.refreshToken),
            requiresAuth: false
        )

        try tokenStorage.save(newTokens)
    }
}

private struct RefreshRequest: Encodable {
    let refreshToken: String
}
