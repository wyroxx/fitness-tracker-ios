enum APIError: Error {
    case missingRefreshToken
    case missingAccessToken
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError
}
