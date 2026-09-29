import SwiftUI

struct WorkoutSetView: View {
    let exercise: WorkoutExercise
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var sets: [WorkoutSet]

    init(exercise: WorkoutExercise) {
        self.exercise = exercise
        _sets = State(initialValue: exercise.sets)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text(exercise.name)
                    .font(.system(size: 20, weight: .medium))
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                }
            }
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 8),
                    GridItem(.flexible())
                ],
                spacing: 10
            ) {
                ForEach(sets.indices, id: \.self) { index in
                    WorkoutSetCard(
                        set: $sets[index]
                    )
                }
            }
            HStack(spacing: 60) {
                Button("Add set") {
                    if sets.count < 6 {
                        sets.append(
                            WorkoutSet(
                                setNumber: sets.count + 1,
                                weight: nil,
                                reps: nil
                            )
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
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.12), radius: 8)
        .padding(.horizontal, 32)
    }
}

#Preview {
    WorkoutSetView(
        exercise: WorkoutExercise(
            id: 1,
            name: "Bench Press",
            sets: [
                WorkoutSet(setNumber: 1, weight: 60, reps: 12),
                WorkoutSet(setNumber: 2, weight: 65, reps: 11),
            ]
        )
    )
}
