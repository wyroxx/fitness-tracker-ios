import SwiftUI

@main
struct FitnessTrackerApp: App {
    private let exerciseRepository: ExerciseRepository
    private let muscleGroupRepository: MuscleGroupRepository
    
    init() {
        let apiClient = APIClient(
            baseURL: "http://localhost:8080",
            token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjo2LCJ0eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzkyODQ5Nzg1LCJpYXQiOjE3OTI4NDg4ODV9.YcwMUECDa5svztFCWmGtf9bSemZbZwdyhwaxjhL6zAI"
        )
        
        self.exerciseRepository = ExerciseRepositoryImpl(apiClient: apiClient)
        self.muscleGroupRepository = MuscleGroupRepositoryImpl(apiClient: apiClient)
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                WorkoutsView(
                    muscleGroupsViewModel: MuscleGroupsViewModel(
                        repository: muscleGroupRepository
                    ),
                    exerciseRepository: exerciseRepository
                )
            }
        }
    }
}
