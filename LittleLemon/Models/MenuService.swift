import Foundation
import CoreData

enum MenuService {
    static func fetchMenu() async throws -> [MenuItem] {
        let (data, response) = try await URLSession.shared.data(from: AppConfig.menuURL)
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(MenuList.self, from: data).menu
    }

    static func save(_ items: [MenuItem], in context: NSManagedObjectContext) async throws {
        try await context.perform {
            let existing = try context.fetch(Dish.fetchRequest())
            var knownTitles = Set(
                existing.compactMap { $0.title?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
            )

            for item in items {
                let trimmedTitle = item.title.trimmingCharacters(in: .whitespacesAndNewlines)
                let normalizedTitle = trimmedTitle.lowercased()
                guard !normalizedTitle.isEmpty, !knownTitles.contains(normalizedTitle) else {
                    continue
                }

                let dish = Dish(context: context)
                dish.title = trimmedTitle
                dish.descriptionDish = item.descriptionDish
                dish.price = item.price
                dish.image = item.image
                dish.category = item.category.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                knownTitles.insert(normalizedTitle)
            }

            if context.hasChanges {
                try context.save()
            }
        }
    }
}
