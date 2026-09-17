import SwiftUI

struct MuscleGroupCard: View {
    let muscleGroup: MuscleGroup
    
    var body: some View {
        VStack {
            Image(muscleGroup.imageName)
            Text(muscleGroup.name).font(.system(size: 18, weight: .semibold))
        }
        .frame(width: 150, height: 150)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.12), radius: 8)
    }
}

#Preview {
    MuscleGroupCard(
        muscleGroup: MuscleGroup(id: 1, name: "Chest")
    )
}
