protocol TokenStorage {
    func read() throws -> AuthTokens?
    func save(_ tokens: AuthTokens) throws
    func clear() throws
}
