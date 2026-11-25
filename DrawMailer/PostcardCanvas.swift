// PostcardCanvas.swift
// DrawMailer - ISTE-454 Bonus - A hand-drawn postcard
// Dario Kovacic | dk9397 | November 2026

import SwiftUI

struct PostcardCanvas: View {
    @Environment(Sketchbook.self) private var book

    var body: some View {
        GeometryReader { geo in
            StrokesView(strokes: book.postcard.strokes + (book.current.map { [$0] } ?? []),
                        paperIndex: book.paperIndex, smooth: book.smooth)
            .contentShape(Rectangle())
            .gesture(DragGesture(minimumDistance: 0)
                .onChanged { value in
                    let p = CGPoint(x: value.location.x / geo.size.width,
                                    y: value.location.y / geo.size.height)
                    guard (0...1).contains(p.x), (0...1).contains(p.y) else { return }
                    if book.tool == .eraser {
                        book.erase(near: p, radius: 12 / 360)
                    } else if book.current == nil {
                        book.begin(at: p)
                    } else {
                        book.extend(to: p)
                    }
                }
                .onEnded { _ in book.end() })
        }
        .aspectRatio(Stroke.aspect, contentMode: .fit)
    }
}
