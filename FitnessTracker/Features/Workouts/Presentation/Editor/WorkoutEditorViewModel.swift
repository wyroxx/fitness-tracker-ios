import Observation
import Foundation

@Observable
@MainActor
final class WorkoutEditorViewModel {
    private let repository: WorkoutRepository
    private let startedAt = Date()

    var title = "New workout"
    var exercises: [WorkoutExercise] = []
    private(set) var isSaving = false
    private(set) var error: Error?

    init(repository: WorkoutRepository) {
        self.repository = repository
    }

    var canSave: Bool {
        !isSaving && !exercises.isEmpty
            && !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func save() async -> Bool {
        guard canSave else { return false }
        isSaving = true
        error = nil
        defer { isSaving = false }

        let workout = Workout(
            title: title,
            startedAt: ISO8601DateFormatter().string(from: startedAt),
            exercises: exercises
        )

        do {
            try await repository.createWorkout(workout)
            return true
        } catch {
            self.error = error
            return false
        }
    }
}
