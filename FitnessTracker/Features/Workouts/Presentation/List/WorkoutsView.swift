import SwiftUI

struct WorkoutsView: View {
    @State private var viewModel: WorkoutsViewModel
    @State private var isWorkoutEditorPresented = false

    let muscleGroupsViewModel: MuscleGroupsViewModel
    let exerciseRepository: ExerciseRepository
    let workoutRepository: WorkoutRepository

    init(
        viewModel: WorkoutsViewModel,
        muscleGroupsViewModel: MuscleGroupsViewModel,
        exerciseRepository: ExerciseRepository,
        workoutRepository: WorkoutRepository
    ) {
        _viewModel = State(initialValue: viewModel)
        self.muscleGroupsViewModel = muscleGroupsViewModel
        self.exerciseRepository = exerciseRepository
        self.workoutRepository = workoutRepository
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.top, 32)
                } else if let error = viewModel.error {
                    VStack(spacing: 12) {
                        Text("Failed to load workouts")
                            .font(.headline)
                        Text(error.localizedDescription)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            Task {
                                await viewModel.load()
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 32)
                } else if viewModel.workouts.isEmpty {
                    Text("No workouts yet")
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 32)
                } else {
                    ForEach(viewModel.workouts.indices, id: \.self) { index in
                        WorkoutCard(workout: viewModel.workouts[index])
                    }
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("My Trainings")
                    .font(.system(size: 22, weight: .semibold))
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isWorkoutEditorPresented = true
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("Add workout")
            }
        }
        .task {
            await viewModel.load()
        }
        .sheet(isPresented: $isWorkoutEditorPresented) {
            WorkoutEditorView(
                viewModel: WorkoutEditorViewModel(repository: workoutRepository),
                muscleGroupsViewModel: muscleGroupsViewModel,
                exerciseRepository: exerciseRepository,
                onSaved: {
                    isWorkoutEditorPresented = false
                    Task {
                        await viewModel.load(force: true)
                    }
                }
            )
            .presentationBackground(.white)
            .presentationDetents([.medium, .large])
        }
    }
}
