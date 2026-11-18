import Foundation

struct MenuItem: Codable, Identifiable, Sendable {
    let id: Int
    let title: String
    let descriptionDish: String
    let price: String
    let image: String
    let category: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case descriptionDish = "description"
        case price
        case image
        case category
    }
}
