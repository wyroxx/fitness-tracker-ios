import SwiftUI

struct WorkoutExerciseCard: View {
    let exercise: WorkoutExercise
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("\(exercise.name) ×\(exercise.sets.count)")
                .font(.title2)
            Spacer()
                .frame(height: 4)
            ForEach(exercise.sets.indices, id: \.self) { index in
                Text("Set \(index + 1): \(exercise.sets[index].weight ?? 0)")
                    .font(.system(size: 18))
                    .foregroundStyle(.secondary)
                
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.12), radius: 8)
        .padding(.horizontal, 24)
    }
}
