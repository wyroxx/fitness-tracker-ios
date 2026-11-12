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
            MainView(
                exerciseRepository: exerciseRepository,
                muscleGroupRepository: muscleGroupRepository,
                workoutRepository: workoutRepository
            )
        }
    }
}

private struct AuthFlowView: View {
    private enum AuthScreen {
        case login
        case register
    }

    @State private var screen: AuthScreen = .login
    @State private var loginViewModel: LoginViewModel
    @State private var registerViewModel: RegisterViewModel

    init(repository: AuthRepository, sessionStore: SessionStore) {
        _loginViewModel = State(initialValue: LoginViewModel(
            repository: repository,
            sessionStore: sessionStore
        ))
        _registerViewModel = State(
            initialValue: RegisterViewModel(repository: repository)
        )
    }

    var body: some View {
        ZStack {
            switch screen {
            case .login:
                LoginView(
                    isLoading: loginViewModel.isLoading,
                    errorMessage: loginViewModel.errorMessage,
                    onSignIn: { email, password in
                        Task {
                            await loginViewModel.login(email: email, password: password)
                        }
                    },
                    onSignUp: { screen = .register }
                )
                .transition(.opacity)

            case .register:
                RegisterView(
                    isLoading: registerViewModel.isLoading,
                    errorMessage: registerViewModel.errorMessage,
                    onSignUp: { name, email, password in
                        Task {
                            let success = await registerViewModel.register(
                                name: name,
                                email: email,
                                password: password
                            )
                            if success {
                                screen = .login
                            }
                        }
                    },
                    onSignIn: { screen = .login }
                )
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: screen)
    }
}
