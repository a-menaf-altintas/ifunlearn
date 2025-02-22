import SwiftUI
import SwiftData

struct ProfileSelectionView: View {
    // To perform delete/save operations with SwiftData
    @Environment(\.modelContext) private var modelContext
    
    // This Query automatically fetches all UserProfile objects
    @Query private var profiles: [UserProfile]
    
    // Controls whether ProfileCreationView is presented
    @State private var showCreateProfile = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                Text("Available Profiles")
                    .font(.title2)
                    .padding(.top, 30)
                
                if profiles.isEmpty {
                    Text("No profiles found. Please add one.")
                        .foregroundColor(.secondary)
                } else {
                    // Show existing profiles in a List
                    List {
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
                            // Swipe to delete
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    deleteProfile(profile)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    // Make the list a bit smaller so it stays more centered
                    .frame(height: 250)
                }

                // "Add Profile" button at the bottom (still centered)
                Button {
                    showCreateProfile = true
                } label: {
                    Label("Add Profile", systemImage: "plus")
                        .font(.headline)
                }
                .buttonStyle(.borderedProminent)
                .padding(.bottom, 30)

                // Spacer if you want extra space at the bottom
                Spacer(minLength: 0)
            }
            .navigationTitle("Profiles")
        }
        .sheet(isPresented: $showCreateProfile) {
            ProfileCreationView()
        }
    }

    // MARK: - Delete Profile
    private func deleteProfile(_ profile: UserProfile) {
        modelContext.delete(profile)
        // Optionally force a save immediately:
        // try? modelContext.save()
    }
}
