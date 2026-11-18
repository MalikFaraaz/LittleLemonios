import SwiftUI
import CoreData

enum DishCategory: String, CaseIterable, Identifiable {
    case starters = "Starters"
    case mains = "Mains"
    case desserts = "Desserts"
    case drinks = "Drinks"

    var id: String { rawValue }
    var storedValue: String { rawValue.lowercased() }
}

struct MenuSection: View {
    @Binding var selectedCategories: Set<String>

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("ORDER FOR DELIVERY!")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(Color.llCharcoal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(DishCategory.allCases) { category in
                        CategoryPill(
                            title: category.rawValue,
                            isSelected: selectedCategories.contains(category.storedValue)
                        ) {
                            toggle(category.storedValue)
                        }
                    }
                }
            }

            Divider()
        }
        .padding()
    }

    private func toggle(_ value: String) {
        if selectedCategories.contains(value) {
            selectedCategories.remove(value)
        } else {
            selectedCategories.insert(value)
        }
    }
}

struct CategoryPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(isSelected ? Color.white : Color.llPrimaryGreen)
                .padding(.horizontal, 16)
                .frame(minHeight: 44)
                .background(isSelected ? Color.llPrimaryGreen : Color.llLightGray)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

struct DishList: View {
    @FetchRequest private var dishes: FetchedResults<Dish>
    private let isLoading: Bool

    init(searchText: String, categories: Set<String>, isLoading: Bool = false) {
        self.isLoading = isLoading

        var predicates: [NSPredicate] = []
        let trimmedSearch = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        if !trimmedSearch.isEmpty {
            predicates.append(NSPredicate(format: "title CONTAINS[cd] %@", trimmedSearch))
        }

        if !categories.isEmpty {
            let categoryPredicates = categories.sorted().map { NSPredicate(format: "category == %@", $0) }
            predicates.append(NSCompoundPredicate(orPredicateWithSubpredicates: categoryPredicates))
        }

        let predicate: NSPredicate? = predicates.isEmpty
            ? nil
            : NSCompoundPredicate(andPredicateWithSubpredicates: predicates)

        _dishes = FetchRequest<Dish>(
            sortDescriptors: [
                NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedStandardCompare))
            ],
            predicate: predicate
        )
    }

    var body: some View {
        LazyVStack(alignment: .leading, spacing: 0) {
            if isLoading && dishes.isEmpty {
                HStack(spacing: 12) {
                    ProgressView()
                    Text("Loading menu...")
                        .font(.llBody)
                        .foregroundStyle(Color.llCharcoal)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 32)
            } else if dishes.isEmpty {
                Text("No dishes match your search.")
                    .font(.llBody)
                    .foregroundStyle(Color.llCharcoal)
                    .padding(.vertical, 24)
            }

            ForEach(dishes, id: \.objectID) { dish in
                NavigationLink {
                    DetailItem(dish: dish)
                } label: {
                    DishRow(dish: dish)
                }
                .buttonStyle(.plain)
                Divider()
            }
        }
        .padding(.horizontal)
    }
}

struct DishRow: View {
    let dish: Dish

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(dish.title ?? "")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color.llCharcoal)
                Text(dish.descriptionDish ?? "")
                    .font(.llBody)
                    .foregroundStyle(Color.llPrimaryGreen)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                Text(dish.formattedPrice)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(Color.llPrimaryGreen)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            DishImage(url: dish.imageURL)
                .frame(width: 90, height: 90)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding(.vertical, 12)
        .contentShape(Rectangle())
    }
}

struct DishImage: View {
    let url: URL?

    var body: some View {
        Color.llLightGray
            .overlay {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        Image(systemName: "photo")
                            .foregroundStyle(Color.llPrimaryGreen)
                    default:
                        ProgressView()
                    }
                }
            }
            .clipped()
            .accessibilityHidden(true)
    }
}
