// ContentView.swift
// DrawMailer - ISTE-454 Bonus - A hand-drawn postcard
// Dario Kovacic | dk9397 | November 2026

import SwiftUI

struct ContentView: View {
    @Environment(Sketchbook.self) private var book
    @State private var showClear = false
    @State private var showReplay = false
    @State private var showExport = false

    var body: some View {
        @Bindable var model = book
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    TextField("Postcard title", text: $model.title)
                        .font(.title2.bold())
                        .textFieldStyle(.roundedBorder)
                    PostcardCanvas()
                        .border(.gray.opacity(0.35))
                    HStack(spacing: 5) {
                        Image(systemName: book.readyToMail ? "checkmark.seal.fill" : "envelope")
                            .foregroundStyle(book.readyToMail ? .green : .secondary)
                        Text("\(book.strokeCount) strokes · \(book.colorsUsed) colours · \(book.widthsUsed) sizes · ink \(book.inkLength) · \(Int(book.activeTime)) s")
                            .font(.caption2).minimumScaleFactor(0.7).lineLimit(1)
                    }
                    ScrollView(.horizontal) {
                        HStack(spacing: 12) {
                            ForEach(Palette.inks) { ink in
                                Button {
                                    book.colorIndex = ink.id
                                    book.tool = .pen
                                } label: {
                                    ZStack(alignment: .topTrailing) {
                                        Circle().fill(ink.color).frame(width: 37, height: 37)
                                            .overlay(Circle().stroke(.primary, lineWidth: book.colorIndex == ink.id ? 3 : 0))
                                        if ink.mine {
                                            Image(systemName: "star.fill").font(.system(size: 10))
                                                .foregroundStyle(.yellow).offset(x: 3, y: -3)
                                        }
                                    }
                                }
                                .buttonStyle(.plain)
                                .accessibilityLabel(ink.name)
                            }
                        }.padding(5)
                    }
                    Picker("Tool", selection: $model.tool) {
                        ForEach(Tool.allCases, id: \.self) { tool in Text(tool.rawValue).tag(tool) }
                    }.pickerStyle(.segmented)
                    HStack {
                        Text("Pen size")
                        Slider(value: $model.penWidth, in: 1...15, step: 1)
                        Text("\(Int(book.penWidth))").monospacedDigit()
                    }
                    HStack {
                        Button { book.undo() } label: { Image(systemName: "arrow.uturn.backward") }
                            .disabled(!book.canUndo)
                        Spacer()
                        Button { book.redo() } label: { Image(systemName: "arrow.uturn.forward") }
                            .disabled(!book.canRedo)
                        Spacer()
                        Toggle(isOn: $model.smooth) { Image(systemName: "scribble.variable") }
                            .toggleStyle(.button)
                        Spacer()
                        Menu {
                            Picker("Paper", selection: $model.paperIndex) {
                                ForEach(Palette.papers) { paper in Text(paper.name).tag(paper.id) }
                            }
                        } label: { Image(systemName: "square.fill") }
                        Spacer()
                        Button(role: .destructive) { showClear = true } label: {
                            Image(systemName: "trash")
                        }
                    }
                    .buttonStyle(.bordered)
                    .font(.title3)
                }
                .padding()
            }
            .navigationTitle("DrawMailer")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button { showReplay = true } label: { Image(systemName: "play.circle") }
                    Button { showExport = true } label: { Image(systemName: "envelope") }
                }
            }
            .confirmationDialog("Clear the postcard?", isPresented: $showClear,
                                titleVisibility: .visible) {
                Button("Clear", role: .destructive) { book.clear() }
                Button("Cancel", role: .cancel) {}
            } message: { Text("You can still undo it.") }
            .sheet(isPresented: $showReplay) { ReplayView() }
            .sheet(isPresented: $showExport) { ExportView() }
        }
    }
}

// QUESTIONS
// Q1: Erasing three strokes in one drag removes all three together.
// Undo restores all three because checkpoint() runs only once when erasing begins.
//
// Q2: Normalized coordinates scale to any canvas size. If points were stored in
// screen pixels, the exported 600-point-wide image would move or distort the drawing.
//
// Q3: Smoothing uses quadratic curves to soften sharp corners in handwriting.
// The recorded points are control points so the curve follows the original gesture.
//
// Q4: Without the 30-second cap, a pause between drawing sessions could count
// as hours or days of drawing even though no pen was moving.
