// ExportView.swift
// DrawMailer - ISTE-454 Bonus - A hand-drawn postcard
// Dario Kovacic | dk9397 | November 2026

import SwiftUI

struct ExportView: View {
    @Environment(Sketchbook.self) private var book
    @Environment(\.dismiss) private var dismiss
    @State private var image: Image?
    private var imageURL: URL { URL.documentsDirectory.appending(path: "postcard.png") }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    if let image {
                        image.resizable().scaledToFit()
                        ShareLink(item: imageURL, preview: SharePreview(book.title, image: image)) {
                            Label("Share postcard image", systemImage: "square.and.arrow.up")
                        }
                    } else {
                        ProgressView("Rendering postcard…")
                    }
                    ShareLink(item: Sketchbook.fileURL) {
                        Label("Share drawing JSON", systemImage: "doc.text")
                    }
                    Text("Requirements").font(.headline)
                    ForEach(book.requirements, id: \.text) { item in
                        Label(item.text, systemImage: item.met ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(item.met ? .green : .secondary)
                    }
                    Text(URL.documentsDirectory.path)
                        .font(.caption2).textSelection(.enabled)
                }
                .padding()
            }
            .navigationTitle("Postcard")
            .toolbar { Button("Done") { dismiss() } }
            .task { render() }
        }
    }
    @MainActor private func render() {
        let renderer = ImageRenderer(content:
            PostcardView(postcard: book.postcard, smooth: book.smooth, activeTime: book.activeTime)
                .frame(width: 600))
        renderer.scale = 3
        if let uiImage = renderer.uiImage, let png = uiImage.pngData() {
            try? png.write(to: imageURL, options: .atomic)
            image = Image(uiImage: uiImage)
        }
    }
}
