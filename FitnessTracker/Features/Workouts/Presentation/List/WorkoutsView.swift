import SwiftUI

struct WorkoutsView: View {
    @State private var viewModel: WorkoutsViewModel
    @State private var isWorkoutEditorPresented = false

    let muscleGroupsViewModel: MuscleGroupsViewModel
    let exerciseRepository: ExerciseRepository

    // Temporary: set to false to display the repository results.
    private let useMockData = true

    init(
        viewModel: WorkoutsViewModel,
        muscleGroupsViewModel: MuscleGroupsViewModel,
        exerciseRepository: ExerciseRepository
    ) {
        _viewModel = State(initialValue: viewModel)
        self.muscleGroupsViewModel = muscleGroupsViewModel
        self.exerciseRepository = exerciseRepository
    }

    private var displayedWorkouts: [Workout] {
        useMockData ? Self.mockWorkouts : viewModel.workouts
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                if !useMockData && viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.top, 32)
                } else if !useMockData, let error = viewModel.error {
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
                } else if displayedWorkouts.isEmpty {
                    Text("No workouts yet")
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 32)
                } else {
                    ForEach(displayedWorkouts.indices, id: \.self) { index in
                        WorkoutCard(workout: displayedWorkouts[index])
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
                muscleGroupsViewModel: muscleGroupsViewModel,
                exerciseRepository: exerciseRepository
            )
            .presentationBackground(.white)
            .presentationDetents([.medium, .large])
            // TODO: Handle the editor's save callback when workout saving is implemented.
        }
    }

    private static let mockWorkouts: [Workout] = [
        Workout(
            title: "Upper",
            startedAt: "Oct 24, Sat",
            exercises: [
                WorkoutExercise(id: 1, name: "Bench Press", sets: [
                    WorkoutSet(setNumber: 1, weight: 60, reps: 12),
                    WorkoutSet(setNumber: 2, weight: 65, reps: 10),
                    WorkoutSet(setNumber: 3, weight: 65, reps: 9)
                ]),
                WorkoutExercise(id: 2, name: "Cable chest fly", sets: [
                    WorkoutSet(setNumber: 1, weight: 20, reps: 12),
                    WorkoutSet(setNumber: 2, weight: 25, reps: 10)
                ])
            ]
        ),
        Workout(
            title: "Lower",
            startedAt: "Oct 22, Thu",
            exercises: [
                WorkoutExercise(id: 3, name: "Leg press", sets: [
                    WorkoutSet(setNumber: 1, weight: 70, reps: 14),
                    WorkoutSet(setNumber: 2, weight: 80, reps: 12),
                    WorkoutSet(setNumber: 3, weight: 80, reps: 10)
                ]),
                WorkoutExercise(id: 4, name: "Romanian deadlift", sets: [
                    WorkoutSet(setNumber: 1, weight: 40, reps: 12),
                    WorkoutSet(setNumber: 2, weight: 45, reps: 10)
                ])
            ]
        )
    ]
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
