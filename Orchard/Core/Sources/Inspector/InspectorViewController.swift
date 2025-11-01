//
//  InspectorViewController.swift
//
//  Created by Zack Brown on 25/07/2025.
//

import AppKit
import Base

open class InspectorViewController: NSViewController {
    
    private lazy var scrollView = with(NSScrollView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.hasVerticalScroller = false
        $0.documentView = stackView
    }
    
    private lazy var stackView = with(NSStackView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.orientation = .vertical
        $0.distribution = .gravityAreas
        $0.alignment = .centerX
        $0.spacing = 0
    }
    
    open override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        
        scrollView.pinEdges(to: view)
        stackView.pinEdges(to: scrollView)
    }
}

extension InspectorViewController {
    
    public func addArrangedSubview(_ view: NSView) {
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.defaultLow,
                                       for: .horizontal)
        view.setContentHuggingPriority(.defaultLow,
                                       for: .vertical)
        
        stackView.addArrangedSubview(view)
    }
    
    public func removeAllArrangedSubviews() {
        
        stackView.subviews.forEach { $0.removeFromSuperview() }
    }
}
