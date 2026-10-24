struct WorkoutExercise: Decodable {
    let id: Int
    let name: String
    let sets: [WorkoutSet]
}
