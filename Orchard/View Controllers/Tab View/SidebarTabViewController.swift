//
//  SidebarTabViewController.swift
//  Orchard
//
//  Created by Zack Brown on 20/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import AppKit

class SidebarTabViewController: NSTabViewController {
    
    weak var coordinator: SidebarTabViewCoordinator?
    
    var inspectorTabViewController: InspectorTabViewController? {
        
        return children.first { return type(of: $0) == InspectorTabViewController.self } as? InspectorTabViewController
    }
    
    var utilityTabViewController: UtilityTabViewController? {
        
        return children.first { return type(of: $0) == UtilityTabViewController.self } as? UtilityTabViewController
    }
}
