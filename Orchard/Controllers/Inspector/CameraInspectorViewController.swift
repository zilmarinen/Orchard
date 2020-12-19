//
//  CameraInspectorViewController.swift
//  Orchard
//
//  Created by Zack Brown on 07/11/2020.
//

import Cocoa

class CameraInspectorViewController: NSViewController {
    
    @IBOutlet weak var orthographicProjectionButton: NSButton!
    
    weak var coordinator: CameraInspectorCoordinator?
    
    @IBAction func button(_ sender: NSButton) {
        
        guard let inspectable = coordinator?.inspectable else { return }
        
        inspectable.jig.camera?.usesOrthographicProjection = sender.state == .on
        
        coordinator?.refresh()
    }
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        
        coordinator?.refresh()
    }
}
