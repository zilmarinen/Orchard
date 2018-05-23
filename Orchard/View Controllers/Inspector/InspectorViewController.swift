//
//  InspectorViewController.swift
//  Orchard
//
//  Created by Zack Brown on 17/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import THRUtilities

class InspectorViewController: NSViewController {
    
    var tabViewController: InspectorTabViewController?
}

extension InspectorViewController: SegueHandlerType {
    
    enum SegueIdentifier: String {
        
        case embedTabView
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        switch segueIdentifier(forSegue: segue) {
            
        case .embedTabView:
            
            guard let tabViewController = segue.destinationController as? InspectorTabViewController else { fatalError("Invalid segue destination") }
            
            self.tabViewController = tabViewController
        }
    }
}
