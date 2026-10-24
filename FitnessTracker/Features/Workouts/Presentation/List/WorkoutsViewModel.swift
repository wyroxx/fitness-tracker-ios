import Observation

@MainActor
@Observable
final class WorkoutsViewModel {
    var workouts: [Workout] = []

    // TODO: Inject WorkoutRepository and implement loading and saving.
}
