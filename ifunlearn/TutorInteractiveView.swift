import SwiftUI

struct TutorInteractiveView: View {
    let profile: UserProfile
    @State private var selectedColor: UIColor = .black
    @State private var selectedThickness: CGFloat = 3.0
    @State private var isEraserActive: Bool = false

    var body: some View {
        VStack {
            Text("Interactive Drawing")
                .font(.title)
                .bold()
                .padding(.top, 20)
            
            Text("Profile: \(profile.name), Age: \(profile.age)")

            // Drawing Canvas
            DrawingCanvasView(
                selectedColor: $selectedColor,
                selectedThickness: $selectedThickness,
                isEraserActive: $isEraserActive
            )
            .frame(width: 300, height: 300)
            .border(Color.black, width: 2)
            .background(Color.white)

            // Toolbar
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
        .navigationTitle("Tutor Interactive")
    }

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
