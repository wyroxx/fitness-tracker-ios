import SwiftUI

struct MuscleGroupsView: View {
    @State private var viewModel: MuscleGroupsViewModel
    let exerciseRepository: ExerciseRepository
    
    let columns = [
        GridItem(.fixed(150), spacing: 16),
        GridItem(.fixed(150))
    ]
    
    init(
        viewModel: MuscleGroupsViewModel,
        exerciseRepository: ExerciseRepository
    ) {
        _viewModel = State(initialValue: viewModel)
        self.exerciseRepository = exerciseRepository
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = viewModel.error {
                VStack(spacing: 12) {
                    Text("Failed to load muscle groups")
                        .font(.headline)
                    Text(error.localizedDescription)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Button("Retry") {
                        Task {
                            await viewModel.reload()
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    Text("Muscle groups")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 28, leading: 44, bottom: 16, trailing: 44))
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.muscleGroups, id: \.id) { muscleGroup in
                            NavigationLink {
                                ExercisesView(
                                    muscleGroup: muscleGroup,
                                    repository: exerciseRepository
                                )
                            } label: {
                                MuscleGroupCard(muscleGroup: muscleGroup)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Exercises")
                    .font(.system(size: 22, weight: .semibold))
            }
        }
        .task {
            await viewModel.load()
        }
    }
}
