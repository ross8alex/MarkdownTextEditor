//
//  HighlightingTextEditor.swift
//  HighlightedTextEditor
//
//  Created by Kyle Nazario on 8/31/20.
//

import SwiftUI

#if os(macOS)
import AppKit

public typealias SystemFontAlias = NSFont
public typealias SystemColorAlias = NSColor
public typealias SymbolicTraits = NSFontDescriptor.SymbolicTraits
public typealias SystemTextView = NSTextView
public typealias SystemScrollView = NSScrollView

let defaultEditorFont = NSFont.systemFont(ofSize: NSFont.systemFontSize)
let defaultEditorTextColor = NSColor.labelColor

#else
import UIKit

public typealias SystemFontAlias = UIFont
public typealias SystemColorAlias = UIColor
public typealias SymbolicTraits = UIFontDescriptor.SymbolicTraits
public typealias SystemTextView = UITextView
public typealias SystemScrollView = UIScrollView

let defaultEditorFont = UIFont.preferredFont(forTextStyle: .body)
let defaultEditorTextColor = UIColor.label

#endif

public typealias OnSelectionChangeCallback = ([NSRange]) -> Void
public typealias IntrospectCallback = (_ editor: HighlightedTextEditor.Internals) -> Void

@available(iOS 17.0, macOS 14.0, *)
public typealias IntrospectObservableCallback = (_ editor: HighlightedTextEditorObservable.Internals) -> Void

public typealias EmptyCallback = () -> Void
public typealias OnCommitCallback = EmptyCallback
public typealias OnEditingChangedCallback = EmptyCallback
public typealias OnTextChangeCallback = (_ editorContent: String) -> Void
