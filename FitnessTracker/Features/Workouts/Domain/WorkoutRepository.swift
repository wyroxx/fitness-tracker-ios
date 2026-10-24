protocol WorkoutRepository {
    func getWorkouts() async throws -> [Workout]
}
