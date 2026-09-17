import Observation

@MainActor
@Observable
final class MuscleGroupsViewModel {
    private let repository: MuscleGroupRepository
    var isLoading: Bool = false
    var error: Error?
    var muscleGroups: [MuscleGroup] = []
    
    init(repository: MuscleGroupRepository) {
        self.repository = repository
    }
    
    func load() async {
        guard muscleGroups.isEmpty else {
            return
        }
        
        isLoading = true
        error = nil
        
        do {
            muscleGroups = try await repository.getMuscleGroups()
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    func reload() async {
        isLoading = true
        error = nil

        do {
            muscleGroups = try await repository.getMuscleGroups()
        } catch {
            self.error = error
        }

        isLoading = false
    }
}
