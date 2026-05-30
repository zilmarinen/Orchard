//
//  StepperControl.swift
//  Core
//
//  Created by Zack Brown on 30/05/2026.
//

import AppKit
import Base

public class StepperControl: NSView {
    
    public typealias ValueDidChange = ((Int) -> Void)
    
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
        $0.isEnabled = false
    }
    
    // MARK: Stepper
    
    private lazy var stepper = with(NSStepper()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.valueWraps = false
        $0.controlSize = .mini
        $0.target = self
        $0.action = #selector(stepper(_:))
    }
    
    public var title: String {
        
        get { textLabel.stringValue }
        set {
            
            textLabel.stringValue = newValue
            textField.placeholderString = newValue
            textField.toolTip = newValue
        }
    }
    
    public var value: Int {
        
        get { stepper.integerValue }
        set {
            
            stepper.integerValue = max(min(newValue, maximumValue), minimumValue)
            textField.integerValue = stepper.integerValue
        }
    }
    
    public var maximumValue: Int {
        
        get { Int(stepper.maxValue) }
        set { stepper.maxValue = Double(newValue) }
    }
    
    public var minimumValue: Int {
        
        get { Int(stepper.minValue) }
        set { stepper.minValue = Double(newValue) }
    }
    
    public var valueDidChange: ValueDidChange?
    
    required public init(title: String,
                         value: Int) {
        
        super.init(frame: .zero)
        
        self.title = title
        self.toolTip = title
        
        self.value = value
        
        addSubview(textLabel)
        addSubview(textField)
        addSubview(stepper)
        
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
            textField.bottomAnchor.constraint(equalTo: bottomAnchor,
                                              constant: -.padding),
            
            stepper.leadingAnchor.constraint(equalTo: textField.trailingAnchor,
                                             constant: .padding),
            stepper.trailingAnchor.constraint(equalTo: trailingAnchor,
                                              constant: -.padding),
            stepper.centerYAnchor.constraint(equalTo: textField.centerYAnchor)
        ])
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension StepperControl {
    
    @objc
    private func stepper(_ sender: NSStepper) {
        
        textField.integerValue = stepper.integerValue
        
        valueDidChange?(stepper.integerValue)
    }
}
