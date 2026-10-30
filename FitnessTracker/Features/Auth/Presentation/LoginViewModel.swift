import Foundation
import Observation

@MainActor
@Observable
final class LoginViewModel {
    private let repository: AuthRepository
    private let sessionStore: SessionStore

    private(set) var isLoading = false
    private(set) var errorMessage: String?

    init(repository: AuthRepository, sessionStore: SessionStore) {
        self.repository = repository
        self.sessionStore = sessionStore
    }

    func login(email: String, password: String) async {
        guard !isLoading else { return }
        errorMessage = nil

        let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter your email and password."
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            try await repository.login(email: email, password: password)
            sessionStore.state = .signedIn
        } catch is CancellationError {
            return
        } catch let error as URLError {
            if error.code != .cancelled {
                errorMessage = "Unable to connect. Check your connection and try again."
            }
        } catch APIError.httpError(statusCode: 401) {
            errorMessage = "Incorrect email or password."
        } catch APIError.httpError(statusCode: 429) {
            errorMessage = "Too many attempts. Please try again later."
        } catch {
            errorMessage = "Unable to sign in. Please try again."
        }
    }
}
