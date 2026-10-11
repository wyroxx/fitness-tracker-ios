import SwiftUI

struct WorkoutEditorView: View {
    @State private var isSelectingExercise = false
    @State private var isPresented = false
    let muscleGroupsViewModel: MuscleGroupsViewModel
    let exerciseRepository: ExerciseRepository
    
    var body: some View {
        Button("Show Sheet") {
            isPresented.toggle()
        }
        .sheet(isPresented: $isPresented) {
            VStack(spacing: 8) {
                Text("New workout")
                    .font(.system(size: 22, weight: .semibold))
                    .padding(.vertical, 20)
                WorkoutExerciseCard(
                    exercise: WorkoutExercise(
                        id: 1,
                        name: "Bench Press",
                        sets: [
                            WorkoutSet(
                                setNumber: 1, weight: 40, reps: 12
                            ),
                            WorkoutSet(
                                setNumber: 2, weight: 50, reps: 11
                            ),
                            WorkoutSet(
                                setNumber: 3, weight: 60, reps: 11
                            )
                        ]
                    )
                )
                Spacer()
                HStack(spacing: 60) {
                    Button("Add exercise") {
                        isSelectingExercise = true
                    }
                    .fullScreenCover(isPresented: $isSelectingExercise) {
                        NavigationStack {
                            MuscleGroupsView(
                                viewModel: muscleGroupsViewModel,
                                exerciseRepository: exerciseRepository
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
            .presentationBackground(.white)
            .presentationDetents([.medium, .large])
        }
    }
}
