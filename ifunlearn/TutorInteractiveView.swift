import SwiftUI

struct TutorInteractiveView: View {
    let profile: UserProfile

    // Canvas and toolbar states.
    @State private var selectedColor: UIColor = .black
    @State private var selectedThickness: CGFloat = 3.0
    @State private var isEraserActive: Bool = false

    // Track whether the user is drawing.
    @State private var isDrawing = false

    var body: some View {
        // Use ImmediateScrollView and disable scrolling when drawing.
        ImmediateScrollView(scrollDisabled: isDrawing) {
            VStack(spacing: 20) {
                Text("Interactive Drawing")
                    .font(.title)
                    .bold()
                    .padding(.top, 20)

                Text("Profile: \(profile.name), Age: \(profile.age)")

                // Drawing canvas.
                DrawingCanvasView(
                    selectedColor: $selectedColor,
                    selectedThickness: $selectedThickness,
                    isEraserActive: $isEraserActive,
                    isDrawing: $isDrawing
                )
                .frame(width: 300, height: 300)
                .border(Color.black, width: 2)
                .background(Color.white)

                // Toolbar for drawing actions.
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
