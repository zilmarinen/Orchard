//
//  InspectorGroupView.swift
//  Core
//
//  Created by Zack Brown on 11/02/2026.
//

import AppKit
import Base

public class InspectorGroupView: NSView {
    
    private lazy var textLabel = with(NSTextField()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .boldSystemFont(ofSize: NSFont.systemFontSize)
        $0.textColor = .white
        $0.isEditable = false
        $0.isBordered = false
        $0.maximumNumberOfLines = 1
        $0.backgroundColor = .clear
        $0.alignment = .left
    }
    
    private lazy var groupView = with(NSView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.wantsLayer = true
        $0.layer?.backgroundColor = NSColor.textBackgroundColor.cgColor
        $0.layer?.cornerRadius = .cornerRadius
        $0.layer?.borderColor = NSColor.unemphasizedSelectedContentBackgroundColor.cgColor
        $0.layer?.borderWidth = .borderWidth
    }
 
    private lazy var stackView = with(NSStackView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.spacing = .spacing
        $0.orientation = .vertical
        $0.alignment = .leading
        $0.distribution = .fill
        $0.setHuggingPriority(.defaultHigh,
                              for: .horizontal)
        $0.setHuggingPriority(.defaultHigh,
                              for: .vertical)
    }
    
    public var title: String {
        
        get { textLabel.stringValue }
        set { textLabel.stringValue = newValue }
    }
    
    public override init(frame frameRect: NSRect) {
        
        super.init(frame: frameRect)
        
        addSubview(textLabel)
        addSubview(groupView)
        groupView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                               constant: .padding),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                constant: -.padding),
            textLabel.topAnchor.constraint(equalTo: topAnchor,
                                           constant: .padding),
            
            groupView.topAnchor.constraint(equalTo: textLabel.bottomAnchor,
                                       constant: .padding),
            
            groupView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                           constant: .padding),
            groupView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                            constant: -.padding),
            groupView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                          constant: -.padding),
            
            stackView.topAnchor.constraint(equalTo: groupView.safeAreaLayoutGuide.topAnchor,
                                           constant: .padding),
            stackView.leftAnchor.constraint(equalTo: groupView.safeAreaLayoutGuide.leftAnchor,
                                            constant: .padding),
            stackView.bottomAnchor.constraint(equalTo: groupView.safeAreaLayoutGuide.bottomAnchor,
                                              constant: -.padding),
            stackView.rightAnchor.constraint(equalTo: groupView.safeAreaLayoutGuide.rightAnchor,
                                             constant: -.padding)
        ])
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension InspectorGroupView {
    
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
