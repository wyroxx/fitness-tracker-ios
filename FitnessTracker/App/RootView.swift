import SwiftUI

struct RootView: View {
    let sessionStore: SessionStore
    let exerciseRepository: ExerciseRepository
    let muscleGroupRepository: MuscleGroupRepository
    let workoutRepository: WorkoutRepository

    var body: some View {
        switch sessionStore.state {
        case .unknown:
            ProgressView()

        case .signedOut:
            AuthFlowView()

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

    var body: some View {
        NavigationStack {
            LoginView(onSignUp: { showsRegistration = true })
                .navigationDestination(isPresented: $showsRegistration) {
                    RegisterView(onSignIn: { showsRegistration = false })
                }
        }
    }
}
