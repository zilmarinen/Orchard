//
//  PortalInspectorViewController.swift
//  Orchard
//
//  Created by Zack Brown on 09/12/2020.
//

import Cocoa
import Meadow

class PortalInspectorViewController: NSViewController {
    
    @IBOutlet weak var gridBox: NSBox!
    @IBOutlet weak var chunkBox: NSBox!
    
    @IBOutlet weak var portalCountLabel: NSTextField!
    
    @IBOutlet weak var gridRenderingButton: NSButton!
    @IBOutlet weak var portalRenderingButton: NSButton!
    
    @IBOutlet weak var portalCoordinateView: CoordinateView! {
        
        didSet {
            
            portalCoordinateView.isEnabled = false
        }
    }
    
    @IBAction func button(_ sender: NSButton) {
        
        guard let inspectable = coordinator?.inspectable else { return }
        
        switch sender {
        
        case gridRenderingButton:
            
            inspectable.portals.isHidden = sender.state == .off
            
        case portalRenderingButton:
            
            inspectable.portal?.isHidden = sender.state == .off
            
        default: break
        }
        
        coordinator?.refresh()
    }
    
    weak var coordinator: PortalInspectorCoordinator?
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        
        coordinator?.refresh()
    }
}

