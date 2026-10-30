struct AuthRepositoryImpl: AuthRepository {
    private let storage: TokenStorage
    private let apiClient: APIClient
    
    init(storage: TokenStorage, apiClient: APIClient) {
        self.storage = storage
        self.apiClient = apiClient
    }
    
    func login(email: String, password: String) async throws {
        let request = LoginRequest(email: email, password: password)
        let tokens: AuthTokens = try await apiClient.post(
            "/auth/login",
            body: request,
            requiresAuth: false
        )
        try storage.save(tokens)
    }
}

struct LoginRequest: Encodable {
    let email: String
    let password: String
}
