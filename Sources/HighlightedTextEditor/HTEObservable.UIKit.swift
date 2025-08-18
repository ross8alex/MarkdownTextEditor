#if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst)
//
//  HTEObservable.UIKit.swift
//  HighlightedTextEditor
//
//  Created by Sam Spencer on 1/31/25.
//

import Observation
import SwiftUI
import UIKit

@available(iOS 17.0, *)
public struct HighlightedTextEditorObservable: UIViewRepresentable, HighlightingTextEditorObservable {
    
    @Binding public var model: HighlightedTextModel
    var onTextViewCreated: ((UITextView) -> Void)? = nil
    
    public struct Internals {
        public let textView: SystemTextView
        public let scrollView: SystemScrollView?
    }

    let highlightRules: [HighlightRule]

    private(set) var onEditingChanged: OnEditingChangedCallback?
    private(set) var onCommit: OnCommitCallback?
    private(set) var onTextChange: OnTextChangeCallback?
    private(set) var onSelectionChange: OnSelectionChangeCallback?
    private(set) var introspect: IntrospectObservableCallback?

    public init(
        model: Binding<HighlightedTextModel>,
        highlightRules: [HighlightRule], 
        onTextViewCreated: ((UITextView) -> Void)? = nil
    ) {
        self._model = model
        self.highlightRules = highlightRules
        self.onTextViewCreated = onTextViewCreated
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        updateTextViewModifiers(textView)
        runIntrospect(textView)
        context.coordinator.textView = textView
        DispatchQueue.main.async {
            self.onTextViewCreated?(textView)
        }
        
        return textView
    }

    public func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.isScrollEnabled = false
        context.coordinator.updatingUIView = true
        defer {
            uiView.isScrollEnabled = true
            context.coordinator.updatingUIView = false
        }

        // If the system is handling partial text, skip the full overwrite (or consider
        // doing a partial highlight, but this seems to cause duplication...).
        if let markedRange = uiView.markedTextRange, !markedRange.isEmpty {
            // Partial highlight which causes duplication
            // let partiallyHighlighted = HighlightedTextEditor
            //      .getHighlightedText(text: model.text, highlightRules: highlightRules)
            // let markedNSRange = uiView.nsRange(from: markedRange)
            //
            // uiView.setAttributedMarkedText(partiallyHighlighted, selectedRange: markedNSRange)
            
            // Don’t set selection or do a full reassign. Just return.
            return
        }

        // No marked text. Build the fully highlighted text.
        let highlightedText = HighlightedTextEditor.getHighlightedText(
            text: model.text,
            highlightRules: highlightRules
        )

        // Check if it’s the same as the last assigned.
        if let lastAssigned = context.coordinator.lastAssignedText,
           lastAssigned.isEqual(to: highlightedText)
        {
            // Exactly the same => skip
            return
        }
        
        uiView.attributedText = highlightedText
        context.coordinator.lastAssignedText = highlightedText

        // Update selection safely
        let textCount = highlightedText.length
        let requestedRange = context.coordinator.selectedTextRange
        let safeLocation = min(requestedRange.location, textCount)
        let safeLength   = min(requestedRange.length, textCount - safeLocation)
        uiView.selectedRange = NSRange(location: safeLocation, length: safeLength) 
        
        // Modifiers and introspection
        updateTextViewModifiers(uiView)
        runIntrospect(uiView)
    }

    private func runIntrospect(_ textView: UITextView) {
        guard let introspect = introspect else { return }
        let internals = Internals(textView: textView, scrollView: nil)
        introspect(internals)
    }

    private func updateTextViewModifiers(_ textView: UITextView) {
        // BUGFIX #19: https://stackoverflow.com/questions/60537039/change-prompt-color-for-uitextfield-on-mac-catalyst
        let textInputTraits = textView.value(forKey: "textInputTraits") as? NSObject
        textInputTraits?.setValue(textView.tintColor, forKey: "insertionPointColor")
    }

    public final class Coordinator: NSObject, UITextViewDelegate {
        
        var parent: HighlightedTextEditorObservable
        var selectedTextRange: NSRange = .init(location: 0, length: 0)
        var updatingUIView = false
        var lastAssignedText: NSAttributedString? = nil
        var textView: UITextView?

        init(_ markdownEditorView: HighlightedTextEditorObservable) {
            self.parent = markdownEditorView
        }

        public func textViewDidChange(_ textView: UITextView) {
            // For Multistage Text Input
            guard textView.markedTextRange == nil else { return }

            parent.model.text = textView.text
            parent.model.characters = textView.text.count
            selectedTextRange = textView.selectedRange
        }

        public func textViewDidChangeSelection(_ textView: UITextView) {
            guard let onSelectionChange = parent.onSelectionChange,
                  !updatingUIView
            else { return }
            selectedTextRange = textView.selectedRange
            onSelectionChange([textView.selectedRange])
        }

        public func textViewDidBeginEditing(_ textView: UITextView) {
            parent.onEditingChanged?()
        }

        public func textViewDidEndEditing(_ textView: UITextView) {
            parent.onCommit?()
        }
    }
    
}

@available(iOS 17.0, *)
public extension HighlightedTextEditorObservable {
    
    func introspect(callback: @escaping IntrospectObservableCallback) -> Self {
        var new = self
        new.introspect = callback
        return new
    }

    func onSelectionChange(_ callback: @escaping (_ selectedRange: NSRange) -> Void) -> Self {
        var new = self
        new.onSelectionChange = { ranges in
            guard let range = ranges.first else { return }
            callback(range)
        }
        return new
    }

    func onCommit(_ callback: @escaping OnCommitCallback) -> Self {
        var new = self
        new.onCommit = callback
        return new
    }

    func onEditingChanged(_ callback: @escaping OnEditingChangedCallback) -> Self {
        var new = self
        new.onEditingChanged = callback
        return new
    }

    func onTextChange(_ callback: @escaping OnTextChangeCallback) -> Self {
        var new = self
        new.onTextChange = callback
        return new
    }
    
}
#endif
