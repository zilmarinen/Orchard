//
//  InspectorStackViewContainer.swift
//  Core
//
//  Created by Zack Brown on 11/02/2026.
//

import AppKit
import Base
import Design

public class InspectorStackViewContainer: NSViewController {
    
    private lazy var scrollView = with(NSScrollView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.drawsBackground = false
        $0.documentView = stackView
    }
    
    private lazy var stackView = with(NSStackView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.orientation = .vertical
        $0.distribution = .gravityAreas
        $0.alignment = .centerX
        $0.spacing = .spacing
        $0.setHuggingPriority(.defaultHigh,
                              for: .horizontal)
        $0.setHuggingPriority(.defaultLow,
                              for: .vertical)
    }
    
    open override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        
        scrollView.pinEdges(to: view)
        stackView.pinEdges(to: scrollView)
    }
}

extension InspectorStackViewContainer {
    
    public func addArrangedSubview(_ view: NSView) {
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.defaultLow,
                                       for: .horizontal)
        view.setContentHuggingPriority(.defaultHigh,
                                       for: .vertical)
        
        stackView.addArrangedSubview(view)
    }
    
    public func removeAllArrangedSubviews() {
        
        stackView.subviews.forEach { $0.removeFromSuperview() }
    }
}
