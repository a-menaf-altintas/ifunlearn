import SwiftUI
import SwiftData

struct TutorHomeView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let profile: UserProfile

    @State private var showDeleteAlert = false

    var body: some View {
        VStack {
            // Top portion: welcome text
            Text("Welcome, \(profile.name)!")
                .font(.largeTitle)
                .padding(.top, 40)
            Text("Age: \(profile.age)")

            // Spacer to push the "Launch Interactive Tutor" button into the middle
            Spacer()

            // "Launch Interactive Tutor" in the vertical center
            NavigationLink(destination: TutorInteractiveView(profile: profile)) {
                Text("Launch Interactive Tutor")
            }
            .buttonStyle(.borderedProminent)

            // Another spacer so "Remove Profile" stays near the bottom
            Spacer()

            // "Remove Profile" at bottom
            Button(role: .destructive) {
                showDeleteAlert = true
            } label: {
                Label("Remove Profile", systemImage: "minus.circle")
            }
            .padding(.bottom, 40)
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
        // Optionally force immediate save:
        // try? modelContext.save()

        // Then pop back to the previous screen
        dismiss()
    }
}
