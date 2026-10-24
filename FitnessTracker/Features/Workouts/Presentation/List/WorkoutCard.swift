import SwiftUI

struct WorkoutCard: View {
    let workout: Workout
    @State private var expandedExerciseIndices: Set<Int> = []

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline, spacing: 12) {
                Text(workout.title)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.primary)
                    .layoutPriority(1)

                Spacer(minLength: 0)

                Text(workout.startedAt)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            VStack(alignment: .leading, spacing: 8) {
                ForEach(workout.exercises.indices, id: \.self) { index in
                    let exercise = workout.exercises[index]
                    let isExpanded = expandedExerciseIndices.contains(index)

                    VStack(alignment: .leading, spacing: 0) {
                        Button {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                if expandedExerciseIndices.contains(index) {
                                    expandedExerciseIndices.remove(index)
                                } else {
                                    expandedExerciseIndices.insert(index)
                                }
                            }
                        } label: {
                            HStack(alignment: .firstTextBaseline, spacing: 12) {
                                Text("\(index + 1). \(exercise.name) ×\(exercise.sets.count)")
                                    .font(.body)
                                    .fixedSize(horizontal: false, vertical: true)

                                Spacer(minLength: 0)

                                Image(systemName: "chevron.right")
                                    .font(.subheadline.weight(.semibold))
                                    .rotationEffect(.degrees(expandedExerciseIndices.contains(index) ? 90 : 0))
                                    .accessibilityHidden(true)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .accessibilityValue(expandedExerciseIndices.contains(index) ? "Expanded" : "Collapsed")

                        VStack(alignment: .leading, spacing: 6) {
                            ForEach(exercise.sets.indices, id: \.self) { setIndex in
                                let set = exercise.sets[setIndex]
                                Text("Set \(set.setNumber): \(set.weight.map { String($0) } ?? "—") kg × \(set.reps.map { String($0) } ?? "—")")
                                    .font(.body)
                            }
                        }
                        .padding(.leading, 24)
                        .padding(.top, 8)
                        .padding(.bottom, 4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(height: isExpanded ? nil : 0, alignment: .top)
                        .clipped()
                        .accessibilityHidden(!isExpanded)
                    }
                    .foregroundStyle(.secondary)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    WorkoutCard(
        workout: Workout(
            title: "Chest & Triceps",
            startedAt: "Oct 27, Tue",
            exercises: [
                WorkoutExercise(
                    id: 1,
                    name: "Bench Press",
                    sets: [
                        WorkoutSet(
                            setNumber: 1,
                            weight: 60,
                            reps: 10
                        ),
                        WorkoutSet(
                            setNumber: 2,
                            weight: 65,
                            reps: 10
                        ),
                        WorkoutSet(
                            setNumber: 3,
                            weight: 65,
                            reps: 9
                        ),
                    ]
                ),
                WorkoutExercise(
                    id: 2,
                    name: "Chest Fly",
                    sets: [
                        WorkoutSet(
                            setNumber: 1,
                            weight: 45,
                            reps: 12
                        ),
                        WorkoutSet(
                            setNumber: 2,
                            weight: 45,
                            reps: 11
                        ),
                        WorkoutSet(
                            setNumber: 3,
                            weight: 50,
                            reps: 9
                        ),
                    ]
                ),
            ]
        )
    )
    .padding()
    .frame(maxHeight: .infinity, alignment: .top)
    .background(Color(.systemGroupedBackground))
}
