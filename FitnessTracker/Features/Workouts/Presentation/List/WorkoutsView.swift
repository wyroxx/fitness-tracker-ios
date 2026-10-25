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
            .padding(.bottom, 88)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("My Trainings")
                    .font(.system(size: 22, weight: .semibold))
            }
        }
        .task {
            await viewModel.load()
        }
        .overlay(alignment: .bottomTrailing) {
            Button {
                isWorkoutEditorPresented = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 28, weight: .medium))
                    .foregroundStyle(.white)
                    .frame(width: 65, height: 65)
                    .background(
                        LinearGradient(
                            stops: [
                                .init(color: Color(red: 51 / 255, green: 98 / 255, blue: 159 / 255), location: 0),
                                .init(color: Color(red: 57 / 255, green: 129 / 255, blue: 224 / 255), location: 0.65)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        in: Circle()
                    )
            }
            .buttonStyle(AddWorkoutButtonStyle())
            .accessibilityLabel("Add workout")
            .padding(24)
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

private struct AddWorkoutButtonStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .brightness(configuration.isPressed ? -0.06 : 0)
            .scaleEffect(configuration.isPressed && !reduceMotion ? 0.94 : 1)
            .animation(
                reduceMotion ? nil : .easeOut(duration: 0.15),
                value: configuration.isPressed
            )
    }
}
