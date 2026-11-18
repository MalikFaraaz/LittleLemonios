import SwiftUI
import CoreData

struct Home: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var searchText = ""
    @State private var selectedCategories: Set<String> = []
    @State private var isLoadingMenu = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    Header()
                    Hero(searchText: $searchText)
                    MenuSection(selectedCategories: $selectedCategories)
                    DishList(
                        searchText: searchText,
                        categories: selectedCategories,
                        isLoading: isLoadingMenu
                    )
                }
            }
            .background(Color.white)
            .toolbar(.hidden, for: .navigationBar)
            .task {
                await loadMenuIfNeeded()
            }
            .alert("Menu Error", isPresented: $showAlert) {
                Button("Retry") {
                    Task {
                        await loadMenuIfNeeded()
                    }
                }
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
        }
    }

    @MainActor
    private func loadMenuIfNeeded() async {
        guard !isLoadingMenu else { return }

        let existingCount = (try? viewContext.count(for: Dish.fetchRequest())) ?? 0
        guard existingCount == 0 else { return }

        isLoadingMenu = true
        defer { isLoadingMenu = false }

        do {
            let items = try await MenuService.fetchMenu()
            try await MenuService.save(items, in: viewContext)
        } catch {
            alertMessage = "Could not load the menu. Check your connection and try again."
            showAlert = true
        }
    }
}
