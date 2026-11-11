import Foundation
import Observation

@MainActor
@Observable
final class RegisterViewModel {
    private let repository: AuthRepository
    
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func register(
        name: String,
        email: String,
        password: String
    ) async -> Bool {
        guard !isLoading else { return false }
        
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            try await repository.register(
                name: name,
                email: email,
                password: password
            )
            return true
        } catch is CancellationError {
            return false
        } catch {
            errorMessage = "Unable to create account. Please try again."
            return false
        }
    }
}
