import 'package:flutter/material.dart';

/// A single stroke: holds the list of points, plus the stroke's color and width.
class Stroke {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;

  Stroke({
    required this.points,
    required this.color,
    required this.strokeWidth,
  });
}

class TutorInteractiveScreen extends StatefulWidget {
  final Map<String, dynamic> profile;

  const TutorInteractiveScreen({Key? key, required this.profile})
      : super(key: key);

  @override
  _TutorInteractiveScreenState createState() => _TutorInteractiveScreenState();
}

class _TutorInteractiveScreenState extends State<TutorInteractiveScreen> {
  String tutorMessage =
      "Hello, let's start your session! Draw something or say something to begin.";

  String userVoiceInput = "";

  /// Holds all completed strokes.
  List<Stroke> strokes = [];

  /// The stroke currently being drawn (if any).
  Stroke? currentStroke;

  /// The current stroke width and color for new strokes.
  double currentStrokeWidth = 3.0;
  Color currentColor = Colors.black;

  /// For bounding the drawing area
  final GlobalKey _canvasKey = GlobalKey();

  // Example palette of colors for the user to pick from.
  final List<Color> colorPalette = [
    Colors.black,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.brown,
    Colors.pink,
  ];

  // Called when the user starts drawing.
  void _startStroke(Offset globalPosition) {
    if (_canvasKey.currentContext == null) return;
    final RenderBox box = _canvasKey.currentContext!.findRenderObject() as RenderBox;
    final Offset localPosition = box.globalToLocal(globalPosition);

    // Create a new stroke with the current color/width.
    currentStroke = Stroke(
      points: [localPosition],
      color: currentColor,
      strokeWidth: currentStrokeWidth,
    );
    setState(() {
      // Add the new stroke to the list of strokes.
      strokes.add(currentStroke!);
    });
  }

  // Called when the user drags (continues drawing).
  void _continueStroke(Offset globalPosition) {
    if (_canvasKey.currentContext == null || currentStroke == null) return;
    final RenderBox box = _canvasKey.currentContext!.findRenderObject() as RenderBox;
    final Offset localPosition = box.globalToLocal(globalPosition);

    // Optional bounding check
    final Size size = box.size;
    if (localPosition.dx < 0 ||
        localPosition.dx > size.width ||
        localPosition.dy < 0 ||
        localPosition.dy > size.height) {
      return;
    }

    setState(() {
      currentStroke!.points.add(localPosition);
    });
  }

  // Called when the user ends the stroke.
  void _endStroke() {
    setState(() {
      currentStroke = null;
    });
    _processUserInteraction();
  }

  // Simulate voice input
  void _simulateVoiceInput(String input) {
    setState(() {
      userVoiceInput = input;
    });
    _processUserInteraction();
  }

  // Update tutor message after each interaction
  void _processUserInteraction() {
    setState(() {
      tutorMessage = "Great job! Based on your input, let's move to the next activity.";
      userVoiceInput = "";
    });
  }

  // Undo removes the last stroke
  void _undoStroke() {
    setState(() {
      if (strokes.isNotEmpty) {
        strokes.removeLast();
      }
    });
  }

  // Clear all strokes
  void _clearCanvas() {
    setState(() {
      strokes.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tutor Session for ${widget.profile['name']}'),
      ),
      body: Column(
        children: [
          // Tutor message area
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: Colors.blue.shade100,
            child: Text(
              tutorMessage,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(height: 10),

          // A toolbar row for undo, clear, stroke width, and color picking
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Undo button
              IconButton(
                icon: const Icon(Icons.undo),
                onPressed: _undoStroke,
                tooltip: 'Undo last stroke',
              ),
              // Clear button
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: _clearCanvas,
                tooltip: 'Clear all strokes',
              ),

              // Stroke width dropdown
              const SizedBox(width: 8),
              DropdownButton<double>(
                value: currentStrokeWidth,
                items: [1, 2, 3, 5, 8, 10].map((w) {
                  return DropdownMenuItem<double>(
                    value: w.toDouble(),
                    child: Text('${w}px'),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      currentStrokeWidth = value;
                    });
                  }
                },
              ),

              // Simple color palette
              const SizedBox(width: 16),
              SizedBox(
                height: 30,
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: colorPalette.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final color = colorPalette[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          currentColor = color;
                        });
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: color == currentColor
                                ? Colors.black
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // The Interactive Drawing Area
          Expanded(
            child: Center(
              child: Container(
                key: _canvasKey,
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  color: Colors.white,
                ),
                child: GestureDetector(
                  onPanStart: (details) => _startStroke(details.globalPosition),
                  onPanUpdate: (details) => _continueStroke(details.globalPosition),
                  onPanEnd: (_) => _endStroke(),
                  child: CustomPaint(
                    painter: DrawingPainter(strokes: strokes),
                    child: Container(),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Voice Input
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onSubmitted: _simulateVoiceInput,
              decoration: const InputDecoration(
                labelText: 'Talk to your tutor (simulate speech input)',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Paints all strokes, each with its own color and stroke width.
/// Uses a quadratic Bézier approach for smoothing each stroke.
class DrawingPainter extends CustomPainter {
  final List<Stroke> strokes;

  DrawingPainter({required this.strokes});

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      _drawSingleStroke(canvas, stroke);
    }
  }

  void _drawSingleStroke(Canvas canvas, Stroke stroke) {
    if (stroke.points.isEmpty) return;

    final paint = Paint()
      ..color = stroke.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke.strokeWidth
      ..strokeCap = StrokeCap.round;

    // If there's only one point, draw a dot
    if (stroke.points.length == 1) {
      canvas.drawCircle(stroke.points.first, paint.strokeWidth / 2, paint);
      return;
    }

    // Otherwise, smooth the line with quadratic Bézier segments
    final path = Path();
    path.moveTo(stroke.points[0].dx, stroke.points[0].dy);

    for (int i = 1; i < stroke.points.length - 1; i++) {
      final midPoint = Offset(
        (stroke.points[i].dx + stroke.points[i + 1].dx) / 2,
        (stroke.points[i].dy + stroke.points[i + 1].dy) / 2,
      );
      path.quadraticBezierTo(
        stroke.points[i].dx,
        stroke.points[i].dy,
        midPoint.dx,
        midPoint.dy,
      );
    }

    // Line to the final point
    path.lineTo(stroke.points.last.dx, stroke.points.last.dy);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) {
    // Repaint if the strokes list changes in any way.
    return oldDelegate.strokes != strokes;
  }
}
