import SwiftUI
import SwiftData

struct TutorHomeView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let profile: UserProfile

    @State private var showDeleteAlert = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome, \(profile.name)!")
                .font(.largeTitle)
            Text("Age: \(profile.age)")

            // Go to the interactive tutor
            NavigationLink(destination: TutorInteractiveView(profile: profile)) {
                Text("Launch Interactive Tutor")
            }
            .buttonStyle(.borderedProminent)

            // A button to delete this profile
            Button(role: .destructive) {
                showDeleteAlert = true
            } label: {
                Label("Remove Profile", systemImage: "minus.circle")
            }
        }
        .alert("Remove Profile?", isPresented: $showDeleteAlert) {
            Button("Remove", role: .destructive) {
                removeProfileAndPop()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to remove \(profile.name)?")
        }
        .navigationTitle("Tutor Home")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func removeProfileAndPop() {
        modelContext.delete(profile)
        // Force immediate save if you like:
        // try? modelContext.save()

        // Then pop back to the previous screen:
        dismiss()
    }
}
