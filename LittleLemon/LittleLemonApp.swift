import SwiftUI
import CoreData

@main
struct LittleLemonApp: App {
    @AppStorage(AppKeys.isLoggedIn) private var isLoggedIn = false

    var body: some Scene {
        WindowGroup {
            Group {
                if isLoggedIn {
                    Home()
                } else {
                    Onboarding()
                }
            }
            .preferredColorScheme(.light)
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
}
