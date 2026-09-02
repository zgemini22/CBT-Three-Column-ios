import SwiftUI

/// A row of tappable page titles (e.g. "1. Automatic Thought"), with the current page bolded and
/// underlined. Pairs with a paged `TabView` on narrow screens where a three-column layout doesn't
/// fit: each numbered section becomes its own swipeable page, and this tab row is where its title
/// now lives instead of repeating atop the page's own content.
struct PageTabRow: View {
    @Environment(\.notebookPalette) private var palette
    let titles: [String]
    @Binding var currentPage: Int

    var body: some View {
        HStack(spacing: 0) {
            ForEach(titles.indices, id: \.self) { index in
                let selected = index == currentPage
                Button {
                    withAnimation {
                        currentPage = index
                    }
                } label: {
                    VStack(spacing: 4) {
                        Text(titles[index])
                            .font(selected ? .subheadline.weight(.bold) : .subheadline.weight(.regular))
                            .foregroundStyle(selected ? palette.penBlue : palette.inkFaded)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
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
