//
//  TextFormattingRule.swift
//  HighlightedTextEditor
//
//  Created by Sam Spencer on 1/31/25.
//

import Foundation
import SwiftUI

public struct TextFormattingRule {
    public typealias AttributedKeyCallback = (String, Range<String.Index>) -> Any

    let key: NSAttributedString.Key?
    let calculateValue: AttributedKeyCallback?
    let fontTraits: SymbolicTraits

    // ------------------- convenience ------------------------

    public init(key: NSAttributedString.Key, value: Any, fontTraits: SymbolicTraits = []) {
        self.init(key: key, calculateValue: { _, _ in value }, fontTraits: fontTraits)
    }

    public init(key: NSAttributedString.Key, calculateValue: @escaping AttributedKeyCallback) {
        self.init(key: key, calculateValue: calculateValue, fontTraits: [])
    }

    public init(fontTraits: SymbolicTraits) {
        self.init(key: nil, fontTraits: fontTraits)
    }

    // ------------------ most powerful initializer ------------------

    init(
        key: NSAttributedString.Key? = nil,
        calculateValue: AttributedKeyCallback? = nil,
        fontTraits: SymbolicTraits = []
    ) {
        self.key = key
        self.calculateValue = calculateValue
        self.fontTraits = fontTraits
    }
}

#if os(iOS)
public extension TextFormattingRule {
    @available(iOS 14.0, *)
    init(foregroundColor color: Color, fontTraits: SymbolicTraits = []) {
        self.init(key: .foregroundColor, value: UIColor(color), fontTraits: fontTraits)
    }

    @available(iOS 14.0, *)
    init(highlightColor color: Color, fontTraits: SymbolicTraits = []) {
        self.init(key: .backgroundColor, value: UIColor(color), fontTraits: fontTraits)
    }
}
#endif

#if os(macOS)
public extension TextFormattingRule {
    @available(macOS 11.0, *)
    init(foregroundColor color: Color, fontTraits: SymbolicTraits = []) {
        self.init(key: .foregroundColor, value: NSColor(color), fontTraits: fontTraits)
    }

    @available(macOS 11.0, *)
    init(highlightColor color: Color, fontTraits: SymbolicTraits = []) {
        self.init(key: .backgroundColor, value: NSColor(color), fontTraits: fontTraits)
    }
}
#endif
