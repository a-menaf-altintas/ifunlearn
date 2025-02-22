import SwiftUI
import SwiftData

struct ProfileCreationView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var name: String = ""
    @State private var ageString: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Profile Info")) {
                    TextField("Enter name", text: $name)
                    TextField("Enter age", text: $ageString)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("New Profile")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        createProfile()
                    }
                    .disabled(name.isEmpty || ageString.isEmpty)
                }
            }
        }
    }

    private func createProfile() {
        guard let ageInt = Int(ageString) else { return }
        let newProfile = UserProfile(name: name, age: ageInt)
        modelContext.insert(newProfile)

        // SwiftData automatically saves eventually, but you can force it:
        // try? modelContext.save()

        dismiss() // Close this sheet
    }
}
