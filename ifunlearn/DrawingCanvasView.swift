import SwiftUI
import UIKit

/// UIViewRepresentable for a custom CanvasView.
struct DrawingCanvasView: UIViewRepresentable {
    @Binding var selectedColor: UIColor
    @Binding var selectedThickness: CGFloat
    @Binding var isEraserActive: Bool

    // Tracks if user is actively drawing
    @Binding var isDrawing: Bool

    func makeUIView(context: Context) -> CanvasView {
        let canvasView = CanvasView()
        canvasView.backgroundColor = .white
        canvasView.delegate = context.coordinator
        return canvasView
    }

    func updateUIView(_ uiView: CanvasView, context: Context) {
        uiView.strokeColor = isEraserActive ? .white : selectedColor
        uiView.strokeWidth = selectedThickness
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(isDrawing: $isDrawing)
    }

    class Coordinator: NSObject, CanvasViewDelegate {
        @Binding var isDrawing: Bool
        init(isDrawing: Binding<Bool>) {
            self._isDrawing = isDrawing
        }
        func drawingBegan() { isDrawing = true }
        func drawingEnded() { isDrawing = false }
    }
}

protocol CanvasViewDelegate: AnyObject {
    func drawingBegan()
    func drawingEnded()
}

/// Custom UIView for freehand drawing.
class CanvasView: UIView {
    weak var delegate: CanvasViewDelegate?

    private var lines: [(color: UIColor, width: CGFloat, points: [CGPoint])] = []
    private var undoneLines: [(color: UIColor, width: CGFloat, points: [CGPoint])] = []

    var strokeColor: UIColor = .black
    var strokeWidth: CGFloat = 3.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        setupObservers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        removeObservers()
    }

    // MARK: - Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        delegate?.drawingBegan()
        undoneLines.removeAll()
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

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.drawingEnded()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.drawingEnded()
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

    // MARK: - Undo/Redo/Clear
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

    // MARK: - Notification Observers
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(undo), name: NSNotification.Name("Undo"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(redo), name: NSNotification.Name("Redo"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(clearCanvas), name: NSNotification.Name("ClearCanvas"), object: nil)
    }

    private func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
}
