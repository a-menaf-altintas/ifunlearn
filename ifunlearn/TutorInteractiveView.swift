import SwiftUI

struct TutorInteractiveView: View {
    let profile: UserProfile
    
    // Your existing states
    @State private var selectedColor: UIColor = .black
    @State private var selectedThickness: CGFloat = 3.0
    @State private var isEraserActive: Bool = false

    // Tracks whether user is drawing (optional if you also want to disable scrolling)
    @State private var isDrawing = false

    var body: some View {
        // Replace ScrollView with our custom ImmediateScrollView
        ImmediateScrollView {
            VStack(spacing: 20) {
                Text("Interactive Drawing")
                    .font(.title)
                    .bold()
                    .padding(.top, 20)

                Text("Profile: \(profile.name), Age: \(profile.age)")

                DrawingCanvasView(
                    selectedColor: $selectedColor,
                    selectedThickness: $selectedThickness,
                    isEraserActive: $isEraserActive,
                    isDrawing: $isDrawing
                )
                .frame(width: 300, height: 300)
                .border(Color.black, width: 2)
                .background(Color.white)

                DrawingToolbarView(
                    selectedColor: $selectedColor,
                    selectedThickness: $selectedThickness,
                    isEraserActive: $isEraserActive,
                    undoAction: undo,
                    redoAction: redo,
                    clearAction: clearCanvas
                )
                .padding()
            }
            .frame(maxWidth: .infinity)
        }
        // If you want to disable scrolling while actively drawing,
        // keep this line. Otherwise you can remove it:
        .scrollDisabled(isDrawing)

        .navigationTitle("Tutor Interactive")
    }

    // MARK: - Canvas Actions
    func undo() {
        NotificationCenter.default.post(name: NSNotification.Name("Undo"), object: nil)
    }

    func redo() {
        NotificationCenter.default.post(name: NSNotification.Name("Redo"), object: nil)
    }

    func clearCanvas() {
        NotificationCenter.default.post(name: NSNotification.Name("ClearCanvas"), object: nil)
    }
}
