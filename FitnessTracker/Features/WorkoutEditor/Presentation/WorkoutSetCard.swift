import SwiftUI

struct WorkoutSetCard: View {
    @Binding var set: WorkoutSet
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Set \(set.setNumber)")
                .font(.system(size: 18, weight: .semibold))
                .padding(.bottom, 4)
            HStack(spacing: 3) {
                Text("Weight: ")
                TextField(
                    "",
                    value: $set.weight,
                    format: .number
                )
                .frame(width: 30)
                Text("kg")
            }
            HStack(spacing: 3) {
                Text("Reps: ")
                TextField(
                    "",
                    value: $set.reps,
                    format: .number
                )
                .frame(width: 30)
            }
        }
        .padding(14)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.black.opacity(0.1), lineWidth: 2)
        }
    }
}
