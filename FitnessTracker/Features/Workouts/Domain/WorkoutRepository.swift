protocol WorkoutRepository {
    func getWorkouts() async throws -> [Workout]
    func createWorkout(_ workout: Workout) async throws
}
