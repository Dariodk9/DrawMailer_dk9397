// DrawMailerApp.swift
// DrawMailer - ISTE-454 Bonus - A hand-drawn postcard
// Dario Kovacic | dk9397 | November 2026

import SwiftUI

@main
struct DrawMailerApp: App {
    @State private var book = Sketchbook()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(book)
        }
    }
}
