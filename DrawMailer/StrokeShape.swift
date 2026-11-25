// StrokeShape.swift
// DrawMailer - ISTE-454 Bonus - A hand-drawn postcard
// Dario Kovacic | dk9397 | November 2026

import SwiftUI

nonisolated struct StrokeShape: Shape {
    let points: [CGPoint]
    let times: [Double]
    let smooth: Bool
    var upTo: Double = .infinity

    func path(in rect: CGRect) -> Path {
        let visible = zip(points, times).filter { $0.1 <= upTo }.map(\.0)
        var path = Path()
        guard let first = visible.first else { return path }
        func mapped(_ p: CGPoint) -> CGPoint {
            CGPoint(x: rect.minX + p.x * rect.width, y: rect.minY + p.y * rect.height)
        }
        path.move(to: mapped(first))
        if visible.count == 1 {
            path.addLine(to: mapped(first))
        } else if smooth && visible.count > 2 {
            for i in 1..<(visible.count - 1) {
                let a = visible[i], b = visible[i + 1]
                let midpoint = CGPoint(x: (a.x + b.x) / 2, y: (a.y + b.y) / 2)
                path.addQuadCurve(to: mapped(midpoint), control: mapped(a))
            }
            if let last = visible.last { path.addLine(to: mapped(last)) }
        } else {
            for point in visible.dropFirst() { path.addLine(to: mapped(point)) }
        }
        return path
    }
}
