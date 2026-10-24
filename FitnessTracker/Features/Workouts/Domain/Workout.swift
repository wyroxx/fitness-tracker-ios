struct Workout: Decodable {
    let title: String
    let startedAt: String
    let exercises: [WorkoutExercise]
}
