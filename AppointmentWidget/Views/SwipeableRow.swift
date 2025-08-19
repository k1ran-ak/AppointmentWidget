//
//  SwipeableRow.swift
//  AppointmentWidget
//
//  Created by Anush Kiran on 23/07/25.
//

import SwiftUI

struct SwipeActionConfig {
  let tint: Color
  let systemImage: String
  let perform: () -> Void
}

struct SwipeableRow<Content: View>: View {
  private let maxReveal: CGFloat = 120
  private let trigger: CGFloat = 80

  let leading: SwipeActionConfig?
  let trailing: SwipeActionConfig?
  @ViewBuilder var content: () -> Content

  @GestureState private var dragX: CGFloat = 0
  @State private var settledX: CGFloat = 0

  private var offset: CGFloat { settledX + dragX }
  private var progress: CGFloat { min(abs(offset) / maxReveal, 1) }

  var body: some View {
    ZStack {
      // Animated background
      HStack {
        if offset > 0, let leading {
          actionBackground(config: leading, alignment: .leading)
        } else {
          Color.clear.frame(width: 0)
        }
        Spacer()
        if offset < 0, let trailing {
          actionBackground(config: trailing, alignment: .trailing)
        } else {
          Color.clear.frame(width: 0)
        }
      }
      .animation(.interactiveSpring(), value: progress)

      // Foreground content slides over it
      content()
        .background(Color(.systemBackground))
        .offset(x: offset)
        .gesture(drag)
        .animation(.interactiveSpring(), value: offset)
        .onChange(of: dragX) { _, _ in
          // keep foreground over background while dragging
        }
    }
    .clipped()
  }

  private var drag: some Gesture {
    DragGesture(minimumDistance: 5, coordinateSpace: .local)
      .updating($dragX) { value, state, _ in
        // Only allow one direction if only one action is configured
        let tx = value.translation.width
        if leading == nil, tx > 0 { state = 0; return }
        if trailing == nil, tx < 0 { state = 0; return }
        state = clamp(tx, -maxReveal, maxReveal)
      }
      .onEnded { value in
        let final = settledX + value.translation.width
        if final > trigger, let leading {
          leading.perform(); snapBack()
        } else if final < -trigger, let trailing {
          trailing.perform(); snapBack()
        } else {
          snapBack()
        }
      }
  }

  private func snapBack() {
    withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
      settledX = 0
    }
  }

  @ViewBuilder
  private func actionBackground(config: SwipeActionConfig, alignment: Alignment) -> some View {
    ZStack(alignment: alignment) {
        config.tint.opacity(0.15 + 0.85 * progress)
      Image(systemName: config.systemImage)
        .font(.system(size: 20 + 10 * progress, weight: .semibold))
        .foregroundStyle(config.tint)
        .padding(.horizontal, 20)
        .opacity(0.6 + 0.4 * progress)
    }
  }

  private func clamp(_ x: CGFloat, _ a: CGFloat, _ b: CGFloat) -> CGFloat {
    min(max(x, a), b)
  }
}

#Preview {
    @Previewable @State var selectedIds = Set<Int>()
    List(1...3, id: \.self) { id in
        SwipeableRow(
            leading: .init(tint: .green, systemImage: "checkmark.circle.fill") {
                selectedIds.insert(id)
            },
            trailing: .init(tint: .red, systemImage: "trash") {
                selectedIds.remove(id)
            }
        ) {
            HStack {
                Text("Sample \(id)")
                    .foregroundColor(selectedIds.contains(id) ? .blue : .primary)
                Spacer()
                if selectedIds.contains(id) {
                    Image(systemName: "checkmark").foregroundColor(.accentColor)
                }
            }
            .padding(.vertical, 10)
            .contentShape(Rectangle())
        }
    }
}
