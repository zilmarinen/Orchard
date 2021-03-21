//
//  InspectorViewController.swift
//
//  Created by Zack Brown on 09/03/2021.
//

import Cocoa

class InspectorViewController: NSViewController {
    
    weak var tabViewController: InspectorTabViewController!
    
    weak var coordinator: InspectorCoordinator?
}

extension InspectorViewController {
    
    enum SegueIdentifier: String {
    
        case embedTabView
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier else { fatalError("Invalid segue identifier") }
        
        switch SegueIdentifier(rawValue: identifier) {
        
        case .embedTabView:
            
            guard let viewController = segue.destinationController as? InspectorTabViewController else { fatalError("Invalid view controller hierarchy") }
            
            tabViewController = viewController
            
        default: break
        }
    }
}
