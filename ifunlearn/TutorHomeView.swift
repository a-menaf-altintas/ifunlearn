//
//  TutorHomeView.swift
//  ifunlearn
//
//  Created by Abdulmenaf Altintas on 2025-02-21.
//

import SwiftUI
import SwiftData

struct TutorHomeView: View {
    let profile: UserProfile

    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome, \(profile.name)!")
                .font(.largeTitle)
            Text("Age: \(profile.age)")

            // Direct NavigationLink to the destination — no isActive or navigationDestination.
            NavigationLink(destination: TutorInteractiveView(profile: profile)) {
                Text("Launch Interactive Tutor")
            }
            .buttonStyle(.borderedProminent)
        }
        .navigationTitle("Tutor Home")
        .navigationBarTitleDisplayMode(.inline)
    }
}
