protocol ExerciseRepository {
    func getExercises(muscleGroupId: Int) async throws -> [Exercise]
}
