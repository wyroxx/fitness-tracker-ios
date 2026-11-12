import SwiftUI

@main
struct FitnessTrackerApp: App {
    @State private var sessionStore = SessionStore(state: .unknown)

    private let authRepository: AuthRepository
    private let exerciseRepository: ExerciseRepository
    private let muscleGroupRepository: MuscleGroupRepository
    private let workoutRepository: WorkoutRepository
    
    init() {
        let storage = KeychainTokenStorage()
        let apiClient = APIClient(
            baseURL: "http://localhost:8080",
            tokenStorage: storage
        )
        
        self.authRepository = AuthRepositoryImpl(storage: storage, apiClient: apiClient)
        self.exerciseRepository = ExerciseRepositoryImpl(apiClient: apiClient)
        self.muscleGroupRepository = MuscleGroupRepositoryImpl(apiClient: apiClient)
        self.workoutRepository = WorkoutRepositoryImpl(apiClient: apiClient)
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(
                sessionStore: sessionStore,
                authRepository: authRepository,
                exerciseRepository: exerciseRepository,
                muscleGroupRepository: muscleGroupRepository,
                workoutRepository: workoutRepository
            )
        }
    }
}
