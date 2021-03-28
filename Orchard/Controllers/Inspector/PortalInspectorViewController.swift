//
//  PortalInspectorViewController.swift
//
//  Created by Zack Brown on 16/03/2021.
//

import Cocoa
import Meadow

class PortalInspectorViewController: NSViewController {
    
    @IBOutlet weak var gridBox: NSBox!
    @IBOutlet weak var nodeBox: NSBox!
    @IBOutlet weak var buildBox: NSBox!
    
    @IBOutlet weak var nodeCountLabel: NSTextField!
    
    @IBOutlet weak var gridRenderingButton: NSButton!
    @IBOutlet weak var nodeRenderingButton: NSButton!
    
    @IBOutlet weak var inspectorTypePopUp: NSPopUpButton! {
        
        didSet {
            
            inspectorTypePopUp.removeAllItems()
            
            for option in FoliageType.allCases {
                
                inspectorTypePopUp.addItem(withTitle: option.description)
            }
        }
    }
    
    @IBOutlet weak var buildTypePopUp: NSPopUpButton! {
        
        didSet {
            
            buildTypePopUp.removeAllItems()
            
            for option in PortalType.allCases {
                
                buildTypePopUp.addItem(withTitle: option.description)
            }
        }
    }
    
    @IBOutlet weak var nodeCoordinateView: CoordinateView! {
        
        didSet {
            
            nodeCoordinateView.isEnabled = false
        }
    }
    
    @IBOutlet weak var inspectorIdentifierLabel: NSTextField! {
        
        didSet {
            
            inspectorIdentifierLabel.delegate = self
        }
    }
    
    @IBOutlet weak var buildIdentifierLabel: NSTextField! {
        
        didSet {
            
            buildIdentifierLabel.delegate = self
        }
    }
    
    @IBAction func button(_ sender: NSButton) {
        
        coordinator?.button(button: sender)
    }
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        coordinator?.popUp(popUp: sender)
    }
    
    weak var coordinator: PortalCoordinator?
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        
        coordinator?.refresh()
    }
}

extension PortalInspectorViewController: NSTextFieldDelegate {
    
    func controlTextDidChange(_ obj: Notification) {
        
        guard let textField = obj.object as? NSTextField else { return }
        
        coordinator?.textField(textField: textField)
    }
}
