struct ExerciseDTO: Decodable {
    let id: Int
    let name: String
    let description: String
    let defaultMetric: String
    let imageURL: String
    let muscleGroupId: Int
}
