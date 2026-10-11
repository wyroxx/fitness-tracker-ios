import SwiftUI

@main
struct FitnessTrackerApp: App {
    private let exerciseRepository: ExerciseRepository
    private let muscleGroupRepository: MuscleGroupRepository
    
    init() {
        let apiClient = APIClient(
            baseURL: "http://localhost:8080",
            token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjo2LCJ0eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzkxNzI5ODYzLCJpYXQiOjE3OTE3Mjg5NjN9.bh0QSa5OUWJuXwh3oh4lhseM1VimHD4Ed5fusVTl9q8"
        )
        
        self.exerciseRepository = ExerciseRepositoryImpl(apiClient: apiClient)
        self.muscleGroupRepository = MuscleGroupRepositoryImpl(apiClient: apiClient)
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                WorkoutEditorView(
                    muscleGroupsViewModel: MuscleGroupsViewModel(
                        repository: muscleGroupRepository
                    ),
                    exerciseRepository: exerciseRepository
                )
            }
        }
    }
}
