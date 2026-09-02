import SwiftUI

/// A row of tappable page numbers (1, 2, 3, ...), with the current page bolded and underlined.
/// Pairs with a paged `TabView` on narrow screens where a three-column layout doesn't fit: each
/// numbered section becomes its own swipeable page instead.
struct PageTabRow: View {
    @Environment(\.notebookPalette) private var palette
    let pageCount: Int
    @Binding var currentPage: Int

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<pageCount, id: \.self) { index in
                let selected = index == currentPage
                Button {
                    withAnimation {
                        currentPage = index
                    }
                } label: {
                    VStack(spacing: 4) {
                        Text("\(index + 1)")
                            .font(selected ? .headline.weight(.bold) : .headline.weight(.regular))
                            .foregroundStyle(selected ? palette.penBlue : palette.inkFaded)
                        Rectangle()
                            .fill(selected ? palette.penBlue : Color.clear)
                            .frame(width: 24, height: 2)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
    }
}
