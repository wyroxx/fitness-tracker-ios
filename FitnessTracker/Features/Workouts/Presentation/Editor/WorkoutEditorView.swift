import SwiftUI

struct WorkoutEditorView: View {
    @State private var workoutEditorViewModel = WorkoutEditorViewModel()
    @State private var isSelectingExercise = false
    let muscleGroupsViewModel: MuscleGroupsViewModel
    let exerciseRepository: ExerciseRepository

    var body: some View {
        VStack(spacing: 8) {
            Text("New workout")
                .font(.system(size: 22, weight: .semibold))
                .padding(.vertical, 20)
            if workoutEditorViewModel.exercises.isEmpty {
                Text("Add your first exercise")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(workoutEditorViewModel.exercises.indices, id: \.self) { index in
                            WorkoutExerciseCard(
                                exercise: workoutEditorViewModel.exercises[index]
                            )
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            HStack(spacing: 60) {
                Button("Add exercise") {
                    isSelectingExercise = true
                }
                .fullScreenCover(isPresented: $isSelectingExercise) {
                    NavigationStack {
                        MuscleGroupsView(
                            viewModel: muscleGroupsViewModel,
                            exerciseRepository: exerciseRepository,
                            onExerciseAdded: { exercise in
                                workoutEditorViewModel.exercises.append(exercise)
                                isSelectingExercise = false
                            }
                        )
                    }
                }
                Button("Save") {

                }
                .foregroundStyle(.white)
                .padding(EdgeInsets(top: 10, leading: 18, bottom: 10, trailing: 18))
                .background(
                    LinearGradient(
                        stops: [
                            .init(color: Color(red: 51 / 255, green: 98 / 255, blue: 159 / 255), location: 0),
                            .init(color: Color(red: 57 / 255, green: 129 / 255, blue: 224 / 255), location: 0.65)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}
