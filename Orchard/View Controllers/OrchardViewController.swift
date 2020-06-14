//
//  OrchardViewController.swift
//  Orchard
//
//  Created by Zack Brown on 12/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow
import SceneKit
import Terrace

class OrchardViewController: NSViewController {
    
    weak var coordinator: OrchardCoordinator?
    
    var splitViewController: SplitViewController?
}

extension OrchardViewController {
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
            
        case "embedSplitView":
            
            guard let splitViewController = segue.destinationController as? SplitViewController else { fatalError("Invalid segue destination") }
            
            self.splitViewController = splitViewController
            
        default: break
        }
    }
}
