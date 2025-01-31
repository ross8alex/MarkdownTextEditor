//
//  HighlightRule.swift
//  HighlightedTextEditor
//
//  Created by Sam Spencer on 1/31/25.
//

import Foundation

/// A highlighting rule that contains a regular expression and a set of formatting
/// rules to apply to matches on those expressions.
///
public struct HighlightRule {
    
    let pattern: NSRegularExpression
    
    let formattingRules: [TextFormattingRule]
    
    // ------------------- Convenience ------------------------
    
    /// Convenience initializer to create a ``HighlightRule`` using a RegEx pattern and
    /// a single ``TextFormattingRule``.
    ///
    public init(pattern: NSRegularExpression, formattingRule: TextFormattingRule) {
        self.init(pattern: pattern, formattingRules: [formattingRule])
    }
    
    // ------------------ Most powerful initializer ------------------
    
    /// Initializer to create a ``HighlightRule`` using a RegEx pattern and an array of
    /// ``TextFormattingRule``s.
    ///
    public init(pattern: NSRegularExpression, formattingRules: [TextFormattingRule]) {
        self.pattern = pattern
        self.formattingRules = formattingRules
    }
    
}
