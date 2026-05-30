//
//  LabelControl.swift
//  Core
//
//  Created by Zack Brown on 12/02/2026.
//

import AppKit
import Base

public class LabelControl: NSView {
    
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
    
    private lazy var textField = with(NSTextField()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: NSFont.systemFontSize)
        $0.textColor = .lightGray
        $0.isEditable = false
        $0.isBordered = false
        $0.maximumNumberOfLines = 1
        $0.backgroundColor = .clear
        $0.alignment = .left
    }
    
    public var title: String {
        
        get { textLabel.stringValue }
        set { textLabel.stringValue = newValue }
    }
    
    public var value: String {
        
        get { textField.stringValue }
        set { textField.stringValue = newValue }
    }
    
    required public init(title: String,
                         value: String? = "") {
        
        super.init(frame: .zero)
        
        self.title = title
        self.toolTip = title
        
        self.value = value ?? ""
        
        addSubview(textField)
        addSubview(textLabel)
        
        wantsLayer = true
        layer?.backgroundColor = NSColor.systemFill.cgColor
        layer?.cornerRadius = .cornerRadius
        layer?.borderColor = NSColor.unemphasizedSelectedContentBackgroundColor.cgColor
        layer?.borderWidth = .borderWidth
        
        NSLayoutConstraint.activate([
            
            textField.leadingAnchor.constraint(equalTo: leadingAnchor,
                                               constant: .padding),
            textField.topAnchor.constraint(equalTo: topAnchor,
                                           constant: .margin),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor,
                                              constant: -.margin),
            
            textLabel.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            
            textLabel.leadingAnchor.constraint(equalTo: textField.trailingAnchor,
                                               constant: .margin),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                constant: -.padding),
        ])
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
