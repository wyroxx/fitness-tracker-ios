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
        try authorize(&request)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200...299).contains(response.statusCode) else {
            throw APIError.httpError(statusCode: response.statusCode)
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingError
        }
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
        if requiresAuth {
            try authorize(&request)
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        request.httpBody = try encoder.encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let response = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard (200...299).contains(response.statusCode) else {
            throw APIError.httpError(statusCode: response.statusCode)
        }

        if let ignoredResponse = IgnoredResponse() as? Response {
            return ignoredResponse
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(Response.self, from: data)
        } catch {
            throw APIError.decodingError
        }
    }
    private func authorize(_ request: inout URLRequest) throws {
        guard let tokens = try tokenStorage.read(), !tokens.accessToken.isEmpty else {
            throw APIError.missingAccessToken
        }
        request.setValue("Bearer \(tokens.accessToken)", forHTTPHeaderField: "Authorization")
    }
}

