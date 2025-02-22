import SwiftUI
import UIKit

struct DrawingCanvasView: UIViewRepresentable {
    @Binding var selectedColor: UIColor
    @Binding var selectedThickness: CGFloat
    @Binding var isEraserActive: Bool

    func makeUIView(context: Context) -> CanvasView {
        let canvasView = CanvasView()
        canvasView.backgroundColor = .white
        return canvasView
    }

    func updateUIView(_ uiView: CanvasView, context: Context) {
        uiView.strokeColor = isEraserActive ? .white : selectedColor
        uiView.strokeWidth = selectedThickness
    }
}

class CanvasView: UIView {
    private var lines: [(color: UIColor, width: CGFloat, points: [CGPoint])] = []
    private var undoneLines: [(color: UIColor, width: CGFloat, points: [CGPoint])] = []
    
    var strokeColor: UIColor = .black
    var strokeWidth: CGFloat = 3.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        setupObservers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        removeObservers()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        undoneLines.removeAll() // Clear redo stack when new drawing starts
        let newLine = (color: strokeColor, width: strokeWidth, points: [touch.location(in: self)])
        lines.append(newLine)
        setNeedsDisplay()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, var lastLine = lines.popLast() else { return }
        lastLine.points.append(touch.location(in: self))
        lines.append(lastLine)
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setLineCap(.round)
        
        for line in lines {
            context.setStrokeColor(line.color.cgColor)
            context.setLineWidth(line.width)
            context.beginPath()
            if let firstPoint = line.points.first {
                context.move(to: firstPoint)
                for point in line.points.dropFirst() {
                    context.addLine(to: point)
                }
                context.strokePath()
            }
        }
    }

    // MARK: - Undo/Redo/Clear Actions

    @objc func undo() {
        guard !lines.isEmpty else { return }
        undoneLines.append(lines.removeLast())
        setNeedsDisplay()
    }

    @objc func redo() {
        guard !undoneLines.isEmpty else { return }
        lines.append(undoneLines.removeLast())
        setNeedsDisplay()
    }

    @objc func clearCanvas() {
        lines.removeAll()
        undoneLines.removeAll()
        setNeedsDisplay()
    }

    // MARK: - Notification Center for Actions

    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(undo), name: NSNotification.Name("Undo"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(redo), name: NSNotification.Name("Redo"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(clearCanvas), name: NSNotification.Name("ClearCanvas"), object: nil)
    }

    private func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
}
