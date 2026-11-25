// ReplayView.swift
// DrawMailer - ISTE-454 Bonus - A hand-drawn postcard
// Dario Kovacic | dk9397 | November 2026

import SwiftUI

struct ReplayView: View {
    @Environment(Sketchbook.self) private var book
    @Environment(\.dismiss) private var dismiss
    @State private var startDate = Date.now
    @State private var speed = 4

    private var strokes: [Stroke] { book.postcard.strokes }
    private var offsets: [Double] {
        var total = 0.0
        return strokes.map { stroke in
            defer { total += stroke.duration + 0.25 }
            return total
        }
    }
    private var total: Double {
        guard let last = strokes.last, let offset = offsets.last else { return 0 }
        return offset + last.duration
    }
    var body: some View {
        NavigationStack {
            TimelineView(.animation) { context in
                let elapsed = min(total, max(0, context.date.timeIntervalSince(startDate) * Double(speed)))
                VStack(spacing: 22) {
                    StrokesView(strokes: strokes, paperIndex: book.paperIndex,
                                smooth: book.smooth, replayTime: elapsed, offsets: offsets)
                        .border(.gray.opacity(0.25))
                    Text(String(format: "%.1f s of %.1f s", elapsed, total))
                    ProgressView(value: elapsed, total: max(total, 0.001))
                    Picker("Speed", selection: $speed) {
                        Text("1×").tag(1)
                        Text("4×").tag(4)
                        Text("16×").tag(16)
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: speed) { _, _ in startDate = .now }
                    Button("Again") { startDate = .now }
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Replay")
            .toolbar { Button("Done") { dismiss() } }
        }
    }
}
