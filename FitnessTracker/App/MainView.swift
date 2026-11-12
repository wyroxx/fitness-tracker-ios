import SwiftUI

struct MainView: View {
    let exerciseRepository: ExerciseRepository
    let muscleGroupRepository: MuscleGroupRepository
    let workoutRepository: WorkoutRepository

    var body: some View {
        TabView {
            Tab("Workouts", systemImage: "dumbbell.fill") {
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

            Tab("Profile", systemImage: "person.fill") {
                NavigationStack {
                    ProfileView()
                }
            }
        }
    }
}
