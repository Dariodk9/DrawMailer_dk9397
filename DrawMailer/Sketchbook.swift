// Sketchbook.swift
// DrawMailer - ISTE-454 Bonus - A hand-drawn postcard
// Dario Kovacic | dk9397 | November 2026

import SwiftUI
import Observation

enum Tool: String, CaseIterable { case pen = "Pen", eraser = "Eraser" }

@Observable final class Sketchbook {
    private(set) var postcard = Postcard()
    private(set) var current: Stroke?
    var colorIndex = 0
    var penWidth = 4.0
    var tool: Tool = .pen
    var smooth = true
    private var undoStack: [[Stroke]] = []
    private var redoStack: [[Stroke]] = []
    private var erasing = false

    static var fileURL: URL { URL.documentsDirectory.appending(path: "postcard.json") }
    init() {
        if let data = try? Data(contentsOf: Self.fileURL),
           let restored = try? JSONDecoder().decode(Postcard.self, from: data) {
            postcard = restored
        }
        print("Postcard JSON: \(Self.fileURL.path)")
    }
    var title: String {
        get { postcard.title }
        set { postcard.title = newValue; save() }
    }
    var paperIndex: Int {
        get { postcard.paperIndex }
        set { postcard.paperIndex = newValue; save() }
    }
    private func checkpoint() {
        undoStack.append(postcard.strokes)
        redoStack.removeAll()
    }
    private func save() {
        guard let data = try? JSONEncoder().encode(postcard) else { return }
        try? data.write(to: Self.fileURL, options: .atomic)
    }
    func begin(at point: CGPoint) {
        guard tool == .pen else { return }
        current = Stroke(start: .now, points: [point], times: [0], colorIndex: colorIndex, width: penWidth)
    }
    func extend(to point: CGPoint) {
        guard current != nil else { return }
        current?.points.append(point)
        if let start = current?.start { current?.times.append(Date.now.timeIntervalSince(start)) }
    }
    func end() {
        guard let stroke = current else { erasing = false; return }
        checkpoint()
        postcard.strokes.append(stroke)
        current = nil
        save()
    }
    func erase(near point: CGPoint, radius: CGFloat) {
        let matches = postcard.strokes.filter { stroke in
            stroke.points.contains { p in
                hypot(p.x - point.x, (p.y - point.y) / Stroke.aspect) <= radius + CGFloat(stroke.width) / 720
            }
        }
        guard !matches.isEmpty else { return }
        if !erasing { checkpoint(); erasing = true }
        let ids = Set(matches.map(\.id))
        postcard.strokes.removeAll { ids.contains($0.id) }
        save()
    }
    func clear() {
        guard !postcard.strokes.isEmpty else { return }
        checkpoint()
        postcard.strokes.removeAll()
        save()
    }
    var canUndo: Bool { !undoStack.isEmpty }
    var canRedo: Bool { !redoStack.isEmpty }
    func undo() {
        guard let old = undoStack.popLast() else { return }
        redoStack.append(postcard.strokes)
        postcard.strokes = old
        save()
    }
    func redo() {
        guard let next = redoStack.popLast() else { return }
        undoStack.append(postcard.strokes)
        postcard.strokes = next
        save()
    }
    var strokeCount: Int { postcard.strokes.count }
    var colorsUsed: Int { Set(postcard.strokes.map(\.colorIndex)).count }
    var myColorsUsed: Int { Set(postcard.strokes.filter { Palette.isMine($0.colorIndex) }.map(\.colorIndex)).count }
    var widthsUsed: Int { Set(postcard.strokes.map(\.width)).count }
    var inkLength: Int { postcard.strokes.reduce(0) { $0 + $1.inkLength } }
    var activeTime: Double {
        let strokes = postcard.strokes.sorted { $0.start < $1.start }
        var total = strokes.reduce(0) { $0 + $1.duration }
        for (a, b) in zip(strokes, strokes.dropFirst()) {
            let gap = b.start.timeIntervalSince(a.start.addingTimeInterval(a.duration))
            total += max(0, min(30, gap))
        }
        return total
    }
    var requirements: [(text: String, met: Bool)] {
        [("60 or more strokes", strokeCount >= 60),
         ("At least 4 ink colors", colorsUsed >= 4),
         ("Both Knin photo colors", myColorsUsed >= 2),
         ("At least 2 pen widths", widthsUsed >= 2),
         ("At least 5 minutes", activeTime >= 300)]
    }
    var readyToMail: Bool { requirements.allSatisfy(\.met) }
}
