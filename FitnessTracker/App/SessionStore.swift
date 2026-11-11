import Observation

@MainActor
@Observable
final class SessionStore {
    var state: AuthSession

    init(state: AuthSession = .unknown) {
        self.state = state
    }
}
