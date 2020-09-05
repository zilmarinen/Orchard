//
//  OrchardWindowController.swift
//  Orchard
//
//  Created by Zack Brown on 12/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import AppKit
import Meadow

class OrchardWindowController: NSWindowController {
    
    static let sceneIdentifier = NSStoryboard.SceneIdentifier("OrchardWindowController")
    
    weak var coordinator: WindowCoordinator?

    @IBAction func segmentedControl(_ sender: NSSegmentedControl) {
        
        let panel = (sender.selectedSegment == 0 ? SplitViewController.Panel.sceneGraph : SplitViewController.Panel.inspector)
        
        coordinator?.toggle(panel: panel)
    }
}
