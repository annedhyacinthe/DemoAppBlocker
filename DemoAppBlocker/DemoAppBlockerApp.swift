//
//  DemoAppBlockerApp.swift
//  DemoAppBlocker
//
//  Created by Anne Hyacinthe on 1/26/26.
//

import SwiftUI
import SwiftData
import FamilyControls

@main
struct DemoAppBlockerApp: App {
    let center = AuthorizationCenter.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    Task {
                        do {
                            try await center.requestAuthorization(for: .individual)
                        } catch {
                            print("Failed to enroll with error: \(error)")
                        }
                    }
                }
                .preferredColorScheme(.light)
        }
        .modelContainer(for: Session.self)
    }
}
