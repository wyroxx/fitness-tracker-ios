import SwiftUI

@main
struct FitnessTrackerApp: App {
    @State private var sessionStore: SessionStore

    private let authRepository: AuthRepository
    private let exerciseRepository: ExerciseRepository
    private let muscleGroupRepository: MuscleGroupRepository
    private let workoutRepository: WorkoutRepository
    
    init() {
        let storage = KeychainTokenStorage()
        let baseURL = "http://localhost:8080"
        let refreshCoordinator = TokenRefreshCoordinator(baseURL: baseURL, storage: storage)
        let apiClient = APIClient(
            baseURL: baseURL,
            tokenStorage: storage,
            refreshCoordinator: refreshCoordinator
        )
        
        let authRepository = AuthRepositoryImpl(
            storage: storage,
            apiClient: apiClient,
            refreshCoordinator: refreshCoordinator
        )
        self.authRepository = authRepository
        _sessionStore = State(initialValue: SessionStore(repository: authRepository))
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
            .task {
                await sessionStore.restore()
            }
        }
    }
}
