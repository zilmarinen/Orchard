//
//  TextFieldControl.swift
//  Core
//
//  Created by Zack Brown on 12/02/2026.
//

import AppKit
import Base

public class TextFieldControl: NSView {
    
    public typealias ValueDidChange = ((String) -> Void)
    
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
        $0.alignment = .left
        $0.delegate = self
    }
    
    public var title: String {
        
        get { textLabel.stringValue }
        set {
            
            textLabel.stringValue = newValue
            textField.placeholderString = newValue
            textField.toolTip = newValue
        }
    }
    
    public var value: String {
        
        get { textField.stringValue }
        set { textField.stringValue = newValue }
    }
    
    public var valueDidChange: ValueDidChange?
    
    required public init() {
        
        super.init(frame: .zero)
        
        addSubview(textLabel)
        addSubview(textField)
        
        NSLayoutConstraint.activate([
            
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                               constant: .padding),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                constant: -.padding),
            textLabel.topAnchor.constraint(equalTo: topAnchor,
                                           constant: .margin),
            
            textField.topAnchor.constraint(equalTo: textLabel.bottomAnchor,
                                           constant: .margin),
            
            textField.leadingAnchor.constraint(equalTo: leadingAnchor,
                                               constant: .padding),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                constant: -.padding),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor,
                                              constant: -.padding)
        ])
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension TextFieldControl: NSTextFieldDelegate {
    
    public func controlTextDidChange(_ notification: Notification) {
        
        guard let sender = notification.object as? NSTextField,
              sender == textField else { return }
        
        Debouncer.perform(context: String(describing: self),
                          after: .debounceInterval) { [weak self] in
            
            guard let self else { return }
         
            self.valueDidChange?(sender.stringValue)
        }
    }
}
