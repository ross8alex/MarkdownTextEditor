//
//  GetHighlightedText.swift
//  HighlightedTextEditor
//
//  Created by Sam Spencer on 1/31/25.
//

import Foundation

internal func highlightedText(text: String, highlightRules: [HighlightRule]) -> NSMutableAttributedString {
    let highlightedString = NSMutableAttributedString(string: text)
    let all = NSRange(location: 0, length: text.utf16.count)
    
    let editorFont = defaultEditorFont
    let editorTextColor = defaultEditorTextColor
    
    highlightedString.addAttribute(.font, value: editorFont, range: all)
    highlightedString.addAttribute(.foregroundColor, value: editorTextColor, range: all)
    
    highlightRules.forEach { rule in
        let matches = rule.pattern.matches(in: text, options: [], range: all)
        matches.forEach { match in
            rule.formattingRules.forEach { formattingRule in
                
                var font = SystemFontAlias()
                highlightedString.enumerateAttributes(in: match.range, options: []) { attributes, _, _ in
                    let fontAttribute = attributes.first { $0.key == .font }!
                    // swiftlint:disable:next force_cast
                    let previousFont = fontAttribute.value as! SystemFontAlias
                    font = previousFont.with(formattingRule.fontTraits)
                }
                highlightedString.addAttribute(.font, value: font, range: match.range)
                
                let matchRange = Range<String.Index>(match.range, in: text)!
                let matchContent = String(text[matchRange])
                guard let key = formattingRule.key,
                      let calculateValue = formattingRule.calculateValue else { return }
                highlightedString.addAttribute(
                    key,
                    value: calculateValue(matchContent, matchRange),
                    range: match.range
                )
            }
        }
    }
    
    return highlightedString
}
