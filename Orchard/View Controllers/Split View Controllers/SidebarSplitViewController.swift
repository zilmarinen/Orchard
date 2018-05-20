//
//  SidebarSplitViewController.swift
//  Orchard
//
//  Created by Zack Brown on 20/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa

class SidebarSplitViewController: NSSplitViewController {

    enum Panel: Int {
        
        case inspector
        case utilities
    }
    
    var inspectorTabViewController: InspectorTabViewController?
    var utilitiesViewController: UtilitiesViewController?
}

extension SidebarSplitViewController {
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        inspectorTabViewController = childViewControllers.first { return type(of: $0) == InspectorTabViewController.self } as? InspectorTabViewController
        
        utilitiesViewController = childViewControllers.first { return type(of: $0) == UtilitiesViewController.self } as? UtilitiesViewController
    }
}
