//
//  InspectorViewController.swift
//  Core
//
//  Created by Zack Brown on 25/07/2025.
//

import AppKit
import Base

public class InspectorViewController: NSViewController {
    
    private lazy var scrollView = with(NSScrollView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.hasVerticalScroller = false
        $0.documentView = stackView
    }
    
    private lazy var stackView = with(NSStackView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.orientation = .vertical
        $0.alignment = .centerX
        $0.spacing = 0
    }
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        
        scrollView.pinEdges(to: view)
        
        NSLayoutConstraint.activate([
            
            stackView.topAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.topAnchor),
            stackView.leftAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leftAnchor),
            stackView.bottomAnchor.constraint(greaterThanOrEqualTo: scrollView.safeAreaLayoutGuide.bottomAnchor),
            stackView.rightAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.rightAnchor)
        ])
    }
    
    internal func addArrangedSubview(_ view: NSView) {
        
        view.setContentHuggingPriority(.defaultLow,
                                       for: .horizontal)
        
        stackView.addArrangedSubview(view)
    }
}
