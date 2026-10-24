struct WorkoutRepositoryImpl: WorkoutRepository {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getWorkouts() async throws -> [Workout] {
        try await apiClient.get("/trainings")
    }
}
