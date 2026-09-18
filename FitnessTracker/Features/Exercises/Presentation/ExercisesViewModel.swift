import Observation

@MainActor
@Observable
final class ExercisesViewModel {
    private let repository: ExerciseRepository
    
    var isLoading: Bool = false
    var error: Error?
    var exercises: [Exercise] = []
    
    init(repository: ExerciseRepository) {
        self.repository = repository
    }
    
    func load(muscleGroupId: Int) async {
        guard exercises.isEmpty else {
            return
        }
        
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
