import Observation

@MainActor
@Observable
final class WorkoutsViewModel {
    private let repository: WorkoutRepository

    var workouts: [Workout] = []
    var isLoading: Bool = false
    var error: Error?

    init(workouts: [Workout], repository: WorkoutRepository) {
        self.workouts = workouts
        self.repository = repository
    }

    func load() async {
        guard workouts.isEmpty else {
            return
        }

        isLoading = true
        error = nil

        do {
            workouts = try await repository.getWorkouts()
        } catch {
            self.error = error
        }

        isLoading = false
    }
}
