struct WorkoutExercise: Codable {
    let id: Int
    let name: String
    let sets: [WorkoutSet]
}
