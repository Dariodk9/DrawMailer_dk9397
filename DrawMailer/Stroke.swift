// Stroke.swift
// DrawMailer - ISTE-454 Bonus - A hand-drawn postcard
// Dario Kovacic | dk9397 | November 2026

import SwiftUI

nonisolated struct Stroke: Identifiable, Codable, Equatable {
    var id = UUID()
    var start: Date
    var points: [CGPoint] = []
    var times: [Double] = []
    var colorIndex: Int
    var width: Double

    static let referenceWidth: CGFloat = 360
    static let aspect: CGFloat = 3.0 / 2.0

    var duration: Double { times.last ?? 0 }
    var inkLength: Int {
        guard points.count > 1 else { return 0 }
        return Int(zip(points, points.dropFirst()).reduce(0.0) { sum, pair in
            let dx = Double(pair.1.x - pair.0.x)
            let dy = Double((pair.1.y - pair.0.y) / Self.aspect)
            return sum + hypot(dx, dy) * 1000
        })
    }
}

nonisolated struct Postcard: Codable {
    var title = "Greetings from Knin"
    var author = Student.fullName
    var paperIndex = 12
    var strokes: [Stroke] = []
}
