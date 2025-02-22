import SwiftUI
import SwiftData

@main
struct ifunlearnApp: App {
    // Set up SwiftData ModelContainer with our UserProfile schema
    var modelContainer: ModelContainer = {
        let schema = Schema([UserProfile.self])
        do {
            return try ModelContainer(for: schema)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            // Our main starting screen is ProfileSelectionView
            ProfileSelectionView()
                .modelContainer(modelContainer)
        }
    }
}
