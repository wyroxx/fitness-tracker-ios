import SwiftUI

struct ExercisesView: View {
    let muscleGroup: MuscleGroup
    let onExerciseAdded: (WorkoutExercise) -> Void
    @State private var viewModel: ExercisesViewModel
    @State private var selectedExercise: Exercise?
    
    init(
        muscleGroup: MuscleGroup,
        repository: ExerciseRepository,
        onExerciseAdded: @escaping (WorkoutExercise) -> Void
    ) {
        self.muscleGroup = muscleGroup
        self.onExerciseAdded = onExerciseAdded
        _viewModel = State(initialValue: ExercisesViewModel(repository: repository))
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = viewModel.error {
                VStack(spacing: 12) {
                    Text("Failed to exercises")
                        .font(.headline)
                    Text(error.localizedDescription)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Button("Retry") {
                        Task {
                            await viewModel.load(muscleGroupId: muscleGroup.id)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.exercises, id: \.id) { exercise in
                            Button {
                                selectedExercise = exercise
                            } label: {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(exercise.name)
                                        .font(.headline)

                                    Text(exercise.description)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(
                                    color: .black.opacity(0.1),
                                    radius: 8
                                )
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(muscleGroup.name)
                    .font(.system(size: 22, weight: .semibold))
            }
        }
        .overlay {
            if let exercise = selectedExercise {
                ZStack {
                    Color.black.opacity(0.35)
                        .ignoresSafeArea()
                        .onTapGesture {
                            selectedExercise = nil
                        }

                    WorkoutSetView(
                        exercise: WorkoutExercise(
                            id: exercise.id,
                            name: exercise.name,
                            sets: [
                                WorkoutSet(setNumber: 1, weight: nil, reps: nil),
                                WorkoutSet(setNumber: 2, weight: nil, reps: nil)
                            ]
                        ),
                        onSave: { updatedExercise in
                            onExerciseAdded(updatedExercise)
                            selectedExercise = nil
                        },
                        onCancel: {
                            selectedExercise = nil
                        }
                    )
                    .transition(.scale.combined(with: .opacity))
                }
                .animation(.easeInOut(duration: 0.2), value: selectedExercise != nil)
            }
        }
        .task {
            await viewModel.load(muscleGroupId: muscleGroup.id)
        }
    }
}
