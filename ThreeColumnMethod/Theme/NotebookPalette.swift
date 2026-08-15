import SwiftUI

/// A paper/ink color set. Two instances exist (light and dark) so the notebook look
/// can follow the system theme. Values match the Android app's palette exactly.
struct NotebookPalette {
    let paper: Color
    let paperAlt: Color
    let marginLine: Color
    let ink: Color
    let inkFaded: Color
    let penBlue: Color
    let onPenBlue: Color
    let highlighter: Color
    let onHighlighter: Color
    let errorPen: Color
    let onErrorPen: Color
}

extension NotebookPalette {
    static let light = NotebookPalette(
        paper: Color(hex: 0xFDF9EF),
        paperAlt: Color(hex: 0xF5EDD9),
        marginLine: Color(hex: 0xD3897E),
        ink: Color(hex: 0x221A12),
        inkFaded: Color(hex: 0x4A4034),
        penBlue: Color(hex: 0x2C4A78),
        onPenBlue: Color(hex: 0xFBF3E3),
        highlighter: Color(hex: 0xF3D48A),
        onHighlighter: Color(hex: 0x4A3B12),
        errorPen: Color(hex: 0xB23A32),
        onErrorPen: Color(hex: 0xFBF3E3)
    )

    static let dark = NotebookPalette(
        paper: Color(hex: 0x231F1A),
        paperAlt: Color(hex: 0x2E2820),
        marginLine: Color(hex: 0xA85C52),
        ink: Color(hex: 0xEDE3D0),
        inkFaded: Color(hex: 0xB0A48D),
        penBlue: Color(hex: 0x8FB4E3),
        onPenBlue: Color(hex: 0x162335),
        highlighter: Color(hex: 0x5B4A20),
        onHighlighter: Color(hex: 0xF3D48A),
        errorPen: Color(hex: 0xE0897F),
        onErrorPen: Color(hex: 0x3A1512)
    )

    static func forScheme(_ colorScheme: ColorScheme) -> NotebookPalette {
        colorScheme == .dark ? .dark : .light
    }
}

private struct NotebookPaletteKey: EnvironmentKey {
    static let defaultValue = NotebookPalette.light
}

extension EnvironmentValues {
    var notebookPalette: NotebookPalette {
        get { self[NotebookPaletteKey.self] }
        set { self[NotebookPaletteKey.self] = newValue }
    }
}

extension View {
    /// Injects the palette matching `colorScheme` into the environment, and applies it
    /// as the view hierarchy's font (serif, matching Android's `NotebookFont`).
    func notebookThemed(for colorScheme: ColorScheme) -> some View {
        environment(\.notebookPalette, NotebookPalette.forScheme(colorScheme))
    }
}

/// A single vertical margin rule, like the red line on ruled notebook paper.
/// Horizontal ruling was tried and dropped on Android: with variable-height wrapped
/// text, fixed-interval lines can't stay aligned to real text baselines.
struct NotebookMargin: ViewModifier {
    @Environment(\.notebookPalette) private var palette
    var inset: CGFloat = 40

    func body(content: Content) -> some View {
        content.overlay(alignment: .topLeading) {
            palette.marginLine
                .frame(width: 1.5)
                .padding(.leading, inset)
        }
    }
}

extension View {
    func notebookMargin(inset: CGFloat = 40) -> some View {
        modifier(NotebookMargin(inset: inset))
    }
}
