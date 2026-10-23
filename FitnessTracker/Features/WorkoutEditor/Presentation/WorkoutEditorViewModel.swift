import Observation

@Observable
@MainActor
final class WorkoutEditorViewModel {
    var exercises: [WorkoutExercise] = []
    
}
