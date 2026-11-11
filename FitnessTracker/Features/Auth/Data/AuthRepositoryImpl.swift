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
    
    func register(name: String, email: String, password: String) async throws {
        let request = RegisterRequest(name: name, email: email, password: password)
        let _: IgnoredResponse = try await apiClient.post(
            "/users",
            body: request,
            requiresAuth: false
        )
    }
}

struct LoginRequest: Encodable {
    let email: String
    let password: String
}

struct RegisterRequest: Encodable {
    let name: String
    let email: String
    let password: String
}
