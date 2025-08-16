//
//  HighlightedTextModel.swift
//  HighlightedTextEditor
//
//  Created by Sam Spencer on 1/30/25.
//

import Observation

/// An Observable model which stores the HighlightedTextEditor's text content, in
/// addition to other properties such as the number of characters in the field.
///
/// For improved performance, you should consider using this model and
/// ``HighlightedTextEditor``'s `Observable` variant over the older `Binding`-based
/// component. Performance is improved when using `Observable` over `Binding` in iOS
/// 17.0 and later because each key stroke will not trigger SwiftUI to redraw the
/// entire view hierarchy, and instead only redraw the text editor itself.
///
@available(iOS 17.0, macOS 14.0, *)
@Observable
public final class HighlightedTextModel {

    /// The text stored in this modal and displayed in the ``HighligtedTextEditor``.
    public var text: String
    
    /// The number of characters in ``text``.
    ///
    /// - note: This value is updated on initialization and by the
    /// ``HighlightedTextEditor`` component internally.
    ///
    public internal(set) var characters: Int
    
    /// Initializes a new ``HighlightedTextModel`` with an initial string.
    ///
    /// There is no need to maintain a reference to the string provided to this
    /// initializer. This is purely provided for convenience when initializing the text
    /// field and will populate the ``HighlightedTextEditor`` with the value you pass
    /// in, if any.
    ///
    public init(text: String = "") {
        self.text = text
        self.characters = text.count
    }
    
    /// Convenience function to set both the text value and update the number of
    /// characters on this model.
    ///
    public func setInitialText(_ text: String) {
        self.text = text
        self.characters = text.count
    }
    
}
