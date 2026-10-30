enum APIError: Error {
    case missingAccessToken
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError
}
