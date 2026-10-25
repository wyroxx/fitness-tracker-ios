struct WorkoutRepositoryImpl: WorkoutRepository {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getWorkouts() async throws -> [Workout] {
        try await apiClient.get("/trainings")
    }

    func createWorkout(_ workout: Workout) async throws {
        let request = CreateWorkoutRequest(
            title: workout.title,
            startedAt: workout.startedAt,
            sessions: [workout]
        )
        try await apiClient.post("/trainings", body: request)
    }
}
