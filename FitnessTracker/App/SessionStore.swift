import Foundation
import Observation

@MainActor
@Observable
final class SessionStore {
    var state: AuthSession
    private let repository: AuthRepository
    private(set) var restorationError: String?
    private var isRestoring = false

    init(repository: AuthRepository, state: AuthSession = .unknown) {
        self.repository = repository
        self.state = state
    }

    func restore() async {
        guard state == .unknown, !isRestoring else { return }
        isRestoring = true
        restorationError = nil
        defer { isRestoring = false }

        do {
            let restored = try await repository.restoreSession()
            state = restored ? .signedIn : .signedOut
        } catch {
            restorationError = "Unable to restore your session. Check your connection and try again."
        }
    }
}
