import SwiftUI

@main
struct FitnessTrackerApp: App {
    private let exerciseRepository: ExerciseRepository
    private let muscleGroupRepository: MuscleGroupRepository
    
    init() {
        let apiClient = APIClient(
            baseURL: "http://localhost:8080",
            token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjo2LCJ0eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzkyNzYwMTkxLCJpYXQiOjE3OTI3NTkyOTF9.2yI_AevTEgi79aVUVIPEZ11ey_BTspkkxbG2DdI5rz0"
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
