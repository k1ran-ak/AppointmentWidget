//
//  View+Ext.swift
//  AppointmentWidget
//
//  Created by Anush Kiran on 21/07/25.
//

import SwiftUI

struct CapsuleBorder: ViewModifier {

    var isSelected: Bool

    func body(content: Content) -> some View {
        content
            .overlay(Capsule().stroke(style: StrokeStyle(lineWidth: 1)))
            .background(isSelected ? Color.black : Color.white, in: Capsule())
            .foregroundStyle(isSelected ? Color.white : Color.black)
    }
}

/// A container view that injects a back-chevron toolbar button and hides the default back text.
/// Wrap any child view inside this to get a consistent "<" back button behavior.
struct BackToolbarContainer<Content: View>: View {
    @Environment(\.dismiss) private var dismiss
    private let content: Content

    /// Initialize with a content builder closure
    /// - Parameter content: The inner view to display
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        // Only the chevron < icon
                        Image(systemName: "chevron.left")
                            .imageScale(.large)
                    }
                }
            }
    }
}

struct ToolbarButtonCustomHandler<Content: View>: View {

    enum ToolbarButtonType {

        case dismiss
        case next

        var imageName: String {
            switch self {
            case .dismiss:
                return "x.circle"
            case .next:
                return "chevron.right"
            }
        }
    }

    private let handler: () -> Void
    private let content: Content
    private let placement: ToolbarItemPlacement
    private let type: ToolbarButtonType
    private let isDisabled: Bool

    /// Initialize with a content builder closure
    /// - Parameter content: The inner view to display
    init(
        @ViewBuilder content: () -> Content,
        handler: @escaping () -> Void,
        placement: ToolbarItemPlacement,
        type: ToolbarButtonType,
        isDisabled: Bool = false
    ) {
        self.content = content()
        self.handler = handler
        self.placement = placement
        self.type = type
        self.isDisabled = isDisabled
    }

    var body: some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: placement) {
                    Button {
                        handler()
                    } label: {
                        Text(type == .next ? "Next" : "")
                        Image(systemName: type.imageName)
                            .imageScale(.large)
                    }
                    .disabled(isDisabled)
                }
            }
    }
}

extension View {

    func capsuleBorder(isSelected: Bool) -> some View {
        self.modifier(CapsuleBorder(isSelected: isSelected))
    }

    /// Wraps the current view in a `BackToolbarContainer`, hiding the default back button
    /// and injecting a chevron-only back button.
    func withChevronBack() -> some View {
        BackToolbarContainer { self }
    }

    func withDismissButton(handler: @escaping () -> Void) -> some View {
        ToolbarButtonCustomHandler(
            content: { self }, handler: handler, placement: .topBarLeading, type: .dismiss)
    }

    func withNextButton(isDisabled: Bool, handler: @escaping () -> Void) -> some View {
        ToolbarButtonCustomHandler(
            content: { self }, handler: handler, placement: .topBarTrailing, type: .next, isDisabled: isDisabled)
    }
}

extension Date {

    func dateToMilliseconds() -> Double {
        return self.timeIntervalSince1970 * 1000
    }
}
