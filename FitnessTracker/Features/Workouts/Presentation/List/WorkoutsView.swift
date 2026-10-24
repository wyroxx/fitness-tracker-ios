import SwiftUI

struct WorkoutsView: View {
    @State private var viewModel = WorkoutsViewModel()
    @State private var isWorkoutEditorPresented = false

    let muscleGroupsViewModel: MuscleGroupsViewModel
    let exerciseRepository: ExerciseRepository

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                if viewModel.workouts.isEmpty {
                    Text("No workouts yet")
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 32)
                } else {
                    // TODO: Replace the title with a WorkoutCard.
                    ForEach(viewModel.workouts.indices, id: \.self) { index in
                        Text(viewModel.workouts[index].title)
                    }
                }
            }
            .padding()
            .padding(.bottom, 88)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("My Trainings")
        .navigationBarTitleDisplayMode(.inline)
        .overlay(alignment: .bottomTrailing) {
            Button {
                isWorkoutEditorPresented = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 28, weight: .medium))
                    .foregroundStyle(.white)
                    .frame(width: 60, height: 60)
                    .background(.blue.gradient, in: Circle())
            }
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
}
