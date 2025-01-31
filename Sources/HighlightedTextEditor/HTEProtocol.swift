//
//  HTEProtocol.swift
//  HighlightedTextEditor
//
//  Created by Sam Spencer on 1/31/25.
//

import Foundation

internal protocol HighlightingTextEditor {
    var text: String { get set }
    var highlightRules: [HighlightRule] { get }
}

extension HighlightingTextEditor {
    var placeholderFont: SystemColorAlias { SystemColorAlias() }

    static func getHighlightedText(text: String, highlightRules: [HighlightRule]) -> NSMutableAttributedString {
        return highlightedText(text: text, highlightRules: highlightRules)
    }
}
