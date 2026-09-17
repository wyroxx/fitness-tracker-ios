struct MuscleGroupRepositoryImpl: MuscleGroupRepository {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getMuscleGroups() async throws -> [MuscleGroup] {
        try await apiClient.get("/muscle-groups")
    }
}
