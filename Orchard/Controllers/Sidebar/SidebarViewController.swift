//
//  SidebarViewController.swift
//  Orchard
//
//  Created by Zack Brown on 03/11/2020.
//

import Cocoa

class SidebarViewController: NSViewController {
    
    enum Constants {
        
        static let segueIdentifier = "embedTabView"
    }
    
    @IBOutlet weak var inspectorButton: NSButton!
    @IBOutlet weak var utilityButton: NSButton!
    
    weak var coordinator: SidebarCoordinator?
    
    var tabViewController: SidebarTabViewController?
    
    @IBAction func button(_ sender: NSButton) {
        
        switch sender {
        
        case inspectorButton:
            
            coordinator?.toggle(sidebar: .inspector)
            
        case utilityButton:
            
            coordinator?.toggle(sidebar: .utility)
            
        default: break
        }
    }
}

extension SidebarViewController {
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Constants.segueIdentifier {
            
            guard let viewController = segue.destinationController as? SidebarTabViewController else { fatalError("Invalid view controller hierarchy") }
            
            tabViewController = viewController
        }
    }
}
