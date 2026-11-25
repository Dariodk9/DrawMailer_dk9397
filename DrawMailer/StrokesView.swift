// StrokesView.swift
// DrawMailer - ISTE-454 Bonus - A hand-drawn postcard
// Dario Kovacic | dk9397 | November 2026

import SwiftUI

struct StrokesView: View {
    let strokes: [Stroke]
    let paperIndex: Int
    let smooth: Bool
    var replayTime: Double? = nil
    var offsets: [Double] = []

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Palette.color(paperIndex)
                ForEach(Array(strokes.enumerated()), id: \.element.id) { index, stroke in
                    let available = replayTime.map { $0 - (index < offsets.count ? offsets[index] : 0) } ?? .infinity
                    if available >= 0 {
                        StrokeShape(points: stroke.points, times: stroke.times, smooth: smooth, upTo: available)
                            .stroke(Palette.color(stroke.colorIndex),
                                    style: StrokeStyle(lineWidth: CGFloat(stroke.width) * geometry.size.width / Stroke.referenceWidth,
                                                       lineCap: .round, lineJoin: .round))
                    }
                }
            }
        }
        .aspectRatio(Stroke.aspect, contentMode: .fit)
        .clipped()
    }
}
