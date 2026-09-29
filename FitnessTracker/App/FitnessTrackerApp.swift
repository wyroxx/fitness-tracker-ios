import SwiftUI

@main
struct FitnessTrackerApp: App {
    private let exerciseRepository: ExerciseRepository
    private let muscleGroupRepository: MuscleGroupRepository
    
    init() {
        let apiClient = APIClient(
            baseURL: "http://localhost:8080",
            token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjo2LCJ0eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzkwNjY5ODUyLCJpYXQiOjE3OTA2Njg5NTJ9.cBXcr6wYXeh6dyhqXUAwRoho0b6Y10qB9QDP4I502Ig"
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
