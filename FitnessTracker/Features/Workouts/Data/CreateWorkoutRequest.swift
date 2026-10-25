struct CreateWorkoutRequest: Encodable {
    let title: String
    let startedAt: String
    let sessions: [Workout]
}
