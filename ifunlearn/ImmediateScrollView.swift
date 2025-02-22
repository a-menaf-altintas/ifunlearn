import SwiftUI
import UIKit

/// A SwiftUI container that hosts its content in a UIScrollView with
/// delaysContentTouches = false. The content’s width is forced to match
/// the scroll view’s width to disable horizontal scrolling. Scrolling is
/// enabled or disabled based on the `scrollDisabled` flag.
struct ImmediateScrollView<Content: View>: UIViewRepresentable {
    let content: Content
    var scrollDisabled: Bool = false

    // Initialize with a ViewBuilder and an optional scrollDisabled flag.
    init(scrollDisabled: Bool = false, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.scrollDisabled = scrollDisabled
    }

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delaysContentTouches = false   // Immediate touch delivery.
        scrollView.canCancelContentTouches = true
        scrollView.backgroundColor = .clear

        // Disable horizontal bouncing.
        scrollView.alwaysBounceHorizontal = false
        scrollView.alwaysBounceVertical = true

        // Allow subviews to receive touches even if scrolling begins.
        scrollView.panGestureRecognizer.cancelsTouchesInView = false

        // Create a hosting controller for the SwiftUI content.
        let hostingController = UIHostingController(rootView: content)
        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

        // Add the hosting controller’s view to the scroll view.
        scrollView.addSubview(hostingController.view)

        // Pin the hosting controller’s view to all edges of the scroll view's content.
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            // Force the content's width to match the scroll view’s width (prevents horizontal scrolling).
            hostingController.view.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])

        return scrollView
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {
        // Enable or disable scrolling based on the flag.
        uiView.isScrollEnabled = !scrollDisabled
    }
}
