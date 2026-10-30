import SwiftUI

struct RootView: View {
    let sessionStore: SessionStore
    let authRepository: AuthRepository
    let exerciseRepository: ExerciseRepository
    let muscleGroupRepository: MuscleGroupRepository
    let workoutRepository: WorkoutRepository

    var body: some View {
        switch sessionStore.state {
        case .unknown:
            ProgressView()

        case .signedOut:
            AuthFlowView(repository: authRepository, sessionStore: sessionStore)

        case .signedIn:
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

private struct AuthFlowView: View {
    @State private var showsRegistration = false
    @State private var loginViewModel: LoginViewModel

    init(repository: AuthRepository, sessionStore: SessionStore) {
        _loginViewModel = State(initialValue: LoginViewModel(
            repository: repository,
            sessionStore: sessionStore
        ))
    }

    var body: some View {
        NavigationStack {
            LoginView(
                isLoading: loginViewModel.isLoading,
                errorMessage: loginViewModel.errorMessage,
                onSignIn: { email, password in
                    Task {
                        await loginViewModel.login(email: email, password: password)
                    }
                },
                onSignUp: { showsRegistration = true }
            )
                .navigationDestination(isPresented: $showsRegistration) {
                    RegisterView(onSignIn: { showsRegistration = false })
                }
        }
    }
}
