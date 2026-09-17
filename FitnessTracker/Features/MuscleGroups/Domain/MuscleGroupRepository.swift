protocol MuscleGroupRepository {
    func getMuscleGroups() async throws -> [MuscleGroup]
}
