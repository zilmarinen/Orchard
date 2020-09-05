//
//  SidebarViewController.swift
//  Orchard
//
//  Created by Zack Brown on 20/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Terrace

class SidebarViewController: NSViewController {
    
    @IBOutlet weak var inspectorButton: NSButton!
    @IBOutlet weak var utilityButton: NSButton!
    
    @IBAction func button(_ sender: NSButton) {
        
        switch sender {
            
        case inspectorButton:
            
            coordinator?.toggle(tab: .inspector)
            
        case utilityButton:
            
            coordinator?.toggle(tab: .utility)
            
        default: break
        }
    }
    
    weak var coordinator: SidebarCoordinator?
    
    var tabViewController: SidebarTabViewController?
}

extension SidebarViewController {
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
            
        case "embedTabView":
            
            guard let tabViewController = segue.destinationController as? SidebarTabViewController else { fatalError("Invalid segue destination") }
            
            self.tabViewController = tabViewController
            
        default: break;
        }
    }
}
