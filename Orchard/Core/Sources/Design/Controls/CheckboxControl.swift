//
//  CheckboxControl.swift
//  Core
//
//  Created by Zack Brown on 12/02/2026.
//

import AppKit
import Base

public class CheckboxControl: NSView {
    
    public typealias ValueDidChange = ((Bool) -> Void)
    
    // MARK: Label
    
    private lazy var textLabel = with(NSTextField()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: NSFont.systemFontSize)
        $0.textColor = .lightGray
        $0.isEditable = false
        $0.isBordered = false
        $0.maximumNumberOfLines = 1
        $0.backgroundColor = .clear
        $0.alignment = .left
    }
    
    // MARK: Control
    
    private lazy var checkbox = with(NSButton(checkboxWithTitle: "",
                                              target: self,
                                              action: #selector(button(_:)))) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: NSFont.systemFontSize)
        $0.setContentHuggingPriority(.defaultHigh,
                                       for: .horizontal)
    }
    
    public var title: String {
        
        get { textLabel.stringValue }
        set {
            
            textLabel.stringValue = newValue
            checkbox.toolTip = newValue
        }
    }
    
    public var value: Bool {
        
        get { checkbox.state == .on }
        set { checkbox.state = newValue ? .on : .off }
    }
    
    public var valueDidChange: ValueDidChange?
    
    required public init(title: String,
                         value: Bool) {
        
        super.init(frame: .zero)
        
        self.title = title
        self.toolTip = toolTip
        
        self.value = value
        
        addSubview(checkbox)
        addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            
            checkbox.leadingAnchor.constraint(equalTo: leadingAnchor,
                                              constant: .padding),
            checkbox.topAnchor.constraint(equalTo: topAnchor,
                                          constant: .margin),
            checkbox.bottomAnchor.constraint(equalTo: bottomAnchor,
                                             constant: -.margin),
            
            textLabel.centerYAnchor.constraint(equalTo: checkbox.centerYAnchor),
            
            textLabel.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor,
                                               constant: .margin),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                constant: -.padding),
        ])
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    @objc
    private func button(_ sender: NSButton) {
        
        valueDidChange?(sender.state == .on)
    }
}
