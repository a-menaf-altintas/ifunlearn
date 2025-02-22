import SwiftUI
import SwiftData

struct ProfileCreationView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var name: String = ""
    @State private var ageString: String = ""

    // New: for showing an alert if a duplicate name exists
    @State private var showDuplicateAlert = false

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
            // If user tries to save a duplicate name, show an alert
            .alert("Duplicate Profile Name", isPresented: $showDuplicateAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("A profile named \"\(name)\" already exists. Please choose another name.")
            }
        }
    }

    private func createProfile() {
        guard let ageInt = Int(ageString) else { return }

        // 1) Check if any profile already has this same name
        let fetchDescriptor = FetchDescriptor<UserProfile>(
            predicate: #Predicate { $0.name == name }
        )
        // Attempt to fetch
        if let existingProfiles = try? modelContext.fetch(fetchDescriptor),
           !existingProfiles.isEmpty {
            // We found a duplicate -> show the alert, do not create
            showDuplicateAlert = true
            return
        }

        // 2) If no duplicates, proceed with creation
        let newProfile = UserProfile(name: name, age: ageInt)
        modelContext.insert(newProfile)
        // Optionally force save:
        // try? modelContext.save()
        
        dismiss() // Close the sheet
    }
}
