//
//  PropsInspectorViewController.swift
//  Orchard
//
//  Created by Zack Brown on 08/12/2020.
//

import Cocoa
import Meadow

class PropsInspectorViewController: NSViewController {
    
    @IBOutlet weak var gridBox: NSBox!
    @IBOutlet weak var chunkBox: NSBox!
    
    @IBOutlet weak var propCountLabel: NSTextField!
    
    @IBOutlet weak var gridRenderingButton: NSButton!
    @IBOutlet weak var propRenderingButton: NSButton!
    
    @IBOutlet weak var propCoordinateView: CoordinateView! {
        
        didSet {
            
            propCoordinateView.isEnabled = false
        }
    }
    
    @IBAction func button(_ sender: NSButton) {
        
        guard let inspectable = coordinator?.inspectable else { return }
        
        switch sender {
        
        case gridRenderingButton:
            
            inspectable.props.isHidden = sender.state == .off
            
        case propRenderingButton:
            
            inspectable.prop?.isHidden = sender.state == .off
            
        default: break
        }
        
        coordinator?.refresh()
    }
    
    weak var coordinator: PropsInspectorCoordinator?
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        
        coordinator?.refresh()
    }
}

