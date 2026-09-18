import SwiftUI

struct ExercisesView: View {
    let muscleGroup: MuscleGroup
    @State private var viewModel: ExercisesViewModel
    
    init(muscleGroup: MuscleGroup, repository: ExerciseRepository) {
        self.muscleGroup = muscleGroup
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
                            NavigationLink {
                                
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
        .task {
            await viewModel.load(muscleGroupId: muscleGroup.id)
        }
    }
}
