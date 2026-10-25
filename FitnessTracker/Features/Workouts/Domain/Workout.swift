struct Workout: Codable {
    let title: String
    let startedAt: String
    let exercises: [WorkoutExercise]
}
