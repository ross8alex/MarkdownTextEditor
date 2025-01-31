//
//  HTEObservableProtocol.swift
//  HighlightedTextEditor
//
//  Created by Sam Spencer on 1/31/25.
//

import Foundation

@available(iOS 17.0, macOS 14.0, *)
internal protocol HighlightingTextEditorObservable {
    var model: HighlightedTextModel { get set }
    var highlightRules: [HighlightRule] { get }
}


@available(iOS 17.0, macOS 14.0, *)
extension HighlightingTextEditorObservable {
    
    var placeholderFont: SystemColorAlias { SystemColorAlias() }
    
    static func getHighlightedText(text: String, highlightRules: [HighlightRule]) -> NSMutableAttributedString {
        return highlightedText(text: text, highlightRules: highlightRules)
    }
    
}
