//
//  CoordinateView.swift
//  Orchard
//
//  Created by Zack Brown on 07/11/2020.
//

import Cocoa
import Meadow

class CoordinateView: NSView {
    
    var valueDidChange: ((CoordinateView, Coordinate) -> Void)?

    let xStepper: NumberStepper
    let yStepper: NumberStepper
    let zStepper: NumberStepper
    
    var coordinate: Coordinate {
        
        get { Coordinate(x: xStepper.integerValue, y: yStepper.integerValue, z: zStepper.integerValue) }
        set {
            
            xStepper.integerValue = newValue.x
            yStepper.integerValue = newValue.y
            zStepper.integerValue = newValue.z
        }
    }
    
    var isEnabled: Bool {
        
        get {
            
            zStepper.isEnabled
        }
        set {
            
            xStepper.isEnabled = newValue
            yStepper.isEnabled = newValue
            zStepper.isEnabled = newValue
        }
    }
    
    required init?(coder: NSCoder) {
        
        xStepper = NumberStepper(coder: coder)!
        yStepper = NumberStepper(coder: coder)!
        zStepper = NumberStepper(coder: coder)!
        
        super.init(coder: coder)
        
        let stackView = NSStackView(views: [xStepper, yStepper, zStepper])
        
        stackView.alignment = .centerY
        stackView.distribution = .fillEqually
        stackView.orientation = .horizontal
        stackView.spacing = 2.0
        addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: stackView, attribute: .top, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: stackView, attribute: .leading, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: stackView, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: stackView, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        
        addSubview(stackView)
        
        xStepper.valueDidChange = { [weak self] (_, value) in
            
            guard let self = self else { return }
            
            self.valueDidChange?(self, self.coordinate)
        }
        yStepper.valueDidChange = { [weak self] (_, value) in
            
            guard let self = self else { return }
            
            self.valueDidChange?(self, self.coordinate)
        }
        zStepper.valueDidChange = { [weak self] (_, value) in
            
            guard let self = self else { return }
            
            self.valueDidChange?(self, self.coordinate)
        }
    }
}
