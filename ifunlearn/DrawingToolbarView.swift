import SwiftUI

struct DrawingToolbarView: View {
    @Binding var selectedColor: UIColor
    @Binding var selectedThickness: CGFloat
    @Binding var isEraserActive: Bool
    var undoAction: () -> Void
    var redoAction: () -> Void
    var clearAction: () -> Void

    let colors: [UIColor] = [.black, .red, .blue, .green, .orange, .purple, .brown, .yellow, .gray, .systemPink]

    var body: some View {
        VStack {
            // Color Picker
            HStack {
                ForEach(colors, id: \.self) { color in
                    Button(action: {
                        selectedColor = color
                        isEraserActive = false
                    }) {
                        Circle()
                            .fill(Color(color))
                            .frame(width: 30, height: 30)
                            .overlay(
                                Circle()
                                    .stroke(selectedColor == color ? Color.black : Color.clear, lineWidth: 2)
                            )
                    }
                }

                // Rainbow Gradient Button
                Button(action: {
                    selectedColor = UIColor(patternImage: createRainbowGradientImage(size: CGSize(width: 30, height: 30)))
                    isEraserActive = false
                }) {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(LinearGradient(gradient: Gradient(colors: [.red, .orange, .yellow, .green, .blue, .purple]), startPoint: .leading, endPoint: .trailing))
                        .frame(width: 30, height: 30)
                }
            }
            .padding(.top, 10)

            // Thickness Picker
            HStack {
                Text("Thickness:")
                ForEach([1, 3, 5, 8, 10], id: \.self) { thickness in
                    Button("\(thickness) px") {
                        selectedThickness = CGFloat(thickness)
                    }
                    .padding(5)
                    .background(selectedThickness == CGFloat(thickness) ? Color.gray.opacity(0.3) : Color.clear)
                    .cornerRadius(5)
                }
            }

            // Action Buttons
            HStack {
                Button(action: undoAction) {
                    Image(systemName: "arrow.uturn.backward.circle")
                        .resizable()
                        .frame(width: 40, height: 40)
                }

                Button(action: redoAction) {
                    Image(systemName: "arrow.uturn.forward.circle")
                        .resizable()
                        .frame(width: 40, height: 40)
                }

                Button(action: {
                    isEraserActive.toggle()
                }) {
                    Image(systemName: "eraser")
                        .resizable()
                        .frame(width: 40, height: 40)
                }

                Button(action: clearAction) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.red)
                }
            }
            .padding()
        }
    }

    // Function to create a rainbow gradient image for UIColor
    private func createRainbowGradientImage(size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            let gradient = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: [UIColor.red.cgColor, UIColor.orange.cgColor, UIColor.yellow.cgColor, UIColor.green.cgColor, UIColor.blue.cgColor, UIColor.purple.cgColor] as CFArray,
                locations: nil
            )
            context.cgContext.drawLinearGradient(
                gradient!,
                start: CGPoint(x: 0, y: 0),
                end: CGPoint(x: size.width, y: 0),
                options: []
            )
        }
    }
}
