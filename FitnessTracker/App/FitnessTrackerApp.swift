import SwiftUI

@main
struct FitnessTrackerApp: App {
    private let exerciseRepository: ExerciseRepository
    private let muscleGroupRepository: MuscleGroupRepository
    private let workoutRepository: WorkoutRepository
    
    init() {
        let apiClient = APIClient(
            baseURL: "http://localhost:8080",
            token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjo2LCJ0eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzkyOTU1MzI2LCJpYXQiOjE3OTI5NTQ0MjZ9.dJJTPPLcvaLaHYwzzEBKUSIEFj5WYVgCLK6SO3lQEQ0"
        )
        
        self.exerciseRepository = ExerciseRepositoryImpl(apiClient: apiClient)
        self.muscleGroupRepository = MuscleGroupRepositoryImpl(apiClient: apiClient)
        self.workoutRepository = WorkoutRepositoryImpl(apiClient: apiClient)
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                WorkoutsView(
                    viewModel: WorkoutsViewModel(
                        workouts: [],
                        repository: workoutRepository
                    ),
                    muscleGroupsViewModel: MuscleGroupsViewModel(
                        repository: muscleGroupRepository
                    ),
                    exerciseRepository: exerciseRepository,
                    workoutRepository: workoutRepository
                )
            }
        }
    }
}
