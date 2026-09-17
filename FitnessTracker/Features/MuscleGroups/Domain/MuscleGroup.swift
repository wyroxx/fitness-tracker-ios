struct MuscleGroup: Decodable {
    let id: Int
    let name: String
    var imageName: String {
        switch id {
        case 1: "chest"
        case 2: "abs"
        case 3: "back"
        case 4: "arms"
        case 5: "legs"
        case 6: "shoulders"
        default: "general"
        }
    }
}
