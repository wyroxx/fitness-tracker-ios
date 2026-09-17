import SwiftUI

@main
struct FitnessTrackerApp: App {
    
    private let apiClient = APIClient(
        baseURL: "http://localhost:8080",
        token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjo2LCJ0eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzg5NjU0MjI2LCJpYXQiOjE3ODk2NTMzMjZ9.tE7kG6yel8laqCkJp8GpuzJDPxfGzbj-Gg0iNJ_MzFI"
    )
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MuscleGroupsView(
                    viewModel: MuscleGroupsViewModel(
                        repository: MuscleGroupRepositoryImpl(
                            apiClient: apiClient
                        )
                    ),
                    exerciseViewModel: ExerciseViewModel(
                        repository: ExerciseRepositoryImpl(
                            apiClient: apiClient
                        )
                    )
                )
            }
        }
    }
}
