// Palette.swift
// DrawMailer - ISTE-454 Bonus - A hand-drawn postcard
// Dario Kovacic | dk9397 | November 2026

import SwiftUI

nonisolated struct PaletteColor: Identifiable {
    let id: Int
    let name: String
    let red: Double
    let green: Double
    let blue: Double
    let mine: Bool
    var color: Color { Color(red: red, green: green, blue: blue) }
}

nonisolated enum Palette {
    static let colors: [PaletteColor] = [
        .init(id: 0, name: "Knin sunset", red: 0.89, green: 0.55, blue: 0.38, mine: true),
        .init(id: 1, name: "Fortress forest", red: 0.19, green: 0.27, blue: 0.16, mine: true),
        .init(id: 2, name: "Stone", red: 0.52, green: 0.50, blue: 0.48, mine: false),
        .init(id: 3, name: "Sky", red: 0.42, green: 0.65, blue: 0.80, mine: false),
        .init(id: 4, name: "Dark ink", red: 0.13, green: 0.15, blue: 0.21, mine: false),
        .init(id: 5, name: "Red roof", red: 0.70, green: 0.27, blue: 0.20, mine: false),
        .init(id: 6, name: "Sunlight", red: 0.98, green: 0.80, blue: 0.45, mine: false),
        .init(id: 7, name: "Purple", red: 0.45, green: 0.35, blue: 0.56, mine: false),
        .init(id: 8, name: "White ink", red: 1, green: 1, blue: 1, mine: false),
        .init(id: 9, name: "Grass", red: 0.42, green: 0.56, blue: 0.31, mine: false),
        .init(id: 10, name: "Ocean", red: 0.16, green: 0.40, blue: 0.64, mine: false),
        .init(id: 11, name: "Brown", red: 0.43, green: 0.28, blue: 0.20, mine: false),
        .init(id: 12, name: "Cream paper", red: 0.99, green: 0.96, blue: 0.87, mine: false),
        .init(id: 13, name: "Blue paper", red: 0.90, green: 0.95, blue: 0.99, mine: false)
    ]
    static var inks: [PaletteColor] { Array(colors.prefix(12)) }
    static var papers: [PaletteColor] {
        [.init(id: 14, name: "White paper", red: 1, green: 1, blue: 1, mine: false)] + Array(colors.suffix(2))
    }
    static func color(_ id: Int) -> Color { colors.first(where: { $0.id == id })?.color ?? .white }
    static func isMine(_ id: Int) -> Bool { colors.first(where: { $0.id == id })?.mine ?? false }
}
