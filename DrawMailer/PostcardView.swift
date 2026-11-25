// PostcardView.swift
// DrawMailer - ISTE-454 Bonus - A hand-drawn postcard
// Dario Kovacic | dk9397 | November 2026

import SwiftUI

nonisolated struct StampEdge: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path(rect)
        let radius: CGFloat = 5
        for x in stride(from: rect.minX, through: rect.maxX, by: 12) {
            p.addEllipse(in: CGRect(x: x-radius, y: rect.minY-radius, width: radius*2, height: radius*2))
            p.addEllipse(in: CGRect(x: x-radius, y: rect.maxY-radius, width: radius*2, height: radius*2))
        }
        for y in stride(from: rect.minY, through: rect.maxY, by: 12) {
            p.addEllipse(in: CGRect(x: rect.minX-radius, y: y-radius, width: radius*2, height: radius*2))
            p.addEllipse(in: CGRect(x: rect.maxX-radius, y: y-radius, width: radius*2, height: radius*2))
        }
        return p
    }
}

struct Stamp: View {
    var body: some View {
        ZStack {
            StampEdge().fill(.red, style: FillStyle(eoFill: true))
            VStack(spacing: 2) {
                Image(systemName: "mountain.2.fill")
                Text("HR 26").font(.system(size: 10, weight: .bold))
            }.foregroundStyle(.white)
        }
        .frame(width: 75, height: 85)
        .clipShape(Rectangle())
    }
}

nonisolated struct Postmark: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let cx = rect.width * 0.28, cy = rect.height * 0.48
        p.addEllipse(in: CGRect(x: cx-25, y: cy-25, width: 50, height: 50))
        p.addEllipse(in: CGRect(x: cx-19, y: cy-19, width: 38, height: 38))
        for row in 0..<3 {
            let y = cy - 14 + CGFloat(row)*13
            p.move(to: CGPoint(x: cx+23, y: y))
            for i in 0..<4 {
                let x = cx + 23 + CGFloat(i)*19
                p.addQuadCurve(to: CGPoint(x: x+19, y: y),
                               control: CGPoint(x: x+9.5, y: y+(i.isMultiple(of: 2) ? -7 : 7)))
            }
        }
        return p
    }
}

struct PostcardView: View {
    let postcard: Postcard
    let smooth: Bool
    let activeTime: Double
    var body: some View {
        VStack(spacing: 0) {
            StrokesView(strokes: postcard.strokes, paperIndex: postcard.paperIndex, smooth: smooth)
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(postcard.title).font(.title2.bold())
                    Text("drawn by \(postcard.author) · \(postcard.strokes.count) strokes · \(Int(activeTime)) s")
                        .font(.caption)
                }
                Spacer()
                ZStack {
                    Stamp()
                    Postmark().stroke(.black.opacity(0.7), lineWidth: 1.5)
                        .frame(width: 115, height: 85).offset(x: -37)
                }.frame(width: 120, height: 95)
            }
            .padding(16)
            .background(.white)
            .foregroundStyle(.black)
        }
        .background(.white)
    }
}
