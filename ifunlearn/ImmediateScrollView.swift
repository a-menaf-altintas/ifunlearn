//
//  Untitled.swift
//  ifunlearn
//
//  Created by Abdulmenaf Altintas on 2025-02-22.
//

import SwiftUI
import UIKit

/// A SwiftUI container that hosts its content in a UIScrollView
/// with delaysContentTouches = false. This eliminates the "two-tap"
/// delay you see in a normal ScrollView.
struct ImmediateScrollView<Content: View>: UIViewRepresentable {
    let content: Content

    // We use a @ViewBuilder init so you can pass in any SwiftUI content.
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    func makeUIView(context: Context) -> UIScrollView {
        // 1) Create the UIScrollView
        let scrollView = UIScrollView()
        scrollView.delaysContentTouches = false   // Key line!
        scrollView.canCancelContentTouches = true // Usually helpful
        scrollView.backgroundColor = .clear

        // 2) Create a UIHostingController for the SwiftUI content
        let hostingController = UIHostingController(rootView: content)
        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

        // 3) Add the hosting controller’s view to the scroll view
        scrollView.addSubview(hostingController.view)

        // 4) Pin the edges so the content sizes correctly
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

            // Match the scroll view’s width if you want vertical scrolling.
            // Remove if you want horizontal scrolling.
            hostingController.view.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])

        return scrollView
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {
        // Nothing needed here; SwiftUI updates the content automatically.
    }
}
