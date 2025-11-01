//
//  InspectorStackView.swift
//  Base
//
//  Created by Zack Brown on 07/08/2025.
//

import AppKit

open class InspectorStackView: InspectorView {
    
    private lazy var stackView = with(NSStackView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.orientation = .vertical
        $0.alignment = .leading
        $0.distribution = .fill
        $0.spacing = Constant.spacing
    }
    
    public override init(title: String? = nil,
                         accentColor: NSColor) {
        
        super.init(title: title,
                   accentColor: accentColor)
        
        set(content: stackView)
        
        wantsLayer = true
        layer?.backgroundColor = accentColor.cgColor
    }
    
    public func addArrangedSubview(_ view: NSView) {
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.low,
                                       for: .horizontal)
        view.setContentHuggingPriority(.high,
                                       for: .vertical)
        
        stackView.addArrangedSubview(view)
    }
}
