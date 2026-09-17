import Observation

@MainActor
@Observable
final class ExerciseViewModel {
    private let repository: ExerciseRepository
    
    var isLoading: Bool = false
    var error: Error?
    var exercises: [Exercise] = []
    
    init(repository: ExerciseRepository) {
        self.repository = repository
    }
    
    func load(muscleGroupId: Int) async {
        isLoading = true
        error = nil
        
        do {
            exercises = try await repository.getExercises(muscleGroupId: muscleGroupId)
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
}
