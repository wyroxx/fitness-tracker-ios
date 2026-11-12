struct AuthRepositoryImpl: AuthRepository {
    private let storage: TokenStorage
    private let apiClient: APIClient
    private let refreshCoordinator: TokenRefreshCoordinator
    
    init(storage: TokenStorage, apiClient: APIClient, refreshCoordinator: TokenRefreshCoordinator) {
        self.storage = storage
        self.apiClient = apiClient
        self.refreshCoordinator = refreshCoordinator
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
    
    func restoreSession() async throws -> Bool {
        guard let tokens = try storage.read() else { return false }
        guard !tokens.refreshToken.isEmpty else {
            try storage.clear()
            return false
        }
        do {
            try await refreshCoordinator.refresh()
            return true
        } catch APIError.httpError(statusCode: 401) {
            try storage.clear()
            return false
        }
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
