//
//  Generic Views.swift
//  SSC23
//
//  Created by Luca Jonscher on 16.04.23.
//
//  MARK: Generic views / view modifiers that are unrelated to the company views
//

import Foundation
import SwiftUI

/// A container view that adds a dismiss button to the trailing navigation bar side.
private struct DismissButtonContainer<Content: View>: View {
    var content: Content
    
    @Environment(\.dismiss) private var dismiss
    
    @ViewBuilder var body: some View {
        content.toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    dismiss()
                }) {
                    Text("Done").bold()
                }
            }
        }
    }
}

extension View {
    /// Applies footnote styling to the text.
    func footnote() -> some View {
        self.font(.footnote)
            .foregroundColor(.secondary)
    }
    
    /// Applies relevant styles to a sheet that should be resizable and have a translucent background.
    ///
    /// Depending on the iOS version, not all modifiers may be available
    @ViewBuilder
    func sheetStyle() -> some View {
        if #available(iOS 16.4, *) {
            self.presentationDetents([.medium, .large])
                .presentationContentInteraction(.resizes)
                .presentationBackgroundInteraction(.enabled)
                .presentationCornerRadius(28)
                .presentationBackground(.regularMaterial)
                .presentationDragIndicator(.visible)
                .interactiveDismissDisabled(false)
        } else if #available(iOS 16.0, *) {
            self.presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
                .interactiveDismissDisabled(false)
        } else {
            self
        }
    }
    
    /// Adds a “Done” button to the trailing side of the navigation bar that dismisses the view.
    func dismissable() -> some View {
        DismissButtonContainer(content: self)
    }
    
    /// Returns `self` only if a boolean condition is met.
    @ViewBuilder
    func conditionally(if bool: Bool) -> some View {
        if bool {
            self
        }
    }
    
    /// Returns `self` if a boolean condition is met, otherwise returns the alternative content.
    @ViewBuilder
    func conditionally<V: View>(if bool: Bool, else content: @escaping () -> V) -> some View {
        if bool {
            self
        } else {
            content()
        }
    }
    
    /// Returns the `View` wrapped in a type-erasing `AnyView`.
    ///
    /// This property may be used when the usage of `self: some View` results in a type error (due to its specific type ambiguity).
    var typeErased: AnyView {
        AnyView(self)
    }
}

/// A view that places a text string secondary to a label.
struct BadgedView: View {
    var label: String
    var badge: String?
    
    /// Places a text string secondary next to a label,
    /// - Parameters:
    ///   - label: The primary text string.
    ///   - badge: An optional secondary text string.
    /// If the badge is short enough, it is placed horizontally to the label. Otherwise, it is placed beneath it.
    init(_ label: String, _ badge: String?) {
        self.label = label
        self.badge = badge
    }
    
    @ViewBuilder var body: some View {
        if let badge {
            if self.badge?.count ?? 0 <= 8 {
                HStack(alignment: .center) {
                    Text(label)
                    Spacer()
                    Text(badge)
                        .foregroundStyle(.secondary)
                }
            } else {
                VStack(alignment: .leading) {
                    Text(label)
                    Text(badge)
                        .foregroundStyle(.secondary)
                }
            }
        } else {
            Text(label)
        }
    }
}

/// A view that presents information as a popover (or if unavailable as a sheet).
struct PopoverView: View {
    var title: String
    var text: String
        
    /// The content of the popover that may be displayed as a popover or sheet.
    var content: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                Text(text)
                    .fixedSize(horizontal: false, vertical: true)
                
            }
            .padding()
            .multilineTextAlignment(.leading)
        }
    }
    
    @ViewBuilder var body: some View {
        Group {
            if #available(iOS 16.4, *) {
                // Workaround, because if no fixed size is set, the popover clips the view at a specific height (plus other size issues)
                content
                    .frame(width: 280, height: 140, alignment: .leading)
                    .presentationCompactAdaptation(.popover)
            } else {
                content
            }
        }
    }
}
