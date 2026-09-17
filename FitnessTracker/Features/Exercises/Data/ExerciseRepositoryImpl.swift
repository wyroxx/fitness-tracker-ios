struct ExerciseRepositoryImpl: ExerciseRepository {
    let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getExercises(muscleGroupId: Int) async throws -> [Exercise] {
        try await apiClient.get("/muscle-groups/\(muscleGroupId)/workout-types")
    }
}
