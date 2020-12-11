//
//  NumberStepper.swift
//  Orchard
//
//  Created by Zack Brown on 08/11/2020.
//

import Cocoa

class NumberStepper: NSView {
    
    var valueDidChange: ((NumberStepper, Int) -> Void)?
    
    let textField = NSTextField()
    let stepper = NSStepper()
    
    var integerValue: Int {
        
        get {
            
            stepper.integerValue
        }
        set {
            
            textField.integerValue = newValue
            stepper.integerValue = newValue
        }
    }
    
    var isEnabled: Bool {
        
        get {
            
            stepper.isEnabled
        }
        set {
            
            textField.isEnabled = newValue
            stepper.isEnabled = newValue
        }
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        textField.controlSize = .small
        textField.integerValue = 0
        
        stepper.controlSize = .small
        stepper.target = self
        stepper.action = #selector(stepper(sender:))
        stepper.minValue = 0
        stepper.maxValue = 35
        stepper.valueWraps = false
        
        let stackView = NSStackView(views: [textField, stepper])
        
        stackView.alignment = .centerY
        stackView.distribution = .equalSpacing
        stackView.orientation = .horizontal
        stackView.spacing = 2.0
        addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: stackView, attribute: .top, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: stackView, attribute: .leading, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: stackView, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: stackView, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        
        addSubview(stackView)
    }
}

extension NumberStepper {
    
    @objc func stepper(sender: NSStepper) {
        
        textField.integerValue = stepper.integerValue
        
        valueDidChange?(self, stepper.integerValue)
    }
}
