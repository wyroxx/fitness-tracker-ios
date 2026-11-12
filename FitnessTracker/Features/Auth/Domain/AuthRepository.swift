protocol AuthRepository {
    func login(email: String, password: String) async throws
    func register(name: String, email: String, password: String) async throws
    func restoreSession() async throws -> Bool
}
