import SwiftUI
import SwiftData

struct ProfileSelectionView: View {
    // SwiftData context
    @Environment(\.modelContext) private var modelContext
    
    // Automatically fetches all UserProfile objects
    @Query private var profiles: [UserProfile]
    
    // For showing ProfileCreationView
    @State private var showCreateProfile = false
    
    // For delete confirmation alert
    @State private var showDeleteAlert = false
    @State private var profileToDelete: UserProfile?

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
                    // Show existing profiles in a list
                    List {
                        ForEach(profiles) { profile in
                            // One row = Link on the left, minus button on the right
                            HStack {
                                // 1) NavigationLink only covers the text area on the left
                                NavigationLink(destination: TutorHomeView(profile: profile)) {
                                    VStack(alignment: .leading) {
                                        Text(profile.name)
                                            .font(.headline)
                                        Text("Age: \(profile.age)")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .buttonStyle(.plain)    // keep the link from overshadowing

                                Spacer()

                                // 2) The minus button for removal
                                Button {
                                    profileToDelete = profile
                                    showDeleteAlert = true
                                } label: {
                                    Image(systemName: "minus.circle")
                                        .foregroundColor(.red)
                                        .imageScale(.large)
                                }
                                // 3) Make it a borderless/plain style,
                                // so it does not make the entire row tappable
                                .buttonStyle(.borderless)
                            }
                        }
                    }
                    .frame(height: 250)
                    // Alert triggered when the user taps the minus button
                    .alert(
                        "Remove Profile?",
                        isPresented: $showDeleteAlert,
                        presenting: profileToDelete
                    ) { toRemove in
                        Button("Remove", role: .destructive) {
                            deleteProfile(toRemove)
                        }
                        Button("Cancel", role: .cancel) {}
                    } message: { toRemove in
                        Text("Are you sure you want to remove \(toRemove.name)?")
                    }
                }

                // "Add Profile" button
                Button {
                    showCreateProfile = true
                } label: {
                    Label("Add Profile", systemImage: "plus")
                        .font(.headline)
                }
                .buttonStyle(.borderedProminent)
                .padding(.bottom, 30)

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
