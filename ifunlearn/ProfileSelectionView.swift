import SwiftUI
import SwiftData

struct ProfileSelectionView: View {
    // This Query automatically fetches all UserProfile objects
    @Query private var profiles: [UserProfile]
    // Controls whether ProfileCreationView is presented
    @State private var showCreateProfile = false

    var body: some View {
        NavigationStack {
            List {
                // If no profiles exist, show a placeholder
                if profiles.isEmpty {
                    Text("No profiles found. Please add one.")
                } else {
                    // Show each profile; tapping goes to TutorHomeView
                    ForEach(profiles) { profile in
                        NavigationLink(destination: TutorHomeView(profile: profile)) {
                            VStack(alignment: .leading) {
                                Text(profile.name)
                                    .font(.headline)
                                Text("Age: \(profile.age)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Profiles")
            // Top-right button for new profile
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showCreateProfile = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            // Present creation screen in a sheet
            .sheet(isPresented: $showCreateProfile) {
                ProfileCreationView()
            }
        }
    }
}
